import ballerina/http;
import ballerina/time;

// to cofingure the database
type DatabaseConfig record {|
    string host;
    int port;
    string user;
    string password;
    string database;
|};

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
};

type book record {
    int book_id;
    string title;
    string author;
};

type ErrorDetails record {
    string message;
    string details;
    time:Utc timeStamp;
};

type UserPassword record {
    string password;
};

type Book record {
    int book_id;
    string title;
    string author;
    string edition;
    string|null image_path;
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

type UserDetail record {
    string user_name;
    string city;
    string district;
};

type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type BookDetailsByTitleNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

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

type AddressNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

type PhoneNumberNotFound record{|
    *http:NotFound;
    ErrorDetails body;
|};

type UserBookDetail record {
    string user_name;
    string title;
};