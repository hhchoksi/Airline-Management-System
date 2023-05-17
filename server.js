const express = require('express');
const mysql = require('mysql2/promise');
const ejs = require('ejs');
const moment = require('moment');

const app = express();
app.set('view engine', 'ejs');

const port = process.env.PORT || 3000;

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'mihirkotecha',
  database: 'airlinemanagement',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/login.html');
});

app.post('/login', async (req, res) => {
  console.log('POST request to /login received');
  const { username, password } = req.body;
  console.log(`username: ${username}, password: ${password}`);
  const conn = await pool.getConnection();

  try {
    const [rows] = await conn.query('SELECT * FROM User WHERE Username = ? AND Password = ?', [username, password]);
    if (rows.length > 0) {
      res.sendFile(__dirname + '/ticket-booking.html');
    } else {
      res.send('Invalid username or password');
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  } finally {
    conn.release();
  }
});

// Code to search flights based on user input
app.post('/search-flights', async (req, res) => {
  const { origin, destination, numPassengers, departureDate } = req.body;
  const conn = await pool.getConnection();

  try {
    const [rows] = await conn.query('SELECT * FROM Flight WHERE DepartureAirportCode = ? AND ArrivalAirportCode = ? AND SeatsAvailable >= ? AND DATE(DepartureTime) = ?', [origin, destination, numPassengers, departureDate]);
    res.render('available_flights', { flights: rows, numPassengers, departureDate });
    console.log(rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  } finally {
    conn.release();
  }
});

// Route for sign-up button
app.get('/signup', (req, res) => {
  res.sendFile(__dirname + '/signup.html');
});

// Route for inserting new user into the User table
app.post('/signup', async (req, res) => {
  const { username, password, firstName, lastName } = req.body;
  console.log(`Received sign-up request with username = ${username}, password = ${password}, firstName = ${firstName}, lastName = ${lastName}`);
  const conn = await pool.getConnection();

  try {
    const [result] = await conn.query('INSERT INTO User (UserID, Username, Password, FirstName, LastName) VALUES (UUID(), ?, ?, ?, ?)', [username, password, firstName, lastName]);
    console.log(`New user with ID ${result.insertId} has been inserted into the User table`);
    res.redirect('/');
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  } finally {
    conn.release();
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
