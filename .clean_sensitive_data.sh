rm config/database.yml
rm -rf .git
rm log/*.log
rm .clean_sensitive_data.sh
find . -type f -name "*~" -delete
find . -type f -name "*.swp" -delete
