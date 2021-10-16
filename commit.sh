
git add .
git status
if [ "$1" == "" ]; then read -p 'Enter commit comment: ' comment
else comment="$1"
fi
git commit -m "$comment"
git push
git push --tags

