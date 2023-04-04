#!/bin/bash

# Set AWS source and destination regions
SOURCE_REGION="us-east-1"
DESTINATION_REGION="us-east-1"

# Set destination bucket
DESTINATION_BUCKET="wh-elasticcache-backup-new"

# Get today's date
TODAY=$(date -I)

# Get the list of ElastiCache snapshots with the backup type "Automated"
SNAPSHOTS=$(aws elasticache describe-snapshots --region $SOURCE_REGION --query "Snapshots[?SnapshotSource=='automated']" --output json)

# Copy each snapshot to the S3 bucket
for snapshot in $(echo "${SNAPSHOTS}" | jq -r '.[] | @base64'); do
  # Decode snapshot JSON
  snapshot_decoded=$(echo ${snapshot} | base64 --decode)

  # Get snapshot name and creation time
  snapshot_name=$(echo ${snapshot_decoded} | jq -r '.SnapshotName')
  snapshot_create_time=$(echo ${snapshot_decoded} | jq -r '.NodeSnapshots[].SnapshotCreateTime')
  snapshot_date=$(date -I -d "$snapshot_create_time")

  # Check if the snapshot date is today
  if [[ "$snapshot_date" == "$TODAY" ]]; then
    # Remove "automatic." from the snapshot name
    TARGET_SNAPSHOT_NAME=$(echo $snapshot_name | sed 's/automatic\.//')

    echo "Copying snapshot $snapshot_name to $DESTINATION_REGION as $TARGET_SNAPSHOT_NAME..."

    # Copy the snapshot to the destination region
    aws elasticache copy-snapshot \
    --source-snapshot-name "$snapshot_name" \
    --target-snapshot-name "$TARGET_SNAPSHOT_NAME" \
    --target-bucket $DESTINATION_BUCKET

    echo "Snapshot $snapshot_name successfully copied to $DESTINATION_REGION as $TARGET_SNAPSHOT_NAME."
  fi
done
