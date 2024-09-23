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
Profile profile = new Profile();
OnlineShoppingSystemClient ep = check new ("http://localhost:9090");
// this is to store all the user ids to avoid duplication
int userIdCounter = 0;

// Global map to track existing product codes
map<boolean> productCodes = {};

public function main() returns error? {
    io:println("Welcome to the 'Online Shopping System'!");
    io:println("-----------------------------------------\n");
    
    io:println("Please choose your role:");
    io:println("1. Admin");
    io:println("2. Customer");
    io:println("3. Continue as Guest");
    string roleOption = io:readln("Enter your option (1/2/3): ");

    match roleOption {
        "1" => {
            error? loginResult = login("admin");
        }
        "2" => {
            error? loginResult = login("customer");
        }
        "3" => {
            profile.setRole("guest");
            io:println("You are continuing as a Guest.");
        }
        _ => {
            io:println("Invalid option! Continuing as Guest by default.");
            profile.setRole("guest");
        }
    }

    io:println("Type 'help' to view available commands.\n");
    
    
    
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

function login(string role) returns error? {
    string username = io:readln("Username: ");
    string password = io:readln("Password: ");

    Login loginRequest = {username: username, password: password};
    User loginResponse = check ep->login(loginRequest);

    if role == "admin" && loginResponse.isAdmin {
        profile.setRole("admin");
        profile.setUserName(loginResponse.username);
        io:println("Welcome Admin, " + loginResponse.username);
        error? adminMenuResult = adminMenu();
    } else if role == "customer" && !loginResponse.isAdmin {
        profile.setRole("customer");
        profile.setUserName(loginResponse.username);
        io:println("Welcome Customer, " + loginResponse.username);
        error? customerMenuResult = customerMenu();
    } else {
        io:println("Login failed. Invalid credentials for the selected role.");
        profile.setRole("guest");
        profile.setUserName("Guest");
    }
}
function adminMenu() returns error? {
    io:println("\n--- Admin Actions ---");
    io:println("1. Add a Product");
    io:println("2. List Users");
    io:println("3. Update a Product");
    io:println("4. Remove a Product");
    io:println("5. Create a User");
    io:println("6. Logout");

    while true {
        string choice = io:readln("\nChoose an option (1-6): ");
        match choice {
            "1" => {
                error? product = addProduct();
            }
            "2" => {
                error? listUsersResult = listUsers();
            }
            "3" => {
                error? product = updateProduct();
            }
            "4" => {
                error? removeProductResult = removeProduct();
            }
            "5" => {
                error? user = createUser();  // New function call for creating a user
            }
            "6" => {
                io:println("Logging out...");
                profile = new Profile();  // Reset profile on logout
                return;
            }
            
            _ => {
                io:println("Invalid option! Please choose a valid admin action (1-5).");
            }
        }
    }
}

// Admin command handlers
function addProduct() returns error? {
    io:println("Adding new product...");
    string sku = io:readln("SKU: ");
    string name = io:readln("Name: ");
    string price = io:readln("Price: ");
    string status = io:readln("Status: ");
    string description = io:readln("Description: ");
    string input = io:readln("Stock Quantity: ");
    int|error stock_quantity = int:fromString(input);
    
     // Loop until a unique code is provided
    Product addProductRequest = {
        sku: sku,
        code: -1, 
        name: name, 
        price: price, 
        status: status, 
        description: description, 
        stock_quantity: check stock_quantity
    };
    
    int addProductResponse = check ep->add_product(addProductRequest);
    io:println("Product added successfully with code: " + addProductRequest.toString());
}

function listUsers() returns error? {
    io:println("Listing users...");
    Void listUsersRequest = {};
    Users listUsersResponse = check ep->list_users(listUsersRequest);
    io:println(listUsersResponse);
}

function updateProduct() returns error? {
    io:println("Updating a product...");
    string input1 = io:readln("Enter product code: ");
    int|error code = int:fromString(input1);
    string name = io:readln("Update name: ");
    string sku = io:readln("Update SKU: ");
    string price = io:readln("Update price: ");
    string status = io:readln("Update status: ");
    string description = io:readln("Update description: ");
    string input2 = io:readln("Update stock quantity: ");
    int|error stock_quantity = int:fromString(input2);

    Product updateProductRequest = {sku: sku, code: check code, name: name, price: price, status: status, description: description, stock_quantity: check stock_quantity};
    Product updateProductResponse = check ep->update_product(updateProductRequest);
    io:println("Product updated successfully: " + updateProductResponse.toString());
}

function removeProduct() returns error? {
    io:println("Removing product from inventory...");
    string input = io:readln("Enter product code: ");
    int code = check int:fromString(input);
    Products removeProductResponse = check ep->remove_product(code);
    io:println("Product removed successfully: " + removeProductResponse.toString());
}

function createUser() returns error? {
    io:println("Adding a new user...");
    string input = io:readln("Are you adding an admin(y/N): ");
    boolean isAdmin = false;
    if (input == "y") {
        isAdmin = true;
    }
    string firstName = io:readln("First Name: ");
    string lastName = io:readln("Last Name: ");
    string password = io:readln("Password: ");
    string username = firstName.toLowerAscii().substring(0, 1) + lastName.toLowerAscii();
    // generate a unique 4 digit id
    int userId = generateNextUserId();

    User createUserRequest = {id: userId,
     isAdmin: isAdmin, 
     username: username, 
     firstName: firstName, 
     lastName: lastName,
     password: password
    };
    Create_usersStreamingClient createUsersStreamingClient = check ep->create_users();
    check createUsersStreamingClient->sendUser(createUserRequest);
    check createUsersStreamingClient->complete();
    User? createUserResponse = check createUsersStreamingClient->receiveUser();

    if createUserResponse is User {
        io:println("User created successfully with ID: "+ userId.toString());
        io:println(createUserResponse);
    } else {
        io:println("Failed to create user.");
    }
}

// Generate the next sequential user ID
function generateNextUserId() returns int {
    userIdCounter += 1;
    return userIdCounter;
}



function Cmd(string cmd) returns error?{
    match cmd {
        "help" => {
            help();
        }
        "?" => {
            help();
        }
        "profile" => {
            profile.getProfile();
        }
        "logout" => {
            profile = new Profile();
            io:println("You have been logged out.");
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
                error? adminMenuResult = adminMenu();
            }
            else{
                profile.setRole("customer");
                profile.setUserName(loginResponse.username);
                error? customerMenuResult = customerMenu();
            }
        }
        "logout" => {
            profile = new Profile();
        }
        "profile" => {
            profile.getProfile();
        }
    }
}

        //Customer commands
function customerMenu() returns error? {
    io:println("\n--- Customer Actions ---");
    io:println("1. List available products");
    io:println("2. Search available products");
    io:println("3. Add products to cart");
    io:println("4. Place an order");
    io:println("5. Logout");

    while true {
        string choice = io:readln("\nChoose an option (1-5): ");
        match choice {
            "1" => {
                error? listAvailableproductResponse = list_available_productResponse();
            }
            "2" => {
                search_products();
            }
            "3" => {
                error? tocart = add_to_cart();
            }
            "4" => {
                error? placeOrder = place_order();
            }
            "5" => {
                io:println("Logging out...");
                profile = new Profile();  // Reset profile on logout
                return;
            }
            
            _ => {
                io:println("Invalid option! Please choose a valid admin action (1-5).");
            }
        }
    }
}

function place_order()  returns error? {
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

function add_to_cart() returns error?  {

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

function search_products() {
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

function list_available_productResponse() returns error? {
    Products list_available_productResponse = check ep->list_available_product();
    io:println(list_available_productResponse);
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