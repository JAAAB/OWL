const mariadb = require('mariadb');
const pool = mariadb.createPool({
    host:               'localhost',
    user:               'owl',
    password:           'jaaab',
    connectionLimit:    5,
    database:           'suppliers',
    debug:              false
});

async function asyncFunction() {
    let conn;
    console.log("This works");
    try {
            conn = await pool.getConnection();
            const rows = await conn.query("SELECT * from vewSuppliers;");
            console.log(JSON.stringify(rows));
    } catch (err) {
            throw err;
    } finally {
            if (conn) return conn.end();
    }
}

asyncFunction();

// Actual program here

//loading our app server
const express = require('express')
const bodyParser = require('body-parser')
const app = express()
var util = require('./modules/util.js')

app.use(express.static('./public')) //this allows us to nav to html files via their url
app.use(bodyParser.urlencoded({extended: false}))

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is root");
})



app.post('/project_create', (req, res) => {
	console.log("Creating new project...");
	//console.log("Title = " + req.body.project_title);
	//console.log("Author = " + req.body.author);
	//console.log("Status = " + req.body.status);
	//console.log("Pub Date = " + req.body.publication_date);

	const { exec } = require ('child_process');
    var createScript = exec('sh assembler.sh',
            (error, stdout, stderr) => {
                console.log(stdout);
                console.log(stderr);
                if (error !== null) {
                        console.log(`exec error: ${error}`);
                }
    });


	res.end();
})

app.get("/viewtable/:tableName", (req, res) => {
	var results;
	const name = req.params.tableName;
	console.log("Viewing table: " + name);	

	var connection = util.getSuppliersConnection();
	var queryString = 'SELECT * FROM ' + name; //setting query string with variable
	connection.query(queryString, async (err, rows, fields) => { //running query
		if(err) {
			console.log("Failed to fetch table: " + err);
			res.sendStatus(500);
			return;
		}
		console.log("Fetching " + name + " table");
		console.log(rows);
		results = await rows;
		res.json(results);
	})
	// I changed the res.json(results) to this
	res.send(JSON.stringify(results));

	console.log(results);
})

var portNum = 3003;
app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})
