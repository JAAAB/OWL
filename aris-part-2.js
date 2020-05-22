const mariadb = require('mariadb');


const projectsPool = mariadb.createPool({
    host:               'localhost',
    user:               'owl',
    password:           'jaaab',
    connectionLimit:    5,
    database:           'projects',
    debug:              false
});

const suppliersPool = mariadb.createPool({
    host:               'localhost',
    user:               'owl',
    password:           'jaaab',
    connectionLimit:    5,
    database:           'suppliers',
    debug:              false
});

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

async function selectSuppliersTableData(res, name) {
    let conn;

    try {
        conn = await suppliersPool.getConnection();
        rows = await conn.query(`SELECT * FROM ${name};`);
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

async function selectProjectsTableData(res, name) {
    let conn;

    try {
        conn = await projectsPool.getConnection();
        rows = await conn.query(`SELECT * FROM ${name};`);
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

app.get("/viewtable/s/:tableName", (req, res) => {
	let error;
	const name = req.params.tableName;

    console.log("Viewing table: " + name);

    let rows;

    selectSuppliersTableData(res, name);

})

app.get("/viewtable/p/:tableName", (req, res) => {
	let error;
	const name = req.params.tableName;

    console.log("Viewing table: " + name);

    let rows;

    selectProjectsTableData(res, name);

})

var portNum = 3003;
app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})


// Previously on line 17 of function selectSuppliersTableData()

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
