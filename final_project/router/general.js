const express = require('express');
let books = require("./booksdb.js");
let isValid = require("./auth_users.js").isValid;
let users = require("./auth_users.js").users;
const public_users = express.Router();
const axios = require('axios');

public_users.post("/register", (req,res) => {
  const username = req.body.username;
  const password = req.body.password;

  if (!username || !password) {
    return res.status(404).json({message: "Username and password are required."});
  }

  if (!isValid(username)) {
    return res.status(404).json({message: "User already exists!"});
  }

  users.push({username, password});
  return res.status(200).json({message: "User successfully registered. Now you can login"});
});

// Get the book list available in the shop
public_users.get('/',function (req, res) {
  return res.status(200).send(JSON.stringify(books, null, 4));
});

// Get book details based on ISBN
public_users.get('/isbn/:isbn',function (req, res) {
  const isbn = req.params.isbn;
  const book = books[isbn];
  if (book) {
    return res.status(200).send(JSON.stringify(book, null, 4));
  } else {
    return res.status(404).json({message: `Book with ISBN ${isbn} not found`});
  }
});

// Get book details based on author
public_users.get('/author/:author',function (req, res) {
  const author = req.params.author;
  const isbns = Object.keys(books);
  const matches = isbns
    .filter((isbn) => books[isbn].author === author)
    .map((isbn) => ({ isbn, ...books[isbn] }));

  if (matches.length > 0) {
    return res.status(200).send(JSON.stringify(matches, null, 4));
  } else {
    return res.status(404).json({message: `No books found by author ${author}`});
  }
});

// Get all books based on title
public_users.get('/title/:title',function (req, res) {
  const title = req.params.title;
  const isbns = Object.keys(books);
  const matches = isbns
    .filter((isbn) => books[isbn].title === title)
    .map((isbn) => ({ isbn, ...books[isbn] }));

  if (matches.length > 0) {
    return res.status(200).send(JSON.stringify(matches, null, 4));
  } else {
    return res.status(404).json({message: `No books found with title ${title}`});
  }
});

//  Get book review
public_users.get('/review/:isbn',function (req, res) {
  const isbn = req.params.isbn;
  const book = books[isbn];
  if (book) {
    return res.status(200).send(JSON.stringify(book.reviews, null, 4));
  } else {
    return res.status(404).json({message: `Book with ISBN ${isbn} not found`});
  }
});

// ---------------------------------------------------------------------------
// Tasks 10-13: same functionality as above, implemented with Promises /
// async-await using Axios (calling this same server's own endpoints).
// ---------------------------------------------------------------------------

const BASE_URL = "http://localhost:5000";

// Task 10: Get the book list using async-await with Axios
public_users.get('/async/books', async function (req, res) {
  try {
    const response = await axios.get(`${BASE_URL}/`);
    return res.status(200).send(JSON.stringify(response.data, null, 4));
  } catch (error) {
    return res.status(500).json({message: "Error fetching books", error: error.message});
  }
});

// Same functionality using plain Promises (.then/.catch)
function getAllBooksPromise() {
  return axios.get(`${BASE_URL}/`).then((response) => response.data);
}

// Task 11: Get book details based on ISBN using async-await with Axios
public_users.get('/async/isbn/:isbn', async function (req, res) {
  try {
    const isbn = req.params.isbn;
    const response = await axios.get(`${BASE_URL}/isbn/${isbn}`);
    return res.status(200).send(JSON.stringify(response.data, null, 4));
  } catch (error) {
    return res.status(error.response ? error.response.status : 500)
      .json({message: "Error fetching book by ISBN", error: error.message});
  }
});

function getBookByISBNPromise(isbn) {
  return axios.get(`${BASE_URL}/isbn/${isbn}`).then((response) => response.data);
}

// Task 12: Get book details based on Author using async-await with Axios
public_users.get('/async/author/:author', async function (req, res) {
  try {
    const author = req.params.author;
    const response = await axios.get(`${BASE_URL}/author/${author}`);
    return res.status(200).send(JSON.stringify(response.data, null, 4));
  } catch (error) {
    return res.status(error.response ? error.response.status : 500)
      .json({message: "Error fetching books by author", error: error.message});
  }
});

function getBooksByAuthorPromise(author) {
  return axios.get(`${BASE_URL}/author/${author}`).then((response) => response.data);
}

// Task 13: Get book details based on Title using async-await with Axios
public_users.get('/async/title/:title', async function (req, res) {
  try {
    const title = req.params.title;
    const response = await axios.get(`${BASE_URL}/title/${title}`);
    return res.status(200).send(JSON.stringify(response.data, null, 4));
  } catch (error) {
    return res.status(error.response ? error.response.status : 500)
      .json({message: "Error fetching books by title", error: error.message});
  }
});

function getBooksByTitlePromise(title) {
  return axios.get(`${BASE_URL}/title/${title}`).then((response) => response.data);
}

module.exports.general = public_users;
module.exports.getAllBooksPromise = getAllBooksPromise;
module.exports.getBookByISBNPromise = getBookByISBNPromise;
module.exports.getBooksByAuthorPromise = getBooksByAuthorPromise;
module.exports.getBooksByTitlePromise = getBooksByTitlePromise;
