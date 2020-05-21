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

mysql -u $USER < "${SCRIPTPATH}reset.sql" > "${SCRIPTPATH}reset-output.txt"

mysql -u $USER < "${SCRIPTPATH}${INIT}" > "${SCRIPTPATH}init-output.txt"
mysql -u $USER < "${SCRIPTPATH}${SECONDARY}" > "${SCRIPTPATH}secondary-output.txt"
mysql -u $USER < "${SCRIPTPATH}${DATA}" > "${SCRIPTPATH}data-output.txt"

mysql -u $USER < "${SCRIPTPATH}${TERTIARY}" > "${SCRIPTPATH}tertiary-output.txt"
