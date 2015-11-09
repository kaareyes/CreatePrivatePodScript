#!/bin/bash
# create Private Pods




getPodName () {
	clear
	echo "Please Enter [POD_NAME]"
	read podName
	if  [ ! -z "$podName" -a "$podName" != " " ]; then
		createPod $podName
	else
		getPodName
	fi

}

createPod () { 
	podName = $1
	echo "your pod name: $podName"
	pod lib create $1
}


createRepository () {
	echo "Enter Your Repository Link"
	read repLk
	if  [ ! -z "$repLk" -a "$repLk" != " " ]; then
		echo "YOUR REPOSITORY LINK: $repLk"
		echo "PLEASE UPDATE YOU PODSPEC are you done, Please Press a to continue"
		read -n 1
		createGitRemote $repLk

	else
		createRepository
	fi
}


 createGitRemote () {

 	repLink = $1
 	echo "$podName"
 	cd $podName
	git init
	git remote add origin $1
	git add -A
	git commit -m "Initial Commit"

	getTagVersion

 }

 getTagVersion () {
 	echo "Enter your Version:"
	read versionTag

 	if  [ ! -z "$versionTag" -a "$versionTag" != " " ]; then
		echo "Version: $versionTag"
		git tag -a $versionTag -m "Version $versionTag"
		git push -u origin master

		
	else
		getTagVersion
	fi
 }

 createPodRepo () {

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
 }



getPodName 
podName = ""
repLink = ""