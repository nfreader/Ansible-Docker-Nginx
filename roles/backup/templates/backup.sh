#!/bin/bash

#This shell script will dump our nginx docroot and mysql DBs to a tar and
#stick it all in an S3 bucket.

BUCKET={{ backup_bucket }}
DATE=$(date -d "today" +"%Y%m%d%H%M");
HOST=$(hostname -f)
source /srv/www/.env
mkdir ~/backup;
docker exec db sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' | gzip -c > ~/backup/$DATE-sql-dump.sql.gz;
tar -zcf ~/backup/$DATE-file-dump.tar --exclude-vcs-ignores --exclude-vcs --exclude='/srv/www/data/db' /srv/www/data;
(cd ~/backup && /usr/local/bin/aws s3 cp $DATE-file-dump.tar s3://$BUCKET/$HOST/$DATE-file-dump.tar);
(cd ~/backup && /usr/local/bin/aws s3 cp $DATE-sql-dump.sql.gz s3://$BUCKET/$HOST/$DATE-sql-dump.sql.gz);
rm -rf ~/backup/*;