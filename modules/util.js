const mysql = require('mysql')

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

module.exports = {
	getProjectsConnection: getProjectsConnection,
	getSuppliersConnection: getSuppliersConnection
}
