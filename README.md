# 📚 Book Buddies

Book Buddies is a book exchanging platform created for the Innovate with Ballerina 2024 competition. This project uses React, HTML, and CSS for the frontend, Ballerina for the backend, and MySQL for the database.

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:
- Git
- Node.js and npm
- Ballerina
- MySQL

## 🚀 Getting Started

Follow these steps to set up and run the Book Buddies platform locally:

1. Clone the repository:
   ```
   git clone https://github.com/The-Maelstrom/iwb050-knight-watch.git
   cd iwb050-knight-watch
   ```

2. Import the database:
   - Locate the `book_exchange.sql` file in the project directory.
   - Import it into your MySQL database:
     ```
     mysql -u your_username -p your_database_name < book_exchange.sql
     ```

3. Configure the backend:
   - Open the `Config.toml` file in the `backend` directory.
   - Update the database configuration:
     ```toml
     [databaseConfig]
     database = "book_exchange"
     user =  "Your MySQL username"
     password =  "Your MySQL password"
     host =  "Host (usually 'localhost')"
     port =  "MySQL default port (usually 3306)"
     ```

4. Start the backend server:
   - Open a terminal and navigate to the `backend` directory.
   - Run the following command:
     ```
     bal run
     ```

5. Set up the frontend:
   - Open a new terminal and navigate to the `frontend` directory.
   - Install dependencies:
     ```
     npm i
     ```
   - Start the frontend server:
     ```
     npm start
     ```

The Book Buddies platform should now be running locally. Open your web browser and visit `http://localhost:3000` (or the port specified by your frontend setup) to access the application.

## 🤝 Contributing

We welcome contributions to the Book Buddies project! To contribute:

1. Fork the repository on GitHub.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with descriptive commit messages.
4. Push your changes to your fork.
5. Submit a pull request to the main repository.

Please ensure your code adheres to the project's coding standards and include appropriate tests if applicable.

## 📄 License

This project is licensed under the MIT License. This means you are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, subject to the following conditions:

- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
- The software is provided "as is", without warranty of any kind, express or implied.

For more details, see the [MIT License](https://opensource.org/licenses/MIT).

## 📬 Contact

For any questions or concerns, please feel free to contact any team member:

- pererabsdt: dulitha.22@cse.mrt.ac.lk
- Sithum-Bimsara: sithum.22@cse.mrt.ac.lk
- KaveeshaKapuruge: kaveeshakapuruge.22@cse.mrt.ac.lk
- jayasinghesasmitha: sasmitha.22@cse.mrt.ac.lk

Happy reading and exchanging! 📚🔄
