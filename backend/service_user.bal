import ballerina/crypto;
import ballerina/http;
import ballerina/io;
import ballerina/sql;
import ballerina/time;
import ballerinax/mysql.driver as _;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}

service /auth on new http:Listener(8080){
    
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


    resource function post updateUserAddress(http:Caller caller, http:Request req) returns error? {
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
        string address_line1 = (check payload.address_line1).toString();
        string address_line2 = (check payload.address_line2).toString();
        string address_line3 = (check payload.address_line3).toString();
        string city = (check payload.city).toString();
        string district = (check payload.district).toString();
        string postal_code = (check payload.postal_code).toString();
        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL UpdateUserAddress(${user_id}, 
                                    ${address_line1}, ${address_line2}, 
                                    ${address_line3} , ${city} , 
                                    ${district}, ${postal_code})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully updated the address
            check caller->respond({"message": "Updated the address successfully!"});
        } else {
            // Failed to update the address
            check caller->respond({"message": "Updating the address failed!"});
        }
    }

    resource function post UpdatePhoneNumber(http:Caller caller, http:Request req) returns error? {
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
        string phone_number = (check payload.phone_number).toString();
        
        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL UpdatePhoneNumber(${user_id}, ${phone_number})`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully updated the phone_number
            check caller->respond({"message": "Updated the phone_number successfully!"});
        } else {
            // Failed to update the phone_number
            check caller->respond({"message": "Updating the phone_number failed!"});
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
    resource function get address/[int user_id]() returns address|AddressNotFound|error {
        address|sql:Error address = dbClient->queryRow(`
        SELECT a.address_line1, a.address_line2, a.address_line3, a.city, a.district, a.postal_code
        FROM address a
        JOIN user_address ua ON a.address_id = ua.address_id
        WHERE ua.user_id =${user_id};
        `);
        if address is sql:NoRowsError {
            AddressNotFound addressNotFound = {
                body: {message: string `user_id: ${user_id}`, details: string `user/${user_id}`, timeStamp: time:utcNow()}
            };
            return addressNotFound;
        }
        return address;
    }

    resource function get phone_number/[int user_id]() returns phone_number|PhoneNumberNotFound|error {
        phone_number|sql:Error phone_number = dbClient->queryRow(`
        SELECT phone_number
        FROM phone_number
        WHERE user_id =${user_id};
        `);
        if phone_number is sql:NoRowsError {
            PhoneNumberNotFound phoneNumberNotFound = {
                body: {message: string `user_id: ${user_id}`, details: string `user/${user_id}`, timeStamp: time:utcNow()}
            };
            return phoneNumberNotFound;
        }
        return phone_number;
    }

    
    

}


function user_names() returns string[]|UserNotFound|error {
    stream<record {|string user_name;|}, sql:Error?> userStream = dbClient->query(`SELECT user_name FROM book_exchange.user`);
    string[] usernames = check from var {user_name} in userStream
        select user_name;

    return usernames;
}

function emails() returns string[]|UserNotFound|error {
    stream<record {|string email_address;|}, sql:Error?> emailStream = dbClient->query(`SELECT email_address FROM book_exchange.user`);
    string[] emails = check from var {email_address} in emailStream
        select email_address;
    return emails;
}