import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// get the database configuration from the Config.toml file
configurable DatabaseConfig databaseConfig = ?;
// create a new mysql client using the database configuration
public final mysql:Client dbClient = check new (...databaseConfig);