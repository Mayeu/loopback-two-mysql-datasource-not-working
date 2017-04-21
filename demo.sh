
echo "==> Create two containers for MySQL, and start those"
docker run -d --name mysql-dbone  -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=dbone -p 3307:3306 mariadb:10.0
docker run -d --name mysql-dbtwo  -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=dbtwo -p 3306:3306 mariadb:10.0

docker start mysql-dbone
docker start mysql-dbtwo

echo "==> Wait 20 seconds, to ensure the MySQL are started"
sleep 20

echo "==> Export the needed MySQL definition string"
export MYSQL_DBONE_CONNECTION_STRING='mysql://root:password@localhost:3307/dbone'
export MYSQL_DBTWO_CONNECTION_STRING='mysql://root:password@localhost:3306/dbtwo'

echo "==> Install the needed package"
yarn

echo "==> Checkout the working code with only one datasource"
git checkout 4b7aa8c528e9fa4f42a4663613d137a4f95bb8c5

echo "==> Run the migration script"
node server/initialiseDatabase.js

echo "==> The migration finished"

echo "==> Checkout the non working code with two MySQL's datasources"
git checkout f221371ef8058aa61b4ed14240122e0e07a30029

echo "==> Run the migration script"
node server/initialiseDatabase.js

echo "==> You'll never see this echo, unless you kill the DBs"
