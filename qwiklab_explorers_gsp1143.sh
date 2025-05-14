#!/bin/bash

# Define color variables
YELLOW_TEXT=$'\033[0;33m'
MAGENTA_TEXT=$'\033[0;35m'
NO_COLOR=$'\033[0m'
GREEN_TEXT=$'\033[0;32m'
RED_TEXT=$'\033[0;31m'
CYAN_TEXT=$'\033[0;36m'
BOLD_TEXT=`tput bold`
RESET_FORMAT=`tput sgr0`
BLUE_TEXT=$'\033[0;34m'


# Prompt user for region input
echo "${BOLD_TEXT}${BLUE_TEXT}Enter REGION:${RESET_FORMAT}"
read -p "${BOLD_TEXT}${GREEN_TEXT}Region: ${RESET_FORMAT}" REGION
export REGION

# Enable Dataplex API
gcloud services enable dataplex.googleapis.com

# Create Dataplex Lake
gcloud alpha dataplex lakes create sensors \
 --location=$REGION \
 --labels=k1=v1,k2=v2,k3=v3 

# Create Dataplex Zone
gcloud alpha dataplex zones create temperature-raw-data \
            --location=$REGION --lake=sensors \
            --resource-location-type=SINGLE_REGION --type=RAW

# Create Storage Bucket
gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID

# Create Dataplex Asset
gcloud dataplex assets create measurements --location=$REGION \
            --lake=sensors --zone=temperature-raw-data \
            --resource-type=STORAGE_BUCKET \
            --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID

# Cleanup: Delete Dataplex Asset
gcloud dataplex assets delete measurements --zone=temperature-raw-data --lake=sensors --location=$REGION --quiet

# Cleanup: Delete Dataplex Zone
gcloud dataplex zones delete temperature-raw-data --lake=sensors --location=$REGION --quiet

# Cleanup: Delete Dataplex Lake
gcloud dataplex lakes delete sensors --location=$REGION --quiet


# Safely delete the script if it exists
SCRIPT_NAME="arcadecrew.sh"
if [ -f "$SCRIPT_NAME" ]; then
    rm -- "$SCRIPT_NAME"
fi

echo
echo
# Completion message
echo -e "${GREEN_TEXT}${BOLD_TEXT}Subscribe to my Channel: QwikLab Explorers${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@qwiklabexplorers${RESET_FORMAT}"
echo
