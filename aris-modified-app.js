//loading our app server
const express = require('express')
const mysql = require('mysql')
const app = express()

var suppliersPool = mysql.createPool({
	connectionLimit	: 100,
	host		: 'localhost',
	user		: 'owl',
	password	: 'jaaab',
	database	: 'suppliers',
	debug		: true // CHANGE TO FALSE IN PROD
});

var projectsPool = mysql.createPool({
	connectionLimit	: 100,
	host		: 'localhost',
	user		: 'owl',
	password	: 'jaaab',
	database	: 'projects',
	debug		: true // CHANGE TO FALSE IN PROD
});

function buildHtml(req) { //This is a test and isn't implemented at all
	var header = '';
	var body = '';
	var returnString = '';

	header = 'TEST';
	body = 'test';

	returnString = '<!DOCTYPE html>'
		+ '<html><head>' + header + '</head><body>' + body + '</body></html>';

	return returnString;
};


app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is the root route");
})

function executeSuppliersQuery(query, callback) {
	suppliersPool.getConnection(function (err, connection) {
		if (err) {
			return callback(err, null);
		}
		else if (connection) {
			connection.query(query, function (err, rows, fields) { 
				connection.release();
				if(err) {
					console.log("Failed to fetch table: " + err);
					res.sendStatus(500);
					return callback(err, null);
				}
				//console.log("Fetching " + name + " table");
				console.log(rows);
				results = rows;

				return callback(null, rows);
			});
		}
		else {
			return callback(true, "No Connection");
		}
	});
}

function getSuppliersResult(query, callback) {
	executeSuppliersQuery(query, function(err, rows) {
		if (!err) {
			console.log("NO ERROR!!!"+rows);
			//callback(null, rows);
		}
		else {
			console.log("ERROR!!!");
			//callback(true,err);
		}
	});
}

app.get("/viewtable/s/:tableName", (req, res) => {
	var results;
	const name = req.params.tableName;
	console.log("Viewing table: " + name);

	/*
	const connection = mysql.createConnection({ //creating connection to mysql db
		host: 'localhost',
		user: 'owl',
		password: 'jaaab',
		database: 'suppliers'
	})	
	*/

	var query = 'SELECT * FROM ' + name; //setting query string with variable
	
	getSuppliersResult(query);

	/*
	connection.query(queryString, (err, rows, fields) => { //running query
		if(err) {
			console.log("Failed to fetch table: " + err);
			res.sendStatus(500);
			return;
		}
		console.log("Fetching " + name + " table");
		console.log(rows);
		results = await rows;
		//res.json(results);
	})
	res.json(results);
	console.log(results);
	*/
})

var portNum = 3003;
app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})


