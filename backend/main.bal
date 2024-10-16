import ballerina/crypto;
import ballerina/http;
import ballerina/io;
import ballerina/sql;
import ballerina/time;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// import ballerina/lang.array;

// to cofingure the database
type DatabaseConfig record {|
    string host;
    int port;
    string user;
    string password;
    string database;
|};

// get the database configuration from the Config.toml file
configurable DatabaseConfig databaseConfig = ?;
// create a new mysql client using the database configuration
mysql:Client dbClient = check new (...databaseConfig);

listener http:Listener authListener = new (8080);

//-------------------------------------------- Auth Service --------------------------------------------
type user record {
    readonly int user_id;
    string first_name;
    string last_name;
    string email_address;
    string user_name;
    string password;
    string gender;
};

type user_address record {
    int user_id;
    int address_id;
};

type user_name record {
    string user_name;
};

type email record {
    string email;
};

type address record {
    readonly int address_id;
    string address_line1;
    string address_line2;
    string address_line3;
    string city;
    string district;
};

type phone_number record {
    int user_id;
    string phone_number;
};

type user_book record {
    int user_book_id;
    int user_id;
    int book_id;
    string condition;
};

type book record {
    int book_id;
    string title;
    string author;
    string edition;
};

type ErrorDetails record {
    string message;
    string details;
    time:Utc timeStamp;
};

type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type BookDetailsByTitleNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type UserPassword record {
    string password;
};

type Book record {
    int book_id;
    string title;
    string author;
    string edition;
};

type wishlist_item record {
    int wishlist_item_id;
    int wishlist_id;
    int|null book_id;
    string|null title;
    string|null author;
};

type BookDetailsByTitle record {
    int book_id;
    string title;
    string author;
    string edition;
    int user_id;
    string user_name;
};

type request record {
    int request_id;
    int requestor_id;
    int receiver_id;
    int requestor_book_id;
    int receiver_book_id;
    string request_date;
    string request_status;
    string|null response_date;
    string|null confirmation_date;
};

type request_accept record {
    int request_accept_id;
    string acceptor_user_name;
    string seen;
    string receiver_user_name;
};

type RequestNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type BookNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type wishlist_item_NotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type UserDetail record {
    string user_name;
    string city;
    string district;
};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}

service /auth on authListener {

    resource function post matchingUsers(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        int currentUserId = check payload.currentUserId;
        int selectedBookId = check payload.selectedBookId;

        // Prepare the query for the stored procedure
        sql:ParameterizedQuery query = `CALL GetMatchingUsersForExchange(${currentUserId}, ${selectedBookId})`;

        // Execute the stored procedure
        stream<UserDetail, sql:Error?> resultStream = dbClient->query(query);

        // Initialize an array to hold the results
        UserDetail[] userDetails = [];

        // Iterate through the result stream and collect the results
        error? e = resultStream.forEach(function(UserDetail userDetail) {
            userDetails.push(userDetail);
        });

        // Check for errors during iteration
        if (e is error) {
            return e;
        }

        // Return the results as JSON
        check caller->respond(userDetails);
    }

    resource function post signup(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Extracting user details
        string first_name = (check payload.first_name).toString();
        string last_name = (check payload.last_name).toString();
        string email_address = (check payload.email_address).toString();
        string username = (check payload.user_name).toString();
        string password = (check payload.password).toString();
        string gender = (check payload.gender).toString();
        string phone_number1 = (check payload.phone_number1).toString();

        // Extract address 1
        string address_line1_1 = (check payload.address_line1_1).toString();
        string address_line2_1 = (check payload.address_line2_1).toString();
        string address_line3_1 = (check payload.address_line3_1).toString();
        string city_1 = (check payload.city_1).toString();
        string district_1 = (check payload.district_1).toString();
        string postal_code_1 = (check payload.postal_code_1).toString();

        // Hash the user's password
        byte[] hashedPasswordBytes = crypto:hashSha256(password.toBytes());
        string hashedPassword = hashedPasswordBytes.toBase16();

        // Check if username already exists
        string[]|UserNotFound|error existingUsernames = user_names();
        if existingUsernames is error {
            check caller->respond({"message": "Error checking username availability"});
            return;
        }

        if existingUsernames is string[] && existingUsernames.indexOf(username) != () {
            check caller->respond({"message": "Username already exists"});
            return;
        }

        // If we reach here, the username doesn't exist or there are no users
        io:println("Username is available, proceeding with registration");

        // Check if email already exists
        string[]|UserNotFound|error existingEmails = emails();
        if existingEmails is error {
            check caller->respond({"message": "Error checking email availability"});
            return;
        }

        if existingEmails is string[] && existingEmails.indexOf(email_address) != () {
            check caller->respond({"message": "Email address already exists"});
            return;
        }

        // If we reach here, both the username and email don't exist or there are no users
        io:println("Username and email are available, proceeding with registration");

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL CreateUser(${first_name}, ${last_name}, ${email_address}, ${username}, ${hashedPassword}, ${gender}, ${phone_number1},
                          ${address_line1_1}, ${address_line2_1}, ${address_line3_1}, ${city_1}, ${district_1}, ${postal_code_1})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully registered the user
            check caller->respond({"message": "User registered successfully!"});
        } else {
            // Failed to register the user
            check caller->respond({"message": "User registration failed!"});
        }
    }

    resource function post login(http:Caller caller, http:Request req) returns error? {
        //Extract JSON payload from the request
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }
        // Get username and password from the request
        string user_name = (check payload.user_name).toString();
        string password = (check payload.password).toString();

        // Query to retrieve the hashed password from the database
        sql:ParameterizedQuery query = `SELECT password FROM user WHERE user_name = ${user_name}`;

        // Use `query` to fetch the result with the defined row type
        UserPassword|sql:Error result = dbClient->queryRow(query, UserPassword);

        if (result is sql:NoRowsError) {
            check caller->respond({"message": "User does not exist"});
            return;
        } else if (result is UserPassword) {
            string storedHashedPassword = result.password;

            // Hash the incoming password using the same hashing algorithm (SHA-256)
            byte[] hashedPasswordBytes = crypto:hashSha256(password.toBytes());
            string hashedPassword = hashedPasswordBytes.toBase16();

            // Compare the provided hashed password with the stored hashed password
            if (hashedPassword == storedHashedPassword) {
                check caller->respond({"message": "Login successful!"});
            } else {
                check caller->respond({"message": "Invalid username or password!"});
            }
        } else {
            // Error occurred while executing the query
            check caller->respond({"message": "Query failed!"});
        }
    }

    // resource function post addbooks(http:Caller caller, http:Request req) returns error? {
    //     json payload;
    //     var jsonResult = req.getJsonPayload();
    //     if (jsonResult is json) {
    //         payload = jsonResult;
    //     } else {
    //         // Invalid JSON payload
    //         check caller->respond({"message": "Invalid JSON format"});
    //         return;
    //     }

    //     // Extract action, title, author, and edition from the payload
    //     string action = (check payload.action).toString();
    //     string title = (check payload.title).toString();
    //     string author = (check payload.author).toString();
    //     string edition = (check payload.edition).toString();

    //     int user_id = (check payload.user_id);

    //     // Prepare the query for the stored procedure with parameterized values
    //     sql:ParameterizedQuery query = `CALL ManageUserBook(${user_id}, ${action}, 
    //                                     ${title}, ${author}, ${edition})`;

    //     // Execute the stored procedure
    //     var result = dbClient->execute(query);

    //     if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
    //         // Successfully registered the user
    //         check caller->respond({"message": "Adding book successfully!"});
    //     } else {
    //         // Failed to register the user
    //         check caller->respond({"message": "Adding book failed!"});
    //     }
    // }
    resource function post managebooks(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Extract action, title, author from the payload
        int user_id = (check payload.user_id);
        string action = (check payload.action).toString();
        string title = (check payload.title).toString();
        string author = (check payload.author).toString();

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL ManageUserBook(${user_id}, ${action}, ${title}, ${author})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            if (action == "add") {
                // Successfully added the book
                check caller->respond({"message": "Adding book successfully!"});
            } else if (action == "remove") {
                // Successfully removed the book
                check caller->respond({"message": "Removing book successfully!"});
            }
        } else {
            if (action == "add") {
                // Failed to add the book
                check caller->respond({"message": "Adding book failed!"});
            } else if (action == "remove") {
                // Failed to remove the book
                check caller->respond({"message": "Removing book failed!"});
            }
        }
    }

    resource function post makerequest(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Extract action, title, author, and edition from the payload
        int requestor_id = (check payload.requestor_id);
        int receiver_id = (check payload.receiver_id);
        int requestor_book_id = (check payload.requestor_book_id);
        int receiver_book_id = (check payload.receiver_book_id);

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL InsertRequest(${requestor_id}, ${receiver_id}, 
                                        ${requestor_book_id}, ${receiver_book_id})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully registered the user
            check caller->respond({"message": "Inserting a request successfully!"});
        } else {
            // Failed to register the user

            check caller->respond({"message": "Inserting a request failed!"});
        }
    }

    resource function post acceptrequest(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Extract action, title, author, and edition from the payload
        int requestor_id = (check payload.requestor_id);
        int receiver_id = (check payload.receiver_id);
        int requestor_book_id = (check payload.requestor_book_id);
        int receiver_book_id = (check payload.receiver_book_id);

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL UpdateRequestAndAccept(${requestor_id}, ${receiver_id}, 
                                        ${requestor_book_id}, ${receiver_book_id})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully registered the user
            check caller->respond({"message": "Request accepted successfully!"});
        } else {
            // Failed to register the user
            check caller->respond({"message": "Request accepted failed!"});
        }
    }

    resource function post confirmrequest(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Extract action, title, author, and edition from the payload
        int requestor_id = (check payload.requestor_id);
        int receiver_id = (check payload.receiver_id);
        int requestor_book_id = (check payload.requestor_book_id);
        int receiver_book_id = (check payload.receiver_book_id);

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL UpdateRequestAndConfirm(${requestor_id}, ${receiver_id}, 
                                        ${requestor_book_id}, ${receiver_book_id})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully registered the user
            check caller->respond({"message": "Request confirmed successfully!"});
        } else {
            // Failed to register the user
            check caller->respond({"message": "Request confirmed failed!"});
        }
    }

    resource function post ManageWishlistItem(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Extract action, title, author, and edition from the payload
        string action = (check payload.action).toString();
        int user_id = (check payload.user_id);
        string title = (check payload.title).toString();
        string author = (check payload.author).toString();

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL ManageWishlistItem(${user_id}, 
                                        ${title}, ${author}, ${action})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (action == "add") {
            if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
                // Successfully registered the user
                check caller->respond({"message": "Inserting a book to wishlist successfully!"});
            } else {
                // Failed to register the user
                check caller->respond({"message": "Inserting a book to wishlist failed!"});
            }
        }
        else {
            if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
                // Successfully registered the user
                check caller->respond({"message": "Removing a book from wishlist successfully!"});
            } else {
                // Failed to register the user
                check caller->respond({"message": "Removing a book from wishlist failed!"});
            }
        }
    }

    resource function get user_id/[string user_name]() returns int|UserNotFound|error {
        int|sql:Error user_id = dbClient->queryRow(`SELECT user_id FROM book_exchange.user WHERE user_name = ${user_name}`);
        if user_id is sql:NoRowsError {
            UserNotFound userNotFound = {
                body: {message: string `user_name: ${user_name}`, details: string `user/${user_name}`, timeStamp: time:utcNow()}
            };
            return userNotFound;
        }
        return user_id;
    }

    resource function get pending_requests/[int receiver_id]() returns request[]|RequestNotFound|error {
        stream<request, sql:Error?> requestStream = dbClient->query(`
        SELECT 
            r.*, 
            rb1.title AS requestor_book_title, 
            rb1.author AS requestor_book_author, 
            rb2.title AS receiver_book_title, 
            rb2.author AS receiver_book_author,
            u1.user_name AS requestor_user_name, 
            u2.user_name AS receiver_user_name 
        FROM 
            book_exchange.request r
        JOIN 
            book_exchange.book rb1 ON r.requestor_book_id = rb1.book_id
        JOIN 
            book_exchange.book rb2 ON r.receiver_book_id = rb2.book_id
        JOIN 
            book_exchange.user u1 ON r.requestor_id = u1.user_id
        JOIN
            book_exchange.user u2 ON r.receiver_id = u2.user_id    
        WHERE 
            r.receiver_id = ${receiver_id} 
            AND r.request_status = 'pending'
    `);
        return from var request in requestStream
            select request;
    }

    resource function get confirmed_requests/[int user_id]() returns request[]|RequestNotFound|error {
        stream<request, sql:Error?> requestStream = dbClient->query(`
        SELECT 
    r.*, 
    rb1.title AS requestor_book_title, 
    rb1.author AS requestor_book_author, 
    rb2.title AS receiver_book_title, 
    rb2.author AS receiver_book_author,
    u1.user_name AS requestor_user_name, 
    u2.user_name AS receiver_user_name,
    u1.phone_number AS requestor_phone_number, 
    u2.phone_number AS receiver_phone_number
FROM 
    book_exchange.request r
JOIN 
    book_exchange.book rb1 ON r.requestor_book_id = rb1.book_id
JOIN 
    book_exchange.book rb2 ON r.receiver_book_id = rb2.book_id
JOIN 
    book_exchange.user u1 ON r.requestor_id = u1.user_id
JOIN 
    book_exchange.user u2 ON r.receiver_id = u2.user_id
LEFT JOIN 
    book_exchange.phone_number pn1 ON u1.user_id = pn1.user_id
LEFT JOIN 
    book_exchange.phone_number pn2 ON u2.user_id = pn2.user_id
WHERE 
    r.receiver_id = ${user_id}
    OR r.requestor_id = ${user_id}
AND 
    r.request_status = 'confirmed'
;

    `);
        return from var request in requestStream
            select request;
    }

    resource function get accepted_requests/[int requestor_id]() returns request[]|RequestNotFound|error {
        stream<request, sql:Error?> requestStream = dbClient->query(`
        SELECT 
            r.*, 
            rb1.title AS requestor_book_title, 
            rb1.author AS requestor_book_author, 
            rb2.title AS receiver_book_title, 
            rb2.author AS receiver_book_author 
        FROM 
            book_exchange.request r
        JOIN 
            book_exchange.book rb1 ON r.requestor_book_id = rb1.book_id
        JOIN 
            book_exchange.book rb2 ON r.receiver_book_id = rb2.book_id
        WHERE 
            r.requestor_id = ${requestor_id} 
            AND r.request_status = 'accepted'
    `);
        return from var request in requestStream
            select request;
    }

    resource function get wishlist_item/[int wishlist_id]() returns wishlist_item[]|wishlist_item_NotFound|error {
        stream<wishlist_item, sql:Error?> wishlist_item_Stream = dbClient->query(`SELECT * FROM book_exchange.wishlist_item WHERE wishlist_id = ${wishlist_id} `);
        return from var wishlist_item in wishlist_item_Stream
            select wishlist_item;
    }

    resource function get latest_books() returns book[]|BookNotFound|error {
        stream<book, sql:Error?> book_Stream = dbClient->query(`
        SELECT * FROM book_exchange.book
        ORDER BY book_id DESC 
        LIMIT 15`);
        return from var book in book_Stream
            select book;
    }

   

    resource function get GetBookDetailsByTitle/[string title]() returns BookDetailsByTitle[]|BookDetailsByTitleNotFound|error {

        // Prepare the query to fetch book details by title
        stream<BookDetailsByTitle, sql:Error?> bookDetailsByTitleStream = dbClient->query(`
        SELECT 
            b.book_id,
            b.title,
            b.author,
            b.edition,
            ub.user_id,
            u.user_name
        FROM 
            book b
        LEFT JOIN 
            user_book ub ON b.book_id = ub.book_id
        LEFT JOIN 
            user u ON ub.user_id = u.user_id
        WHERE 
            b.title = ${title}
    `);
        // If no error, stream and return the book details
        return from var bookDetails in bookDetailsByTitleStream
            select bookDetails;
    }

    resource function get books_for_specific_user/[int user_id]() returns Book[]|BookNotFound|error {

        // Prepare the query to fetch book details by title
        stream<Book, sql:Error?> bookStream = dbClient->query(`
                SELECT 
                    b.book_id, 
                    b.title, 
                    b.author
                FROM 
                    book b
                JOIN 
                    user_book ub ON b.book_id = ub.book_id
                JOIN 
                    user u ON u.user_id = ub.user_id
                WHERE 
                    u.user_id = ${user_id}
                `);
        // If no error, stream and return the books
        return from var book in bookStream
            select book;
    }

}


function user_names() returns string[]|UserNotFound|error {
    stream<record {|string user_name;|}, sql:Error?> userStream = dbClient->query(`SELECT user_name FROM book_exchange.user`);
    string[] usernames = check from var {user_name} in userStream
        select user_name;

    // if usernames.length() == 0 {
    //     return UserNotFound();
    // }
    return usernames;
}

function emails() returns string[]|UserNotFound|error {
    stream<record {|string email_address;|}, sql:Error?> emailStream = dbClient->query(`SELECT email_address FROM book_exchange.user`);
    string[] emails = check from var {email_address} in emailStream
        select email_address;

    // if emails.length() == 0 {
    //     return UserNotFound();
    // }
    return emails;
}
