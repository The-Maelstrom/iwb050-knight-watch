import ballerina/http;
import ballerina/io;
import ballerina/sql;
import ballerinax/mysql.driver as _;
import ballerina/lang.regexp;
import ballerina/mime;
import ballerina/file;


// Directory where book images will be stored
const string BOOK_IMAGES_DIR = "../frontend/public/images/books/";

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}



service /book on new http:Listener(8082) {
    resource function post addbooks(http:Caller caller, http:Request req) returns error? {
        // Parse the multipart form data
        mime:Entity[] bodyParts = check req.getBodyParts();

        string userIdStr = "";
        string title = "";
        string author = "";
        string edition = "";
        string username = "";
        mime:Entity? imageFilePart = ();

        // Iterate through each part to extract form fields and the image file
        foreach var part in bodyParts {
            mime:ContentDisposition contentDisposition = part.getContentDisposition();
            string partName = contentDisposition.name;

            if (partName == "user_id") {
                userIdStr = check part.getText();
            } else if (partName == "title") {
                title = check part.getText();
            } else if (partName == "author") {
                author = check part.getText();
            } else if (partName == "edition") {
                edition = check part.getText();
            } else if (partName == "username") {
                username = check part.getText();
            } else if (partName == "image") {
                imageFilePart = part;
            }
        }

        int user_id = check int:fromString(userIdStr);

        // Handle the image file if provided
        string? image_path = ();
        if (imageFilePart is mime:Entity) {
            // Sanitize the book title (replace spaces with underscores)
            regexp:RegExp spaceRegex = check regexp:fromString(" ");
            string sanitizedTitle = spaceRegex.replaceAll(title, "_");

            // Create the new image filename (username_booktitle.extension)
            string imageFileName = username + "_" + sanitizedTitle + ".jpg";
            string serverImagePath = BOOK_IMAGES_DIR + imageFileName;

            // Save the uploaded file to the frontend's public directory
            byte[] fileContent = check imageFilePart.getByteArray();
            var saveResult = io:fileWriteBytes(serverImagePath, fileContent);
            if (saveResult is error) {
                check caller->respond({"message": "Failed to save the image file"});
                return;
            }

            // Set the relative image path (this will be accessible from the frontend)
            image_path = "/images/books/" + imageFileName;
            io:println("Image saved to: " + serverImagePath);
        }

        // Prepare the query for the stored procedure with parameterized values to prevent SQL injection
        sql:ParameterizedQuery query;
        if (image_path is string) {
            // If an image path is provided, store the relative path in the database
            query = `CALL ManageUserBook(${user_id}, 'add', ${title}, ${author}, ${edition}, ${image_path})`;
        } else {
            // If no image is provided, pass NULL for the image path
            query = `CALL ManageUserBook(${user_id}, 'add', ${title}, ${author}, ${edition}, NULL)`;
        }

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully added the book
            check caller->respond({"message": "Adding book successfully!"});
        } else {
            // Failed to add the book
            check caller->respond({"message": "Adding book failed!"});
        }
    }


    resource function post removebooks(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            // Invalid JSON payload
            check caller->respond({"message": "Invalid JSON format"});
            return;
        }

        // Log the received payload for debugging
        io:println("Received payload: " + payload.toJsonString());

        // Extract user_id, title, author, edition, username, and image_path from the payload
        int user_id = (check payload.user_id);
        string title = (check payload.title).toString();
        string author = (check payload.author).toString();
        string edition = (check payload.edition).toString();
        string username = (check payload.username).toString();

        // Sanitize the book title (replace spaces with underscores)
        regexp:RegExp spaceRegex = check regexp:fromString(" ");
        string sanitizedTitle = spaceRegex.replaceAll(title, "_");

        // Create the image filename (username_booktitle.jpg)
        string imageFileName = username + "_" + sanitizedTitle + ".jpg";
        string image_path = BOOK_IMAGES_DIR + imageFileName;

        // Check if the image path is provided in the payload
        if (image_path != "") {
            // Delete the image file from the project directory
            var deleteResult = file:remove(image_path);
            if (deleteResult is error) {
                io:println("Failed to delete image: " + deleteResult.message());
            } else {
                io:println("Image deleted: " + image_path);
            }
        }

        // Prepare the query for the stored procedure with parameterized values
        sql:ParameterizedQuery query = `CALL ManageUserBook(${user_id}, 'remove', ${title}, ${author}, ${edition}, NULL)`;

        // Execute the stored procedure
        var result = dbClient->execute(query);

        if (result is sql:ExecutionResult && result.affectedRowCount > 0) {
            // Successfully removed the book
            check caller->respond({"message": "Removing book successfully!"});
        } else {
            // Failed to remove the book
            check caller->respond({"message": "Removing book failed!"});
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

        // Prepare the parameterized query to prevent SQL injection
        sql:ParameterizedQuery query = `SELECT 
                                            b.book_id, 
                                            b.title, 
                                            b.author,
                                            b.edition,
                                            ub.image_path
                                        FROM 
                                            book b
                                        JOIN 
                                            user_book ub ON b.book_id = ub.book_id
                                        JOIN 
                                            user u ON u.user_id = ub.user_id
                                        WHERE 
                                            u.user_id = ${user_id}`;

        // Execute the query with parameterization
        stream<Book, sql:Error?> bookStream = dbClient->query(query);

        // Collect the results
        Book[] books = check from var book in bookStream
                        select book;
        

        return books;
    }
}
