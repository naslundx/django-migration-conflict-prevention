PR=$(gh pr list --label 'Has migrations' --json headRefName | jq '.[].headRefName' | tr -d '"')
for ref in "$PR"
do
    echo $ref
    gh workflow run check-migration.yml --ref "$ref"
done
