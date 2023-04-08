const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
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
    const [rows] = await conn.query('SELECT * FROM user WHERE username = ? AND password = ?', [username, password]);
    if (rows.length > 0) {
      res.send(rows);
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

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
