#!/bin/bash
# A shell script to truncate all tables from MySQL database then import the previous export.

# Get the host setted on the storred .env file
MYSQL_HOST=$(awk -F "[=]" '/MYSQL_HOST=/{print $(NF)}' ./.docker/tmp-data/.mysqlenv)

# Get the user name setted on the storred .env file
MYSQL_USER=$(awk -F "[=]" '/MYSQL_USER=/{print $(NF)}' ./.docker/tmp-data/.mysqlenv)

# Get the passwaord setted on the storred .env file
MYSQL_PASSWORD=$(awk -F "[=]" '/MYSQL_PASSWORD=/{print $(NF)}' ./.docker/tmp-data/.mysqlenv)

# Get the database setted on the storred .env file
MYSQL_DATABASE=$(awk -F "[=]" '/MYSQL_DATABASE=/{print $(NF)}' ./.docker/tmp-data/.mysqlenv)

# Get the list of all tables
TABLES=$(mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -h ${MYSQL_HOST} ${MYSQL_DATABASE} -e 'show tables' | awk '{print $1}' | grep -v '^Tables')

# If list is empty
if [ "" == "$TABLES" ]
then
    echo "Error - No table found in $MYSQL_HOST@$MYSQL_DATABASE database!"
    exit 3
fi

# Iterate all tables listed
for t in $TABLES
do
    # Proceed to the truncate with a toggle foreign_key_checks before and after
    mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -h ${MYSQL_HOST} ${MYSQL_DATABASE} -e "SET FOREIGN_KEY_CHECKS=0; TRUNCATE TABLE $t; SET FOREIGN_KEY_CHECKS=1;"
done

mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -h ${MYSQL_HOST} ${MYSQL_DATABASE} < ./.docker/tmp-data/export.sql

php artisan redis:store
php artisan blog:store_latest
