#!/bin/bash
# create Private Pods
clear
echo "Please Enter [POD_NAME]"
read podName
echo "your pod name: $podName"
pod lib create $podName
echo "Enter Your Repository Link"
read repLink
echo "YOUR REPOSITORY LINK: $repLink"
echo "PLEASE UPDATE YOU PODSPEC are you done, Please Press a to continue"
read -n 1
cd $podName
git init
git remote add origin $repLink
git add -A
git commit -m "Initial Commit"
echo "Enter your Version:"
read versionTag
echo "Version: $versionTag"
git tag -a $versionTag -m "Version $versionTag"
git push -u origin master

if pod repo add $podName $repLink; then

	if pod lib lint $podName.podspec -- verbose; then
		if pod spec lint $podName.podspec -- verbose; then
			pod repo push $podName.podspec
		else
			echo "Error  pod spec lint $podName.podspec" 1>&2
			exit 1
		fi
		
	
	else
		echo "Error pod lib lint $podName.podspec" 1>&2
		exit 1
	fi

	
else
	echo "cant add repo" 1>&2
	exit 1
fi


