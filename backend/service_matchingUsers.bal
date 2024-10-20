import ballerina/http;
import ballerina/sql;
import ballerinax/mysql.driver as _;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service /matching_user on new http:Listener(8083) {
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

}