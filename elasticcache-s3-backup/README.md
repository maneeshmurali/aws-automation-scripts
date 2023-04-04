# ElasticCache DR Backup

ElasticCache provides a Disaster Recovery (DR) backup solution that allows you to take automated backups of your cache clusters and store them in a separate AWS region for additional data resiliency. You can configure the DR backup feature to use S3 Cross-Region Replication (CRR) to replicate your backups to a different region for improved durability.

When you configure ElasticCache DR backups with S3 CRR, the backups are automatically copied to a designated S3 bucket in a different AWS region. S3 CRR allows you to replicate your backups asynchronously and automatically from the primary region to the DR region. This provides you with a reliable and scalable solution for disaster recovery.

To set up ElasticCache DR backups with S3 CRR, you need to:

1. Create two S3 bucket in the source and Destination to store your backups.
2. Enable S3 CRR to replicate the backups to the DR region bucket.
3. Enable ElasticCache Automated backups.
4. Upload the backups to S3 buckets in the same region and this will replicated to the DR region using S3 CRR. (Automate this using the backup script.)

Once you've set up ElasticCache DR backups with S3 CRR, you can be assured that your backups are automatically replicated to a different AWS region for additional durability and resiliency.


## Script Usage

The Terraform script 's3-replication.tf' will help you create two S3 buckets in two regions and set up S3 CRR replication between them. Once S3 has been set up, you can use the backup scripts to configure automated backup uploads to S3. Please note that ElasticCache only allows backup uploads to the same region, but S3-CRR will enable replication to the destination region.

The backup_all.sh script will assist you in uploading all ElasticCache backups to an S3 bucket. You will need to modify the script and provide the name of the S3 bucket. The script filters the backups by the Backup Type 'Automated' and uploads the full backups to the specified S3 bucket.

The backup_latest.sh script assists you in uploading the most recent ElasticCache automated backup to an S3 bucket. You can schedule a cron job to run the script daily and upload the latest backup to S3.
