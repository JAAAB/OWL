const mariadb = require('mariadb');
const pool = mariadb.createPool({
        host:               'localhost',
        user:               'owl',
        password:           'jaaab',
        connectionLimit:    5
});

async function asyncFunction() {
        let conn;
        try {
                conn = await pool.getConnection();
                const rows = await conn.query("SELECT * from vewSuppliers;");
                console.log(rows);
        } catch (err) {
                throw err;
        } finally {
                if (conn) return conn.end();
        }
}
