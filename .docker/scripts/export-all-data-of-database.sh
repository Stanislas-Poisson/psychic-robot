#!/bin/bash
# A shell script to export all data from MySQL database.

# Get the database setted on the storred .env file
MYSQL_DATABASE=$(awk -F "[=]" '/MYSQL_DATABASE=/{print $(NF)}' ./tmp-data/.mysqlenv)

mysqldump --add-drop-table -u root -proot --default-character-set=utf8 --no-create-info=TRUE --skip-triggers ${MYSQL_DATABASE} > ./tmp-data/export.sql
