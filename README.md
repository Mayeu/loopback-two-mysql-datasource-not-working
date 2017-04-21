# Minimal repository exposing an issue with LoopBack

The issue is here [loobpack-connector-mysql#264](https://github.com/strongloop/loopback-connector-mysql/issues/264#issue-223382886).

## Description/Steps to reproduce

For the last 3 months we had a LoopBack application using a MySQL and a REST datasource. Recently we wanted to add a new datasource pointing to another MySQL database. This datasource don't have any migration because we are calling an existing database managed by another application.

While the application is still working (we can launch the server, and use the whole shebang with the second database), the database migration of the first MySQL database are now hanging indefinitively (unless killed, or killing the database).

1. Create a new empty Loopback API server (v3)
2. Add one datasource using mysql
3. Create a simple migration script:
```
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
```
4. Run the migration script successfully
5. Add a new datasource
6. Try to run the same migration script, which will now hang indefinitively.

This repo is a minimal non working example of this:
* It's the default empty application, with two MySQL datasource in it
* The mysql migration script try to create the default models (Users, ACL, etc.)
* The demo uses docker for the database, yarn, and nvm so you have the exact dependency tree of the application.

You can run the whole things with the `./demo.sh` script in it, the result will be something like:
```
$ nvm use
$ ./demo.sh
==> Create two containers for MySQL, and start those
35b97671989a98246786e42b8a10b9615ef00a9cd4e48829dfb2ae5ec6c3cc0f
050a244b11b14321eac5aabf50e42159f8d0066f3560ee466e3fdb85b1859125
mysql-dbone
mysql-dbtwo
==> Wait 20 seconds, to ensure the MySQL are started
==> Export the needed MySQL definition string
==> Install the needed package
yarn install v0.23.2
[1/4] 🔍  Resolving packages...
success Already up-to-date.
✨  Done in 0.49s.
==> Checkout the working code with only one datasource
Note: checking out '4b7aa8c528e9fa4f42a4663613d137a4f95bb8c5'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 4b7aa8c... Minimal working example
==> Run the migration script
Loopback tables [User,ACL,RoleMapping,Role] created in  mysql
==> The migration finished
==> Checkout the non working code with two MySQL's datasources
Previous HEAD position was 4b7aa8c... Minimal working example
HEAD is now at f221371... Add one datasource with mysql, migration breaks
==> Run the migration script
Loopback tables [User,ACL,RoleMapping,Role] created in  mysql
## Hang indefinitively here
```
## Expected result

The migration finish correctly.

## Additional information
```
🚀  λ node -e 'console.log(process.platform, process.arch, process.versions.node)'
darwin x64 6.10.2

🚀  λ npm ls --prod --depth 0 | grep loopback
loopback-test@1.0.0 /Users/cast/Code/loopback-test
├── loopback@3.6.0
├── loopback-boot@2.24.0
├── loopback-component-explorer@4.2.0
├── loopback-connector-mysql@4.0.0
npm ERR! missing: options@latest, required by sse@0.0.6
```
