import ballerina/grpc;
import ballerina/io;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ONLINE_SHOPPING_DESC}
service "OnlineShoppingSystem" on ep {
    private map<Product> products = {};
    private map<Cart> carts = {};
    private map<User> users = {};
    private int code = -1;
    private int id = -1;
    //Admin
    private User admin = {firstName: "Showen", lastName: "Otto", username: "sotto", password: "password", isAdmin:true};

    public function init() {
        self.users[self.admin.username] = self.admin;
        io:println("Initializing...");
    }
    remote function create_users(stream<User, grpc:Error?> clientStream) returns error? {
        int new_id = self.id + 1;
        error? e = clientStream.forEach(function(User user){
            if self.users.hasKey(user.username.clone()){
                string err = "A user with username ${users.username} already exists!";
                io:println(err);
            }
            user.id = new_id;
            self.users[user.username.clone()] = user.clone(); 
        });
        return e;
    }

    remote function add_product(Product value) returns int|error {
        int new_code = self.code + 1;
        Product product ={sku:value.sku, code:new_code, name:value.name, price:value.price, status:value.status, description:value.description, stock_quantity:value.stock_quantity};
        lock {
            if self.products.hasKey(new_code.clone().toString()){
                string err = "Product with code '" + new_code.clone().toString() + "' already exists!";
                return error(err);
            }
            else{
                self.products[new_code.clone().toString()] = product.clone();
                return value.code;
            }
        }
    }

   

    remote function update_product(Product value) returns Product|error {
        Product product ={sku:value.sku, code: value.code, name:value.name, price:value.price, status:value.status, description:value.description, stock_quantity:value.stock_quantity};
        lock {
            if self.products.hasKey(value.code.clone().toString()){
                Product originalProduct = <Product>self.products[value.code.clone().toString()];
                if (product.sku == ""){ product.sku = originalProduct.sku;}
                if (product.name == ""){ product.name = originalProduct.name;}
                if (product.price == ""){ product.price = originalProduct.price;}
                if (product.status == ""){ product.status = originalProduct.status;}
                if (product.description == ""){ product.description = originalProduct.description;}
                if (product.stock_quantity.toString() == ""){ product.stock_quantity = originalProduct.stock_quantity;}
                self.products[value.code.clone().toString()] = product.clone();
            }
            else{
                string err = "Product with code '" + value.code.clone().toString() + "' does not exist!";
                return error(err);
            }
        }
        return product;
    }

    remote function remove_product(int value) returns Products|error {
        int productCode = value;
        lock {
            self.products.forEach(function(Product product){
                if product.code == productCode{
                    _ = self.products.remove(productCode.toString());
                }
            });
        }
        //Updated list
        Product[] productList = [];
        self.products.forEach(function(Product product){
            productList.push(product);
        });
        Products products = {products: productList};
        return products;
    }

    remote function list_available_product() returns Products|error {
        Product[] productList = [];
        lock {
            self.products.forEach(function(Product product){
                productList.push(product);
            });
        }
        Products products = {products: productList};
        return products;
    }

    remote function search_product(string sku) returns Product|error {
        // Iterate over the products using foreach and check for the matching SKU
        Product product_found = {};
        boolean ERROR = true;
        self.products.forEach(function(Product product) {
            if product.sku == sku {
                product_found = product;
                ERROR = false;
            }
        });
        if (ERROR){
            string err = "Product with SKU '" + sku + "' not found!";
            return error(err);
        }
        else{
            return product_found; 
        }
    }

    remote function add_to_cart(Cart value) returns int|error {
        return 1;
    }

    remote function place_order(int value) returns Products|error {
        Products u = {};
        return u;
    }

    
    //Additional functions
    remote function login(Login login) returns User|error{
        if self.users.hasKey(login.username){
            User? user = self.users[login.username];
            
            if user?.password == login.password{
                return user ?: {};
            }
            else{
                return error("Invalid credentials!");
            }
        }
        else{
            return error("User not found!");
        }
    } 
     remote function list_users(Void value) returns Users|error {
        User[] userList = [];
        lock {
            self.users.forEach(function(User user){
                userList.push(user);
            });
        }
        Users users = {users: userList};
        return users;
    }
}

