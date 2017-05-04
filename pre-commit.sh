#!/bin/sh
bar="######################################################################################"
# check for eslint
if [ ! -f ./node_modules/eslint/bin/eslint.js ]; then
	echo $bar
	echo "INFO: Installing eslint to ensure the JavaScript files you are committing are valid."
	echo $bar
	which npm > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "COMMIT FAILED: The command `npm` could not be found. Please install node so you can use npm to install eslint to commit your code\n"
		exit 1
	else
		pwd
		npm install
		if [ $? != 0 ]; then
			echo "COMMIT FAILED: Dependency installation failed for eslint. Try running `npm install` manually.\n"
			exit 1
		fi
	fi
fi

files=$(git diff --cached --name-only --diff-filter=ACM | grep "\.js$")
if [ "$files" = "" ]; then
    exit 0
fi
pass=true
for file in ${files}; do
		node_modules/eslint/bin/eslint.js ${file}
    if [ $? != 0 ]; then
        pass=false
    fi
done

if ! $pass; then
    echo "COMMIT FAILED: Your commit contains files that should pass eslint but do not. Please fix the eslint errors and try again.\n"
    exit 1
fi
