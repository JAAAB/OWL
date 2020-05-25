//loading our app server
const express = require('express')
const mysql = require('mysql')
const bodyParser = require('body-parser')

const app = express()
const http = require('http').Server(app);
const io = require('socket.io')(http);

var util = require('./modules/util.js')



app.use(express.static('./public')) //this allows us to nav to html files via their url
app.use(bodyParser.urlencoded({extended: false}))

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is root");
})

app.get('/editproject/:projectid', (req, res) => {
	res.sendFile(__dirname + '/public/reports.html');

	let error;
	const projectID = req.params.projectid;
	const name = 'tblProject';


	///*
	console.log("Fetching Project #: " + projectID);

	let rows;

	util.selectProjectsTableData(res, name, projectID);
	//console.log("TEST PRINT " + tableData[0]);



	//res.send(id);
	//res.end();
	//*/
})

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
		//res.json(results);
	})
	// I changed the res.json(results) to this
	res.send(JSON.stringify(results));

	console.log(results);
})

var portNum = 3003;
http.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})

