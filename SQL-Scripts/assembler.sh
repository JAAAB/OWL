#!/usr/bin/env bash
# This should assemble the databases and toss the data in.
# Let me know if it doesn't.

USER='owl'
INIT='init-supplier-db-assemble.sql'
SECONDARY='secondary-project-db-assemble.sql'
TERTIARY='tertiary-vews-db-addition.sql'
DATA='fill-data.sql'

sudo mysql -u $USER -p < reset.sql > reset-output.txt

sudo mysql -u $USER -p < $INIT > init-output.txt
sudo mysql -u $USER -p < $SECONDARY > secondary-output.txt
sudo mysql -u $USER -p < $DATA > data-output.txt

sudo mysql -u $USER -p < $TERTIARY > tertiary-output.txt
