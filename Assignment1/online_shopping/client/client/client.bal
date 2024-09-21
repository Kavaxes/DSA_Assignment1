import ballerina/io;

//Created Profile class for User Session Management
class Profile {
    string username;
    boolean admin;
    boolean customer;
    boolean guest;

     function init() {
        self.username = "Guest";
        self.admin = false;
        self.customer = false;
        self.guest = true;
    }

    function setUserName(string username){
        self.username = username;
    }
    function setRole(string role){
        if (role == "admin"){
            self.admin = true;
            self.customer = false; //Reset other roles
            self.guest = false;
        }
        if (role == "customer"){
            self.customer = true;
            self.admin = false; //Reset other roles
            self.guest = false;
        }
        if (role == "guest"){
            self.guest = true;
            self.admin = false; //Reset other roles
            self.customer = false;
        }
        
    }
    function getProfile () {
        io:println("Username: " + self.username);
        if (self.admin){
            io:println("Role: Admin");
        }
        if (self.customer){
            io:println("Role: Customer");
        }
        if (self.guest){
            io:println("Role: Guest");
        }
    }
}
OnlineShoppingSystemClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    io:println("Welcome to the 'Online Shopping System'!");
    io:println("-----------------------------------------\n");
    while true {
        string cmd = io:readln("Online-Shopping> ");
        if cmd == "exit" {
            io:println("Goodbye!");
            break;
        }
        _ = check Cmd(cmd);
    }

    //Cart add_to_cartRequest = {userId: "ballerina", sku: "ballerina"};
    //int add_to_cartResponse = check ep->add_to_cart(add_to_cartRequest);
    //io:println(add_to_cartResponse);

    //int place_orderRequest = 1;
    //Products place_orderResponse = check ep->place_order(place_orderRequest);
    //io:println(place_orderResponse);
}

Profile profile = new Profile();


function Cmd(string cmd) returns error?{
    match cmd {
        "help" => {
            help();
        }
        "?" => {
            help();
        }
        //Authentication
        "login" => {
            profile.setRole("admin");
            string username = io:readln("Username: ");
            string password = io:readln("Password: ");
            Login loginRequest = {username: username, password: password};
            User loginResponse = check ep->login(loginRequest);
            if loginResponse.isAdmin{
               profile.setRole("admin");
                profile.setUserName(loginResponse.username);
            }
            else{
                profile.setRole("customer");
                profile.setUserName(loginResponse.username);
            }
        }
        "logout" => {
            profile = new Profile();
        }
        "profile" => {
            profile.getProfile();
        }
        //Admin commands
        "add_product" => {
            if (profile.admin){
                io:println("Adding new product...");
                string sku = io:readln("SKU: ");
                string name = io:readln("Name: ");
                string price = io:readln("Price: ");
                string status = io:readln("Status: ");
                string description = io:readln("Description: ");
                string input = io:readln("Stock Quantity: ");
                int|error stock_quantity = int:fromString(input);

                Product add_productRequest = {sku: sku, code: 0, name: name, price: price, status: status, description: description, stock_quantity: check stock_quantity};
                int add_productResponse = check ep->add_product(add_productRequest);
                io:println(add_productResponse);
            }
            else{
                io:println("Access denied!");
            }
        }
        "create_users" => {
            if (profile.admin){
                io:println("Adding a new user...");
                string input = io:readln("Admin (y/N): ");
                boolean isAdmin = false;
                if (input == "y"){
                    isAdmin = true;
                }
                string firstName = io:readln("firstName: ");
                string lastName = io:readln("lastName: ");
                string password = io:readln("Password: ");
                string username = firstName.toLowerAscii().substring(0,1) + lastName.toLowerAscii();

                User create_usersRequest = {id: 0, isAdmin: isAdmin, username: username, firstName: firstName, lastName: lastName, password: password};
                Create_usersStreamingClient create_usersStreamingClient = check ep->create_users();
                check create_usersStreamingClient->sendUser(create_usersRequest);
                check create_usersStreamingClient->complete();
                User? create_usersResponse = check create_usersStreamingClient->receiveUser();
                io:println(create_usersResponse);
            }
            else{
                io:println("Access denied!");
            }
            
        }
        "list_users" => {
            if (profile.admin){
                Void list_usersRequest = {};
                Users list_usersResponse = check ep->list_users(list_usersRequest);
                io:println(list_usersResponse);
            }
            else{
                io:println("Access denied!");
            }
        }
        "update_product" => {
            if (profile.admin){
                io:println("Updating a product...");
                string input1 = io:readln("Enter product's code: ");
                int|error code  = int:fromString(input1);
                string name = io:readln("Update name: ");
                string sku = io:readln("Update SKU: ");
                string price = io:readln("Update price: ");
                string status = io:readln("Update status: ");
                string description = io:readln("Update description: ");
                string input2 = io:readln("Update stock quantity: ");
                int|error stock_quantity = int:fromString(input2);

                Product update_productRequest = {sku: sku, code: check code, name: name, price: price, status: status, description: description, stock_quantity: check stock_quantity};
                Product update_productResponse = check ep->update_product(update_productRequest);
                io:println(update_productResponse);
            }
            else{
                io:println("Access denied!");
            }
        }
        "remove_product" => {
            io:println("Removing product from inventory...");
            string input = io:readln("Enter product code: ");
            int code = check int:fromString(input);
            Products remove_productResponse = check ep->remove_product(code);
            io:println(remove_productResponse);
        }

        //Customer commands
        "list_available_products" => {
            Products list_available_productResponse = check ep->list_available_product();
            io:println(list_available_productResponse);
        }
        "search_product" => {
            string sku = io:readln("Enter the SKU of the product: ");
            Product|error search_productResponse = ep->search_product(sku);
            if (search_productResponse is Product) {
                io:println("Product found:");
                io:println(search_productResponse);
            }  
            else {
                io:println("Product not found or unavailable.");
            }
        }
        "add_to_cart" => {
            if (profile.customer) {
                io:println("Adding product to cart...");
                string userId = profile.username;
                string sku = io:readln("Enter the SKU of the product: ");
                Cart cartAddRequest = {userId: userId, sku: sku};
                int cartAddResponse = check ep->add_to_cart(cartAddRequest);
                io:println("Product added to cart successfully. Cart ID: " + cartAddResponse.toString());
                }
            else {
                io:println("Access denied! You must be a customer to add products to cart.");
            }
        }
       "place_order" => {
    if (profile.customer) {
        io:println("Placing order...");
        string userId = profile.username;
        // Retrieve cart ID from user
        string cartId = io:readln("Enter your cart ID: ");
        // Call the place_order endpoint
        //Order placeOrderResponse = check ep->place_order(userId, cartId);
        Products placeOrderResponse = check ep->place_order(check int:fromString(cartId));
        //io:println("Order placed successfully. Order ID: " + placeOrderResponse.orderId);
        io:println("Order placed successfully. Order ID: " + placeOrderResponse.toString());
    } else {
        io:println("Access denied! You must be a customer to place an order.");
    }
}

           }   
    }



function help(){
    io:println("List of available commands:");
    io:println("\n---Authentication---");
    io:println("login   - authenticate to the system");
    io:println("logout  - revoke authorization");
    io:println("profile - print user profile");
    io:println("\n---Admin---");
    io:println("add_product    - The admin creates a new product");
    io:println("create_users   - Multiple users (customers or admins) each with a specific profile are created");
    io:println("list_users     - Display list of users");
    io:println("update_product - The admin alters the details of a given product");
    io:println("remove_product - The admin removes a product from the inventory ");
    io:println("\n---Customer---");
    io:println("list_available_products - The customer gets a list of all the available products");
    io:println("search_product          - The customer searches for a product based on its SKU");
    io:println("add_to_cart             - The customer adds a product to their cart by providing their user ID and the product's SKU");
    io:println("place_order             - The customer places an order for all products in their cart\n");
}