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
