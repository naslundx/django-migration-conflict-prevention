#!/bin/bash

set -ex

BRANCH_NAME="$1"
TARGET_REPO="django-migration-conflict-prevention"

git fetch origin "$BRANCH_NAME"
git checkout "origin/$BRANCH_NAME"
COMMIT_HASH=$(git rev-parse HEAD)

COMPARISON=$(git rev-list --left-right --count origin/main...origin/$BRANCH_NAME)
STRINGARRAY=($COMPARISON)
BEHIND=${STRINGARRAY[0]}

if [[ $BEHIND != 0 ]]; then
    github_commit_status update \
    --repo="$TARGET_REPO" \
    --commit="$COMMIT_HASH" \
    --status=error \
    --description="Migrations: Possible conflict (Rebase branch!)"
else
    github_commit_status update \
    --repo="$TARGET_REPO" \
    --commit="$COMMIT_HASH" \
    --status=success \
    --description="Migrations: No conflicts"
fi
