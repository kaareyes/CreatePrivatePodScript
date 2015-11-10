#!/bin/bash
# create Private Pods


getPodName () {
	getHeader "Get POD NAME"
	echo "Please Enter [POD_NAME]"
	read podName
	if  [ ! -z "$podName" -a "$podName" != " " ]; then
		createPod $podName
	else
		getPodName
	fi

}

createPod () {
	getHeader "Creating POD"
	echo
	echo "your pod name: $podName"
	pod lib create $1
    createRepository
}


createRepository () {
	getHeader "Creating Repository"
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
	getHeader "Add Git remote"
 	repLink = $1
 	cd $podName
	git init
	git remote add origin $1
	git add -A
	git commit -m "Add Git remote"

	getTagVersion

 }

 getTagVersion () {
	getHeader "Add Tag Version"
 	echo "Enter your Version:"
	read versionTag

 	if  [ ! -z "$versionTag" -a "$versionTag" != " " ]; then
		echo "Version: $versionTag"
		git tag -a $versionTag -m "Version $versionTag"
        git tag
        git push --tags
        git push -u origin master
        createPodRepo
		
	else
		getTagVersion
	fi
 }

 createPodRepo () {
	getHeader "Creating Pod Repository"

 	if pod repo add $podName $repLk; then

	if pod lib lint $podName.podspec --verbose; then
		if pod spec lint $podName.podspec --verbose; then
			pod repo push $podName $podName.podspec
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


 getHeader (){
clear
echo "  ____  ___ ___  ____    ___  _ "        
echo " /    ||   |   ||    |  /  _]| |  "      
echo "|  o  || _   _ | |  |  /  [_ | |  "      
echo "|     ||  \_/  | |  | |    _]| |___"     
echo "|  _  ||   |   | |  | |   [_ |     |"    
echo "|  |  ||   |   | |  | |     ||     |"   
echo "|__|__||___|___||____||_____||_____|"  
                                        
echo " ____   ___    ____  ____"               
echo "|    \ /   \  /    ||    |"              
echo "|  o  )     ||   __| |  |"               
echo "|   _/|  O  ||  |  | |  |"               
echo "|  |  |     ||  |_ | |  |"               
echo "|  |  |     ||     | |  |"               
echo "|__|   \___/ |___,_||____|"              
                                        

	echo
	echo ">>>>> $1 <<<<<<"
	echo

}

getPodName 