import ballerina/io;

// Class to manage user session information
class Profile {
    string username; 
    boolean admin; 
    boolean customer; 
    boolean guest; 

    // Constructor to initialize a new profile as a guest
    function init() {
        self.username = "Guest";
        self.admin = false;
        self.customer = false;
        self.guest = true;
    }

    // Method to set the username
    function setUserName(string username) {
        self.username = username;
    }

    // Method to set user roles based on input
    function setRole(string role) {
        self.admin = role == "admin";
        self.customer = role == "customer";
        self.guest = role == "guest";
    }

    // Method to display the user profile
    function getProfile() {
        io:println("Username: " + self.username);
        if (self.admin) {
            io:println("Role: Admin");
        } else if (self.customer) {
            io:println("Role: Customer");
        } else {
            io:println("Role: Guest");
        }
    }
}

// Initialize the gRPC client for the online shopping system
OnlineShoppingSystemClient ep = check new ("http://localhost:9090");
Profile profile = new Profile(); // Create a new profile instance

public function main() returns error? {
    io:println("Welcome to the 'Online Shopping System'!");
    io:println("-----------------------------------------\n");

    
    while true {
        string cmd = io:readln("Online-Shopping> ");
        if cmd == "exit" {
            io:println("Goodbye!");
            break; 
        }
        _ = check executeCommand(cmd); 
    }
}

// Function to execute user commands based on input
function executeCommand(string cmd) returns error? {
    match cmd {
        "help" => {
            displayHelp(); // Display help information
        }
        "login" => {
            login(); // Handle user login
        }
        "logout" => {
            profile = new Profile(); // Reset profile to guest
            io:println("Logged out successfully.");
        }
        "profile" => {
            profile.getProfile(); // Display user profile information
        }
        // Admin commands
        "add_product" => {
            if (profile.admin) {
                addProduct(); // Admin adds a new product
            } else {
                io:println("Access denied! Only admins can add products.");
            }
        }
        "create_users" => {
            if (profile.admin) {
                createUsers(); // Admin creates new users
            } else {
                io:println("Access denied! Only admins can create users.");
            }
        }
        "list_users" => {
            if (profile.admin) {
                listUsers(); // Admin lists all users
            } else {
                io:println("Access denied! Only admins can list users.");
            }
        }
        "update_product" => {
            if (profile.admin) {
                updateProduct(); // Admin updates a product
            } else {
                io:println("Access denied! Only admins can update products.");
            }
        }
        "remove_product" => {
            if (profile.admin) {
                removeProduct(); // Admin removes a product
            } else {
                io:println("Access denied! Only admins can remove products.");
            }
        }
        // Customer commands
        "list_available_products" => {
            listAvailableProducts(); // List all available products
        }
        "search_product" => {
            searchProduct(); // Search for a product by SKU
        }
        "add_to_cart" => {
            if (profile.customer) {
                addToCart(); // Customer adds a product to their cart
            } else {
                io:println("Access denied! You must be a customer to add products to your cart.");
            }
        }
        "place_order" => {
            if (profile.customer) {
                placeOrder(); // Customer places an order
            } else {
                io:println("Access denied! You must be a customer to place an order.");
            }
        }
        _ => {
            io:println("Unknown command. Type 'help' for a list of commands."); 
        }
    }
}

// Function to display help information for commands
function displayHelp() {
    io:println("List of available commands:");
    io:println("\n---Authentication---");
    io:println("login   - authenticate to the system");
    io:println("logout  - revoke authorization");
    io:println("profile - print user profile");
    io:println("\n---Admin Commands---");
    io:println("add_product    - The admin creates a new product");
    io:println("create_users   - Create multiple users (customers or admins)");
    io:println("list_users     - Display list of users");
    io:println("update_product - The admin alters product details");
    io:println("remove_product - The admin removes a product from the inventory");
    io:println("\n---Customer Commands---");
    io:println("list_available_products - Get a list of all available products");
    io:println("search_product          - Search for a product by SKU");
    io:println("add_to_cart             - Add a product to the cart");
    io:println("place_order             - Place an order for all products in the cart");
}

// Function to handle user login
function login() {
    string username = io:readln("Username: "); 
    string password = io:readln("Password: "); 
    Login loginRequest = {username: username, password: password}; 
    
    // Call the login endpoint and get the response
    User loginResponse = check ep->login(loginRequest);
    profile.setUserName(loginResponse.username); 
    profile.setRole(loginResponse.isAdmin ? "admin" : "customer"); 
    io:println("Login successful! Welcome, " + profile.username + "!"); 
}

// Function to add a new product (admin only)
function addProduct() {
    io:println("Adding new product...");
    string sku = io:readln("SKU: "); 
    string name = io:readln("Name: "); 
    string price = io:readln("Price: "); 
    string status = io:readln("Status (available/out of stock): "); 
    string description = io:readln("Description: "); 
    string input = io:readln("Stock Quantity: "); 
    int|error stock_quantity = int:fromString(input); 

    // Create product request and send to the server
    Product add_productRequest = {sku: sku, code: 0, name: name, price: price, status: status, description: description, stock_quantity: check stock_quantity};
    int add_productResponse = check ep->add_product(add_productRequest); 
    io:println("Product added successfully! Product Code: " + add_productResponse.toString()); 
}

// Function to create new users (admin only)
function createUsers() {
    io:println("Creating a new user...");
    boolean isAdmin = io:readln("Is this user an admin? (y/N): ") == "y"; 
    string firstName = io:readln("First Name: "); 
    string lastName = io:readln("Last Name: "); 
    string password = io:readln("Password: "); 
    string username = firstName.toLowerAscii().substring(0, 1) + lastName.toLowerAscii(); 

    // Create user request and stream it to the server
    User create_usersRequest = {id: 0, isAdmin: isAdmin, username: username, firstName: firstName, lastName: lastName, password: password};
    Create_usersStreamingClient create_usersStreamingClient = check ep->create_users();
    check create_usersStreamingClient->sendUser(create_usersRequest); 
    check create_usersStreamingClient->complete(); 
    io:println("User created successfully: " + username); 
}

// Function to list all users (admin only)
function listUsers() {
    Users list_usersResponse = check ep->list_users({}); 
    io:println("List of users:");
    io:println(list_usersResponse); 
}

// Function to update a product (admin only)
function updateProduct() {
    io:println("Updating a product...");
    string input = io:readln("Enter product code: "); 
    int|error code = int:fromString(input); 
    string name = io:readln("New Name: "); 
    string sku = io:readln("New SKU: "); 
    string price = io:readln("New Price: "); 
    string status = io:readln("New Status: "); 
    string description = io:readln("New Description: "); 
    string input2 = io:readln("New Stock Quantity: "); 
    int|error stock_quantity = int:fromString(input2); 

    // Create update request and send to the server
    Product update_productRequest = {sku: sku, code: check code, name: name, price: price, status: status, description: description, stock_quantity: check stock_quantity};
    Product update_productResponse = check ep->update_product(update_productRequest); 
    io:println("Product updated successfully!"); 
}

// Function to remove a product (admin only)
function removeProduct() {
    io:println("Removing product from inventory...");
    string input = io:readln("Enter product code: "); 
    int code = check int:fromString(input); 
    Products remove_productResponse = check ep->remove_product(code); // Send request to remove product
    io:println("Product removed successfully!"); 
}

// Function to list available products (customer)
function listAvailableProducts() {
    Products list_available_productResponse = check ep->list_available_products(); // Get list of available products
    io:println("Available products:");
    io:println(list_available_productResponse); // Display the list
}

// Function to search for a product by SKU (customer)
function searchProduct() {
    string sku = io:readln("Enter the SKU of the product: "); 
    Product|error search_productResponse = ep->search_product(sku); // Search for the product
    if (search_productResponse is Product) {
        io:println("Product found!:");
        io:println(search_productResponse); // Display product details
    } else {
        io:println("Product not found or unavailable."); 
    }
}

// Function to add a product to the cart (customer)
function addToCart() {
    io:println("Adding product to cart...");
    string userId = profile.username; // Get current user's ID
    string sku = io:readln("Enter the SKU of the product: "); 
    Cart cartAddRequest = {userId: userId, sku: sku}; // Create request
    int cartAddResponse = check ep->add_to_cart(cartAddRequest); // Send request to add to cart
    io:println("Product added to cart successfully. Cart ID: " + cartAddResponse.toString()); 
}

// Function to place an order (customer)
function placeOrder() {
    io:println("Placing order...");
    string userId = profile.username; // Get current user's ID
    string cartId = io:readln("Enter your cart ID: "); 
    Products placeOrderResponse = check ep->place_order(check int:fromString(cartId)); 
    io:println("Order placed successfully! Order ID: " + placeOrderResponse.toString()); 
}