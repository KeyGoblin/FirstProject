AutoChange — Mercedes Selector

This project is a simple full-stack web application that recommends a new Mercedes-Benz model based on the user's current vehicle and approximate budget.
The application includes:

-Frontend interface (HTML/CSS/JS)
-Backend server (Node.js + Express)
-MySQL database with Mercedes model data

Features:

-Select your current Mercedes model
-Enter your approximate budget
-Receive:
--The recommended upgrade model
--The difference in price (extra payment)
--Additional lower-budget alternative if needed

Project Structure:

autochange/
│
├── public/
│   └── index.html
│
├── server.js
├── package.json
├── package-lock.json
├── autochange_DB.sql
├── .gitignore
└── README.md

Requirements:

-Node.js (v16+ recommended)
-MySQL Server (v5.7+ or v8+)
-Any modern browser

Installing and Running the Project:

1. Clone the repository
git clone https://github.com/KeyGoblin/FirstProject.git
cd FirstProject
2. Install dependencies
npm install
3. Import the MySQL database
Open MySQL Workbench (or any SQL client).
Create a new database:
-CREATE DATABASE mercedes_db;
Select this database.
Run the SQL file from the repository:
autochange_DB.sql
-This file creates the required table and inserts all Mercedes models with prices, chassis codes, and image URLs.
4. Configure database connection
Open server.js and set your MySQL credentials:
const db = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'your_password',
    database: 'mercedes_db'
});
5. Start the server
node server.js
Then you should see: Server running at http://localhost:3000
6. Open the site
http://localhost:3000

Notes!!!

The database file must be imported manually; GitHub stores only the .sql file, not MySQL's internal data.
The user running the server must have MySQL installed locally.
All communication between frontend and backend occurs through /api/recommend and /api/alternative endpoints.
