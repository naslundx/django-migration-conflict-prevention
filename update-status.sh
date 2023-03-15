#!/bin/bash

set -ex

BRANCH_NAME="$1"
TARGET_REPO="django-migration-conflict-prevention"

git fetch origin "$BRANCH_NAME"
git checkout "origin/$BRANCH_NAME"
COMMIT_HASH=$(git rev-parse HEAD)

# Note! This currently only checks if the branch is _behind_ the main branch
# Should be optimized to check if there are any _migrations_ on the main branch
# not on the current branch

COMPARISON=$(git rev-list --left-right --count origin/main...origin/$BRANCH_NAME)
STRINGARRAY=($COMPARISON)
BEHIND=${STRINGARRAY[0]}

if [[ $BEHIND != 0 ]]; then
    STATUS="error"
    DESCRIPTION="Migrations: Possible conflict (Rebase branch!)"
else
    STATUS="success"
    DESCRIPTION="Migrations: No conflicts"
fi

# Post status to github
github_commit_status update \
    --repo="$TARGET_REPO" \
    --commit="$COMMIT_HASH" \
    --status="$STATUS" \
    --description="$DESCRIPTION"
