const mariadb = require('mariadb');
var Promise = require('promise');
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

//asyncFunction();

// Actual program here

//loading our app server
const express = require('express')
const bodyParser = require('body-parser')
const app = express()
var util = require('./modules/util.js')
var rows;

app.use(express.static('./public')) //this allows us to nav to html files via their url
app.use(bodyParser.urlencoded({extended: false}))

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is root");
})



app.post('/project_create', (req, res) => {
	console.log("Creating new project...");
	console.log("Title = " + req.body.project_title);
	console.log("Author = " + req.body.author);
	console.log("Status = " + req.body.status);
	console.log("Pub Date = " + req.body.publication_date);

	res.end();
})

app.get('/insert-demo-data', (req, res) => {
    console.log("Inserting data...");

	const { exec } = require ('child_process');
    var createScript = exec('sh assembler.sh',
        (error, stdout, stderr) => {
            console.log(stdout);
            console.log(stderr);
            if (error !== null) {
                console.log(`exec error: ${error}`);
            }
            else {
                console.log('Data inserted.');
            }
    });
    res.send("Data inserted.");
});

async function selectTableData(res, name) {
    let conn;
    //console.log("At least I made it here...");

    try {
        conn = await pool.getConnection();
        rows = await conn.query(`SELECT * FROM ${name};`);
        //console.log(JSON.stringify(rows));
    } catch (err) {
        console.log("ERROR!!!");
        throw err;
    } finally {
        if (conn) {
            conn.end();
        }
        return res.send(JSON.stringify(rows));
    }
}

app.get("/viewtable/:tableName", (req, res) => {
	let error;
	const name = req.params.tableName;

    console.log("Viewing table: " + name);

    let rows;

    selectTableData(res, name);

    //
    //
    //
    //
    //
    //
    //
    /*
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
	*/
    //res.send(JSON.stringify(rows));

	//console.log(rows);
})

var portNum = 3003;
app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})
