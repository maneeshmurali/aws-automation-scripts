## Usage

The backup_all.sh script will assist you in uploading all ElasticCache backups to an S3 bucket. You will need to modify the script and provide the name of the S3 bucket. The script filters the backups by the Backup Type 'Automated' and uploads the full backups to the specified S3 bucket.

The backup_latest.sh script assists you in uploading the most recent ElasticCache automated backup to an S3 bucket. You can schedule a cron job to run the script daily and upload the latest backup to S3.
