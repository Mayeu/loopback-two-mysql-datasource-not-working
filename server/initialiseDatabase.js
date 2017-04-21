var server = require('./server');

/* Initialise MySQL database */

var mysql_db = server.dataSources.dbone;
var lbTables = ['User', 'ACL', 'RoleMapping', 'Role'];

mysql_db.autoupdate(lbTables, function(er) {
    if (er) {
        throw er;
    }
    console.log('Loopback tables [' + lbTables + '] created in ', mysql_db.adapter.name);
    mysql_db.disconnect();
});
