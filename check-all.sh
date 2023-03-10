#!/bin/bash

set -ex

TARGET_REPO="django-migration-conflict-prevention"

git init
git remote add origin "https://github.com/naslundx/$TARGET_REPO" || true
git fetch origin main

PR=$(gh pr list --label 'has-migrations' --json headRefName | jq '.[].headRefName' | tr -d '"')

for BRANCH_NAME in "$PR"
do
    ../update-status.sh "$BRANCH_NAME"
done


