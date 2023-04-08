// Import required modules
const express = require('express');
const mysql = require('mysql2');

// Create a MySQL connection
const connection = mysql.createConnection({
  host: 'localhost', // Your database server name
  user: 'root', // Your database username
  password: 'mihirkotecha', // Your database password
  database: 'airlinemanagement' // Your database name
});

// Connect to MySQL
connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL server!');
});

// Create an Express application
const app = express();

// Define a route
app.get('/', (req, res) => {
  // Execute a MySQL query
  connection.query('SELECT * FROM user', (err, results) => {
    if (err) throw err;
    // Send the query results to the frontend
    res.send(results);
  });
});

// Start the Express server
app.listen(3000, () => {
  console.log('Server started on port 3000!');
});
