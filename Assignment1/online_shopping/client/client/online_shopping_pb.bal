import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.empty;
import ballerina/protobuf.types.wrappers;

public const string ONLINE_SHOPPING_DESC = "0A156F6E6C696E655F73686F7070696E672E70726F746F12166F6E6C696E655F73686F7070696E675F73797374656D1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22BA010A0750726F6475637412100A03736B751801200128095203736B7512120A04636F64651802200128055204636F646512120A046E616D6518032001280952046E616D6512140A0570726963651804200128095205707269636512160A06737461747573180520012809520673746174757312200A0B6465736372697074696F6E180620012809520B6465736372697074696F6E12250A0E73746F636B5F7175616E74697479180720012805520D73746F636B5175616E7469747922470A0850726F6475637473123B0A0870726F647563747318012003280B321F2E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F64756374520870726F647563747322300A044361727412160A06757365724964180120012809520675736572496412100A03736B751802200128095203736B7522A2010A0455736572120E0A0269641801200128055202696412180A07697341646D696E1802200128085207697341646D696E121A0A08757365726E616D651803200128095208757365726E616D65121C0A0966697273744E616D65180420012809520966697273744E616D65121A0A086C6173744E616D6518052001280952086C6173744E616D65121A0A0870617373776F7264180620012809520870617373776F7264223B0A05557365727312320A05757365727318012003280B321C2E6F6E6C696E655F73686F7070696E675F73797374656D2E5573657252057573657273223F0A054C6F67696E121A0A08757365726E616D651801200128095208757365726E616D65121A0A0870617373776F7264180220012809520870617373776F726422060A04566F696432A4060A144F6E6C696E6553686F7070696E6753797374656D124B0A0B6164645F70726F64756374121F2E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F647563741A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565124C0A0C6372656174655F7573657273121C2E6F6E6C696E655F73686F7070696E675F73797374656D2E557365721A1C2E6F6E6C696E655F73686F7070696E675F73797374656D2E55736572280112490A0A6C6973745F7573657273121C2E6F6E6C696E655F73686F7070696E675F73797374656D2E566F69641A1D2E6F6E6C696E655F73686F7070696E675F73797374656D2E557365727312520A0E7570646174655F70726F64756374121F2E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F647563741A1F2E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F64756374124F0A0E72656D6F76655F70726F64756374121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A202E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F647563747312520A166C6973745F617661696C61626C655F70726F6475637412162E676F6F676C652E70726F746F6275662E456D7074791A202E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F6475637473124F0A0E7365617263685F70726F64756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1F2E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F6475637412480A0B6164645F746F5F63617274121C2E6F6E6C696E655F73686F7070696E675F73797374656D2E436172741A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565124C0A0B706C6163655F6F72646572121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A202E6F6E6C696E655F73686F7070696E675F73797374656D2E50726F647563747312440A056C6F67696E121D2E6F6E6C696E655F73686F7070696E675F73797374656D2E4C6F67696E1A1C2E6F6E6C696E655F73686F7070696E675F73797374656D2E55736572620670726F746F33";

public isolated client class OnlineShoppingSystemClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ONLINE_SHOPPING_DESC);
    }

    isolated remote function add_product(Product|ContextProduct req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/add_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function add_productContext(Product|ContextProduct req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/add_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function list_users(Void|ContextVoid req) returns Users|grpc:Error {
        map<string|string[]> headers = {};
        Void message;
        if req is ContextVoid {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/list_users", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Users>result;
    }

    isolated remote function list_usersContext(Void|ContextVoid req) returns ContextUsers|grpc:Error {
        map<string|string[]> headers = {};
        Void message;
        if req is ContextVoid {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/list_users", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Users>result, headers: respHeaders};
    }

    isolated remote function update_product(Product|ContextProduct req) returns Product|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/update_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Product>result;
    }

    isolated remote function update_productContext(Product|ContextProduct req) returns ContextProduct|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/update_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Product>result, headers: respHeaders};
    }

    isolated remote function remove_product(int|wrappers:ContextInt req) returns Products|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/remove_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Products>result;
    }

    isolated remote function remove_productContext(int|wrappers:ContextInt req) returns ContextProducts|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/remove_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Products>result, headers: respHeaders};
    }

    isolated remote function list_available_product() returns Products|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/list_available_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Products>result;
    }

    isolated remote function list_available_productContext() returns ContextProducts|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/list_available_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Products>result, headers: respHeaders};
    }

    isolated remote function search_product(string|wrappers:ContextString req) returns Product|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/search_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Product>result;
    }

    isolated remote function search_productContext(string|wrappers:ContextString req) returns ContextProduct|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/search_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Product>result, headers: respHeaders};
    }

    isolated remote function add_to_cart(Cart|ContextCart req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        Cart message;
        if req is ContextCart {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/add_to_cart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function add_to_cartContext(Cart|ContextCart req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        Cart message;
        if req is ContextCart {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/add_to_cart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function place_order(int|wrappers:ContextInt req) returns Products|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/place_order", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Products>result;
    }

    isolated remote function place_orderContext(int|wrappers:ContextInt req) returns ContextProducts|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/place_order", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Products>result, headers: respHeaders};
    }

    isolated remote function login(Login|ContextLogin req) returns User|grpc:Error {
        map<string|string[]> headers = {};
        Login message;
        if req is ContextLogin {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/login", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <User>result;
    }

    isolated remote function loginContext(Login|ContextLogin req) returns ContextUser|grpc:Error {
        map<string|string[]> headers = {};
        Login message;
        if req is ContextLogin {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shopping_system.OnlineShoppingSystem/login", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <User>result, headers: respHeaders};
    }

    isolated remote function create_users() returns Create_usersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("online_shopping_system.OnlineShoppingSystem/create_users");
        return new Create_usersStreamingClient(sClient);
    }
}

public client class Create_usersStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveUser() returns User|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <User>payload;
        }
    }

    isolated remote function receiveContextUser() returns ContextUser|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <User>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class OnlineShoppingSystemProductCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProduct(Product response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProduct(ContextProduct response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class OnlineShoppingSystemUserCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUser(User response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUser(ContextUser response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class OnlineShoppingSystemProductsCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProducts(Products response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProducts(ContextProducts response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class OnlineShoppingSystemIntCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt(int response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt(wrappers:ContextInt response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class OnlineShoppingSystemUsersCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUsers(Users response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUsers(ContextUsers response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextProducts record {|
    Products content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextProduct record {|
    Product content;
    map<string|string[]> headers;
|};

public type ContextUsers record {|
    Users content;
    map<string|string[]> headers;
|};

public type ContextLogin record {|
    Login content;
    map<string|string[]> headers;
|};

public type ContextVoid record {|
    Void content;
    map<string|string[]> headers;
|};

public type ContextCart record {|
    Cart content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Products record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type User record {|
    int id = 0;
    boolean isAdmin = false;
    string username = "";
    string firstName = "";
    string lastName = "";
    string password = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Product record {|
    string sku = "";
    int code = 0;
    string name = "";
    string price = "";
    string status = "";
    string description = "";
    int stock_quantity = 0;
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Users record {|
    User[] users = [];
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Login record {|
    string username = "";
    string password = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Void record {|
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Cart record {|
    string userId = "";
    string sku = "";
|};

