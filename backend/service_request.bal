import ballerina/http;
import ballerina/sql;
import ballerinax/mysql.driver as _;
import ballerina/log;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service /request on new http:Listener(8081) {
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
        log:printInfo("Received payload: " + payload.toJsonString());

        // Extract action, title, author, and edition from the payload
        int requestor_id = (check payload.requestor_id);
        int receiver_id = (check payload.receiver_id);
        int requestor_book_id = (check payload.requestor_book_id);
        int receiver_book_id = (check payload.receiver_book_id);

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL UpdateRequestAndAccept(${requestor_id}, ${receiver_id}, 
                                        ${requestor_book_id}, ${receiver_book_id}, 'accept')`;


        
        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully registered the user
            check caller->respond({"message": "Request accepted successfully!"});
        } else {
            // SQL execution error
            check caller->respond({"message": "Failed to accept request"});
        }
        
    }

    resource function post rejectrequest(http:Caller caller, http:Request req) returns error? {
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
                                        ${requestor_book_id}, ${receiver_book_id}, 'reject')`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully updated the request
            check caller->respond({"message": "Request rejected successfully"});
        } else if (result is sql:ExecutionResult) {
            // No rows affected
            check caller->respond({"message": "No request found to reject"});
        } else {
            // SQL execution error
            check caller->respond({"message": "Failed to reject request"});
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

        // Extract requestor_id, receiver_id, requestor_book_id, and receiver_book_id from the payload
        int requestor_id = (check payload.requestor_id);
        int receiver_id = (check payload.receiver_id);
        int requestor_book_id = (check payload.requestor_book_id);
        int receiver_book_id = (check payload.receiver_book_id);

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL UpdateRequestAndConfirm(${requestor_id}, ${receiver_id}, 
                                        ${requestor_book_id}, ${receiver_book_id}, 'confirm')`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully confirmed the request
            check caller->respond({"message": "Request confirmed successfully!"});
        } else if (result is sql:ExecutionResult) {
            // No rows affected
            check caller->respond({"message": "No request found to confirm"});
        } else {
            // SQL execution error
            log:printError("Error executing SQL query", result);
            check caller->respond({"message": "Failed to confirm request"});
        }
    }

    resource function post cancelrequest(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Extract requestor_id, receiver_id, requestor_book_id, and receiver_book_id from the payload
        int requestor_id = (check payload.requestor_id);
        int receiver_id = (check payload.receiver_id);
        int requestor_book_id = (check payload.requestor_book_id);
        int receiver_book_id = (check payload.receiver_book_id);

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL UpdateRequestAndConfirm(${requestor_id}, ${receiver_id}, 
                                        ${requestor_book_id}, ${receiver_book_id}, 'cancel')`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully cancelled the request
            check caller->respond({"message": "Request cancelled successfully!"});
        } else if (result is sql:ExecutionResult) {
            // No rows affected
            check caller->respond({"message": "No request found to cancel"});
        } else {
            // SQL execution error
            log:printError("Error executing SQL query", result);
            check caller->respond({"message": "Failed to cancel request"});
        }
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
            pn1.phone_number AS requestor_phone_number, 
            pn2.phone_number AS receiver_phone_number
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
            book_exchange.phone_number pn1 ON r.requestor_id = pn1.user_id
        LEFT JOIN 
            book_exchange.phone_number pn2 ON r.receiver_id  = pn2.user_id
        WHERE 
            r.receiver_id = ${user_id}
            OR r.requestor_id = ${user_id}
        AND 
            r.request_status = 'confirmed'
        ;`);
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
            r.requestor_id = ${requestor_id} 
            AND r.request_status = 'accepted'
    `);
        return from var request in requestStream
            select request;
    }

}
