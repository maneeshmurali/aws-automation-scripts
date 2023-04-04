#!/bin/bash

# Set AWS source and destination regions
SOURCE_REGION="us-east-1"
DESTINATION_REGION="us-east-1"

# Set destination bucket
DESTINATION_BUCKET="wh-elasticcache-backup-new"

# Get the list of ElastiCache snapshots with the backup type "Automated"
SNAPSHOTS=$(aws elasticache describe-snapshots --region $SOURCE_REGION --query "Snapshots[?SnapshotSource=='automated'].SnapshotName" --output json)

# Copy each snapshot to the S3 bucket
for snapshot in $(echo "${SNAPSHOTS}" | jq -r '.[]'); do
  # Remove "automatic." from the snapshot name
  TARGET_SNAPSHOT_NAME=$(echo $snapshot | sed 's/automatic\.//')

  echo "Copying snapshot $snapshot to $DESTINATION_REGION as $TARGET_SNAPSHOT_NAME..."

  # Copy the snapshot to the destination region
  aws elasticache copy-snapshot \
    --source-snapshot-name "$snapshot" \
    --target-snapshot-name "$TARGET_SNAPSHOT_NAME" \
    --target-bucket $DESTINATION_BUCKET

  echo "Snapshot $snapshot successfully copied to $DESTINATION_REGION as $TARGET_SNAPSHOT_NAME."
done
