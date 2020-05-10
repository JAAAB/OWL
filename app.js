//loading our app server
const express = require('express')
const mysql = require('mysql')
const app = express()

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is the root route");
})

app.get("/viewtable/:tableName", (req, res) => {
	const name = req.params.tableName;
	console.log("Viewing table: " + name);

	const connection = mysql.createConnection({ //creating connection to mysql db
		host: 'localhost',
		user: 'owl',
		password: 'jaaab',
		database: 'suppliers'
	})	

	var queryString = 'SELECT * FROM ' + name; //setting query string with variable
	connection.query(queryString, (err, rows, fields) => { //running query
		if(err) {
			console.log("Failed to fetch table: " + err);
			res.sendStatus(500);
			return;
		}
		console.log("Fetching " + name + " table");
		res.json(rows);
	})
})

var portNum = 3003;
app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})


