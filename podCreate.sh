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
pod lib lint $podName.podspec
pod spec lint $podName.podspec
pod repo add $podName $repLink
pod repo push $podName.podspec



