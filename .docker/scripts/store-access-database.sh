#!/bin/sh
# A shell script to store the MySQL database access.

# Get the IP of the database container
MYSQL_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dk_leeloo_database)

# Get the user name setted on the .env file
MYSQL_USER=$(awk -F "[=]" '/MYSQL_USER=/{print $(NF)}' .env.behat)

# Get the passwaord setted on the .env file
MYSQL_PASSWORD=$(awk -F "[=]" '/MYSQL_PASSWORD=/{print $(NF)}' .env.behat)

# Get the database setted on the .env file
MYSQL_DATABASE=$(awk -F "[=]" '/MYSQL_DATABASE=/{print $(NF)}' .env.behat)

FILE="./.docker/tmp-data/.mysqlenv"

cat >$FILE <<EOL
MYSQL_HOST=${MYSQL_HOST}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
MYSQL_DATABASE=${MYSQL_DATABASE}
EOL
