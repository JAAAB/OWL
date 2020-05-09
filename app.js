//loading our app server
const express = require('express')
const mysql = require('mysql')
const app = express()

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is the root route");
})

app.get("/viewtable/:tableName", (req, res) => {
	var name = req.param.tableName;
	console.log("Viewing table: " + name);

	const connection = mysql.createConnection({ //creating connection to mysql db
		host: 'localhost',
		user: 'root',
		password: '',
		database: 'suppliers'
	})
	

	var queryString = "SELECT * FROM ?"; //setting query string with variable
	connection.query(queryString, [name], (err, rows, fields) => { //running query
		if(err) {
			console.log("Failed to grab table: " + err);
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


