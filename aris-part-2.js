//loading our app server
const mariadb = require('mariadb');
const express = require('express')
const bodyParser = require('body-parser')

const app = express()
const http = require('http').Server(app);
const io = require('socket.io')(http);

var util = require('./modules/util.js')
var rows;

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



app.use(express.static('./public')) //this allows us to nav to html files via their url
app.use(bodyParser.urlencoded({extended: false}))

/*
function buildTable(res,dbRows) {
    console.log("in buildTable : ");
    console.log(dbRows);

    io.emit('dbresponse', dbRows);
    console.log("IO Emit Didn't work.");
    //res.send(JSON.stringify(dbRows));

    return null;
}
*/

async function selectSuppliersTableData(res, name, id) {
    let conn;
    let key;
    let primaryKey;
    let rows;

    conn = await suppliersPool.getConnection();
    console.log(`Got Connection!`);

    if (id !== null) {
        key = await conn.query(`SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE
            COLUMN_KEY = 'PRI' AND TABLE_NAME = '${name}';`);

        const key_obj = JSON.parse(JSON.stringify(key));

        for (var i in key_obj) {
            var item = key_obj[i];
            for (var j in item) {
                primaryKey = item[j];
                //console.log("THIS IS MY PRIMARY KEY HOPEFULLY!!! : " + primaryKey);
            }
        }
    }

    let query = id !== null ?
        `SELECT * FROM ${name} WHERE ${primaryKey} = '${id}';` :
            `SELECT * FROM ${name};`;

    console.log(query);

    try {

        rows = await conn.query(query);
        console.log(`Getting rows...`);
    }
    catch (err) {
            console.log("ERROR!!!");
            throw err;
            return null;
    } finally {
        if (conn) {
            console.log(`Ending connection...`);
            conn.end();
        }
        console.log(`Returning rows...`);

        if (id !== null) {
            buildTable(res,rows);
        }
        else {
            return res.send(JSON.stringify(rows));
        }
    }
}


async function selectProjectsTableData(res, name, id) {
    let conn;
    let key;
    let primaryKey;
    let rows;

    conn = await projectsPool.getConnection();
    console.log(`Got Connection!`);

    if (id !== null) {
        key = await conn.query(`SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE
            COLUMN_KEY = 'PRI' AND TABLE_NAME = '${name}';`);

        const key_obj = JSON.parse(JSON.stringify(key));

        for (var i in key_obj) {
            var item = key_obj[i];
            for (var j in item) {
                primaryKey = item[j];
                //console.log("THIS IS MY PRIMARY KEY HOPEFULLY!!! : " + primaryKey);
            }
        }
    }

    let query = id !== null ?
        `SELECT * FROM ${name} WHERE ${primaryKey} = '${id}';` :
            `SELECT * FROM ${name};`;

    console.log(query);

    try {

        rows = await conn.query(query);
        console.log(`Getting rows...`);
    }
    catch (err) {
            console.log("ERROR!!!");
            throw err;
            return null;
    } finally {
        if (conn) {
            console.log(`Ending connection...`);
            conn.end();
        }
        console.log(`Returning rows...`);

        if (id !== null) {
            buildTable(res,rows);
        }
        else {
            return res.send(JSON.stringify(rows));
        }
    }
}

// build our table
function buildTable(res,dbRows) {
    console.log("in buildTable : ");
    console.log(dbRows);

    io.on('connection', (socket) => {
        socket.emit('dbResponse', dbRows)
    })
}

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is root");
});

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

app.get("/viewtable/s/:tableName", (req, res) => {
	let error;
	const name = req.params.tableName;

    console.log("Viewing table: " + name);

    let rows;

    selectSuppliersTableData(res, name, null);

});

app.get("/viewtable/p/:tableName", (req, res) => {
	let error;
	const name = req.params.tableName;

    console.log("Viewing table: " + name);

    let rows;

    selectProjectsTableData(res, name, null);

});

app.get("/viewproject/:projectID", (req, res) => {

    res.sendFile(__dirname + '/public/viewproject.html');

    let error;
    const projectID = req.params.projectID;

    console.log(`Viewing project : ${projectID}`);

    let rows;

    selectProjectsTableData(res, 'tblProject', projectID);
});

app.get("/viewsupplier/:supplierID", (req, res) => {

    res.sendFile(__dirname + '/public/viewsupplier.html');

    let error;
    const supplierID = req.params.supplierID;

    console.log(`Viewing supplier : ${supplierID}`);

    let rows;

    selectSuppliersTableData(res, 'tblSupplier', supplierID);
});

http.listen(3003);
