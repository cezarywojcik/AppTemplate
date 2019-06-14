##
# File: setup.sh
# Date: Jan 07, 2018 16:47:56
# Desc: Setup the template for the desired project.
# Auth: Cezary Wojcik
##

pod deintegrate
rm -rf .git

echo "What is the desired project name?"

read PROJECT_NAME

find . -exec rename -S 'Template' $PROJECT_NAME {} + # needs `brew install rename`
LC_ALL=C find . -type f -iname "*" -exec sed -i "" "s/Template/$PROJECT_NAME/g" "{}" +;
rm setup.sh

pod install
git init

