const mariadb = require('mariadb');
const express = require('express')
const mysql = require('mysql');
const bodyParser = require('body-parser')

const app = express()
const http = require('http').Server(app);
const io = require('socket.io')(http);

const projectsPool = mariadb.createPool({
	host: 'localhost',
	user: 'owl',
	password: 'jaaab',
	connectionLimit: 5,
	database: 'projects',
	debug: false
});

const suppliersPool = mariadb.createPool({
	host: 'localhost',
	user: 'owl',
	password: 'jaaab',
	connectionLimit: 5,
	database: 'suppliers',
	debug: false
});

//temporarily set these back to mysql instead of mariadb to work with editing and saving projects
function getProjectsConnection(){
	return mysql.createConnection({
		host: 'localhost',
		user: 'owl',
		password: 'jaaab',
		database: 'projects'
	})
}

function getSuppliersConnection(){
	return mysql.createConnection({
		host: 'localhost',
		user: 'owl',
		password: 'jaaab',
		database: 'suppliers'
	})
}



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

module.exports = {
	getProjectsConnection: getProjectsConnection,
	getSuppliersConnection: getSuppliersConnection,
	selectSuppliersTableData: selectSuppliersTableData,
	selectProjectsTableData: selectProjectsTableData,
	projectsPool: projectsPool,
	suppliers: suppliersPool
}
