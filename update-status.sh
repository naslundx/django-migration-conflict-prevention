#!/bin/bash
# export GITHUB_COMMIT_STATUS_TOKEN="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"

set -ex

TARGET_REPO="django-migration-conflict-prevention"

git init
git remote add origin "https://github.com/naslundx/$TARGET_REPO" || true
git fetch origin main

PR=$(gh pr list --label 'has-migrations' --json headRefName | jq '.[].headRefName' | tr -d '"')

for ref in "$PR"
do
    git fetch origin "$ref"
    git checkout "origin/$ref"
    COMMIT_HASH=$(git rev-parse HEAD)

    COMPARISON=$(git rev-list --left-right --count origin/main...origin/$ref)
    stringarray=($TEST)
    BEHIND=${stringarray[0]}
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

    

    # gh workflow run check-migration.yml --ref "$ref"
done


