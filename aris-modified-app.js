//loading our app server
const express = require('express')
const mysql = require('mysql')
const app = express()

let results = [];

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
	console.log("Test1");
	suppliersPool.getConnection(function (err, connection) {
		console.log("Test2");
		if (err) {
			console.log("SUPPLIERS POOL ERR");
			return callback(err, null);
		}
		else if (connection) {
			console.log("Test3");
			connection.query(query, function (err, rows, fields) { 
				console.log("Test4");
				//connection.release();
				
				// Debug log
				console.log(query);
				
				if(err) {
					console.log("Failed to fetch table: " + err);
					//res.sendStatus(500);
					return callback(err, null);
				}
				//console.log("Fetching " + name + " table");
				
				// Rows contains data here, console.log proves....
				//console.log(rows);
				
				//res.send(JSON.stringify(rows));
				console.log("Test5");
				return callback(null, rows);
			});
		}
		else {
			console.log("Test6");
			return callback(true, "No Connection");
		}
	})
}

app.get("/viewtable/s/:tableName", (req, res) => {
	const name = req.params.tableName;
	console.log("Viewing table: " + name);

	var query = 'SELECT * FROM ' + name; //setting query string with variable
	console.log("Query = " + query);
	var result = function (query) {
    	executeSuppliersQuery(query, function(err, rows) {
	    //console.log("Test7");
    	    if (!err) {
		console.log("Test8");
                console.log(rows);
    		    console.log("NO ERROR!!!");
    	    
	            res.setHeader('Content-Type', 'application/json');
	            console.log("results are: " + results);
		    res.send(JSON.stringify(result));
            }
            else {
                console.log(rows);
    		    console.log("ERROR!!!");
    		    return err;
    	    }
        })
	    console.log("Sending JSON data...");
    }
});

var portNum = 3003;
app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})


