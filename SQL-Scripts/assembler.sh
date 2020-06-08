#!/usr/bin/env bash
# This should assemble the databases and toss the data in.
# Let me know if it doesn't.

# TO GET THIS TO RUN!! NEW INSTRUCTIONS :
# - create /etc/my.cnf
# - like this
#[mysql]
#user=owl
#password=jaaab

# Here is one liner script to do that:
# 
# sudo printf "[mysql]\nuser=owl\npassword=jaaab\n" > /etc/my.cnf 
#
# You may wanna change the file permissions for security reasons.

DIR="$( cd "$( dirname "${BASH_SOURCE}[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTPATH="${DIR}/SQL-Scripts/"
USER='owl'
INIT='init-supplier-db-assemble.sql'
SECONDARY='secondary-project-db-assemble.sql'
TERTIARY='tertiary-vews-db-addition.sql'
DATA='fill-data.sql'
PROCS='last-procs-db-addition.sql'

#echo "Please enter sudo password to start mariadb"
#echo "executing sudo systemctl start mariadb"
#sudo systemctl start mariadb

mysql -u $USER < "${SCRIPTPATH}reset.sql"

mysql -u $USER < "${SCRIPTPATH}${INIT}"
mysql -u $USER < "${SCRIPTPATH}${SECONDARY}"
mysql -u $USER < "${SCRIPTPATH}${DATA}"

mysql -u $USER < "${SCRIPTPATH}${TERTIARY}"

mysql -u $USER < "${SCRIPTPATH}${PROCS}"
