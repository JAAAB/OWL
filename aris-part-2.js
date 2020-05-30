//loading our app server
const mariadb = require('mariadb');
const express = require('express');
const bodyParser = require('body-parser');
const dateFormat = require('dateformat');

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
    debug:              true
});

const suppliersPool = mariadb.createPool({
    host:               'localhost',
    user:               'owl',
    password:           'jaaab',
    connectionLimit:    5,
    database:           'suppliers',
    debug:              true
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
                //console.log("THIS IS MY PRIMARY KEY !!! : " + primaryKey);
            }
        }
    }

    let query = id !== null ?
        `SELECT * FROM ${name} WHERE ${primaryKey} = '${id}' ORDER BY ${primaryKey} DESC;` :
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

    if (name === 'tblProject' || name === 'vewProjects') {
        name = 'vewProjects';
        primaryKey = 'ProjectID';
    }
    else if (name === 'tblSupplier' || name === 'vewSuppliers') {
        name = 'vewSupplier';
        primaryKey = 'SupplierID';
    }
    else if (name === 'tblAuthor' || name === 'vewAuthors') {
        name = 'vewAuthors';
        primarykey = 'AuthorID';
    }

    if (id !== null && primaryKey === null) {
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
            buildListTable(res,rows);
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

function buildListTable(res,dbRows) {
    console.log("in buildListTable : ");
    console.log(dbRows);

    io.on('connection', (socket) => {
        socket.emit('dbResponse', dbRows)
    });
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

    selectProjectsTableData(res, 'tblProject', projectID, null);
});

app.get("/viewsupplier/:supplierID", (req, res) => {

    res.sendFile(__dirname + '/public/viewsupplier.html');

    let error;
    const supplierID = req.params.supplierID;

    console.log(`Viewing supplier : ${supplierID}`);

    let rows;

    selectSuppliersTableData(res, 'tblSupplier', supplierID);
});

app.get("/projects", (req, res) => {
    res.sendFile(__dirname + '/public/projects.html');

    selectProjectsTableData(res, 'vewProjects', null);
});

app.get("/authors", (req, res) => {
    res.sendFile(__dirname + '/public/authors.html');

    selectProjectsTableData(res, 'vewAuthors', null);

});

app.get('/editproject/:projectid', (req, res) => {
	res.sendFile(__dirname + '/public/editproject.html');

	let error;
	const projectID = req.params.projectid;
	const name = 'tblProject';

    console.log("Fetching Project #: " + projectID);

	let rows;

	//util.selectProjectsTableData(res, name, projectID);
    selectProjectsTableData(res, name, projectID);
});

// Adrian's stuff :sunglasses:

app.post('/project_create', (req, res) => {
	console.log("Creating new project...");
	console.log("Title = " + req.body.project_title);
	//console.log("Project ID = " + req.body.projectid); //this probably should only be output, not input
	console.log("Author = " + req.body.author);
	console.log("Status = " + req.body.status);
	console.log("Approval Date = " + req.body.approval_date);
	console.log("Edition = " + req.body.edition);
	console.log("ContractLength = " + req.body.contract);
	console.log("Notes = " + req.body.notes);

	var SQLStatus = 0;
	if(req.body.status == 'Active'){
		SQLStatus = 1;
	}
	var SQLAuthor = req.body.author.replace(" ", "%");
	var SQLDate = req.body.approval_date;

	console.log("\n");
	console.log("SQLAuthor: " + SQLAuthor);
	console.log("SQLStatus: " +SQLStatus);

	//console.log("Total Sales = " + req.body.sales); //this probably should only be output, not input


	var queryString = "insert into tblProject (AuthorID, ContractID, Title, Notes, Edition, ApprovalDate, isActive) " +
	"select au.AuthorID, c.ContractID, '" + req.body.project_title + "', '" + req.body.notes + "','" + req.body.edition + "', '" + SQLDate + "',"+ SQLStatus + " " +
	"from tblAccount as acc " +
	"join tblAuthor as au on acc.AccountID = au.AccountID " +
	"join tblContract as c " +
	"where acc.FullName like '" + SQLAuthor + "' AND " +
	"c.Years like '" + req.body.contract + "';";

	console.log(queryString);

	//NEED TO REWRITE THIS TO USE MARIADB
	var conn = util.getProjectsConnection();
	conn.query(queryString, (err, rows, fields) => { //running query
		if(err) {
			console.log("Failed to execute insert: " + err);
			res.sendStatus(500);
			res.end();

		}
		console.log("New Project Inserted.");
		res.redirect("/");
		res.end();
	});
})

app.post('/project_save', (req, res) => {
	console.log("Saving changes to project...");
	console.log("ID = " + req.body.projectid);
	console.log("Title = " + req.body.project_title);
	console.log("Author = " + req.body.author);
	console.log("Status = " + req.body.status);
	console.log("Approval Date = " + req.body.approval_date);
	console.log("Edition = " + req.body.edition);
	console.log("ContractLength = " + req.body.contract);
	console.log("Notes = " + req.body.notes);

	var SQLStatus = 0;
	if(req.body.status == 'Active'){
		SQLStatus = 1;
	}
	var SQLAuthor = req.body.author.replace(" ", "%");
	var SQLDate = req.body.approval_date;

	console.log("\n");
	console.log("SQLAuthor: " + SQLAuthor);
	console.log("SQLStatus: " +SQLStatus);

	var queryString =
	"UPDATE tblProject " +
	"SET " +
	"Title = '" + req.body.project_title + "', " +
	"Notes = '" + req.body.notes + "', " +
	"Edition = '" + req.body.edition + "', " +
	"ApprovalDate = '" + req.body.approval_date + "', " +
	"IsActive = '" + SQLStatus + "', " +
	"AuthorID = (SELECT AuthorID FROM tblAuthor LEFT JOIN tblAccount USING (AccountID) " +
		"WHERE FullName LIKE '" + SQLAuthor + "'), " +
	"ContractID = (SELECT ContractID FROM tblContract WHERE Years = '" + req.body.contract+ "') " +
	"WHERE ProjectID = '" + req.body.projectid + "';";

	console.log(queryString);

	var conn = util.getProjectsConnection();
	//const conn = util.projectsPool.getConnection();
	//conn.query(queryString);
	//NEED TO REWRITE THIS TO USE MARIADB
	conn.query(queryString, (err, rows, fields) => { //running query
		if(err) {
			console.log("Failed to execute update: " + err);
			res.sendStatus(500);
			res.end();
		}
		console.log("Project Updated.");
		res.redirect("/");
		//res.redirect("/projects");
		res.end();
	});

})


http.listen(3003);
