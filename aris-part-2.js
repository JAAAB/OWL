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

/*
async function selectProjectsTableData(res, name, id) {
    let conn;

    if (id !== null) {
        var key;
        var rows;
        console.log(`Finding Primary Key : ${id} in ${name}`);
        try {
            conn = await projectsPool.getConnection();
            console.log(`Got Connection!`);

            key = await conn.query(`SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE
            COLUMN_KEY = 'PRI' AND TABLE_NAME = '${name}';`);
            //await console.log("Primary Key Name : " + JSON.stringify(key));

            const key_obj = JSON.parse(JSON.stringify(key));

            var primaryKey;
            for (var i in key_obj) {
                var item = key_obj[i];
                for (var key in item) {
                    var value = item[key];
                    //console.log("THIS IS MY PRIMARY KEY HOPEFULLY!!! : " + value);
                    primaryKey = value;
                }
            }

            rows = await conn.query(`SELECT * FROM ${name} WHERE ${primaryKey} = '${id}';`);
            console.log(`Getting rows...`);

        } catch (err) {
            console.log("ERROR!!!");
            throw err;
            return null;
        } finally {
            if (conn) {
                console.log(`Ending connection...`);
                conn.end();
            }
            console.log(`Returning rows...`);

            buildTable(res,rows);
        }
    }
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
*/

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is root");
});

app.post('/project_create', (req, res) => {
	console.log("Creating new project...");
	console.log("Title = " + req.body.project_title);
	console.log("Author = " + req.body.author);
	console.log("Status = " + req.body.status);
	console.log("Pub Date = " + req.body.publication_date);

	res.end();
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

    //console.log(rows);
});

http.listen(3003);

/*
var portNum = 3003;
app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
});
*/

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
