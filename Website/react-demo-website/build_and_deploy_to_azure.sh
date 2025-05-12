#!/bin/bash

npm install
npm run build

STORAGE_ACCOUNT_NAME=$(terraform -chdir="../../Infrastructure" output -raw storage_account_name)
APP_URL=$(terraform -chdir="../../Infrastructure" output -raw front_door_url)

echo "Deploying website into azure... Storage account name: $STORAGE_ACCOUNT_NAME"

az storage blob upload-batch --account-name "$STORAGE_ACCOUNT_NAME" --destination '$web' --source "./dist" --overwrite

echo "App should be available on $APP_URL"
