cd $source_directory
echo "REVIEWBOARD_URL = 'https://rbcommons.com/s/ecdemo/'" > .reviewboardrc
echo "REPOSITORY = 'dockercon'" >> .reviewboardrc
post-review --username USERNAME --password PASSWORD --parent=HEAD --target-people TARGET --description="$review_description" --summary="$review_summary" --publish
