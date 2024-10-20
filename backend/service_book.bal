import ballerina/http;
import ballerina/sql;
import ballerinax/mysql.driver as _;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service /book on new http:Listener(8082) {
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

    resource function get wishlist_item/[int wishlist_id]() returns wishlist_item[]|wishlist_item_NotFound|error {
        stream<wishlist_item, sql:Error?> wishlist_item_Stream = dbClient->query(`SELECT * FROM book_exchange.wishlist_item WHERE wishlist_id = ${wishlist_id} `);
        return from var wishlist_item in wishlist_item_Stream
            select wishlist_item;
    }

    resource function get latest_books() returns Book[]|BookNotFound|error {
        stream<Book, sql:Error?> book_Stream = dbClient->query(`
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
