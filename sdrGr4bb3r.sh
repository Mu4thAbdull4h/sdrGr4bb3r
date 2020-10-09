#!/bin/bash


declare -A tools
#                   tools[toolOrder]=[wget|apt],[toolName  ],[link|PackageName],[compressed(y),uncompressed(n)],[Installer(y),notInstaller(n)],[installcommand],[Rename]
# tools[toolOrder,PrerequisiteOrder]=[wget|apt],[PrereqName],[link|PackageName],[compressed(y),uncompressed(n)],[Installer(y),notInstaller(n)],[installcommand],[Rename]


#tools[0]='wget','SQLite','http://192.168.15.120/kali/sqlite-amalgamation-3330000.zip','y','y','','sqlite3'




#------------------------------------------------- dump1090 ------------------------------------------------
  tools[0]='wget','dump1090','https://github.com/MalcolmRobb/dump1090/archive/master.zip','y','y','make',''
tools[0,0]='apt','Realtek RTL2832U (development)','librtlsdr-dev','n','n','',''
tools[0,1]='apt','Realtek RTL2832U (library)','librtlsdr0','n','n','',''
#----------------------------------------------- IMSI-Catcher ----------------------------------------------
  tools[1]='wget','IMSI-Catcher','https://github.com/Oros42/IMSI-catcher/archive/master.zip','y','n','',''
tools[1,0]='apt','GnuRadio-Global System for Mobile Communications','gr-gsm','n','n','',''
#-------------------------------------------------- ADSBox -------------------------------------------------
  tools[2]='wget','ADSBox','http://ucideas.org/projects/hard/adsb/adsbox-20170518.tar.gz','y','y','make',''
tools[2,0]='wget','SQLite','https://www.sqlite.org/2020/sqlite-amalgamation-3330000.zip','y','y','','sqlite3'
#-------------------------------------------------- ACARS --------------------------------------------------
  tools[3]='wget','ACARS','https://github.com/gat3way/rtl_acars_ng/archive/master.zip','y','y','make',''
#-------------------------------------------------- Gqrx ---------------------------------------------------
  tools[4]='wget','Gqrx','https://github.com/csete/gqrx/releases/download/v2.11.5/gqrx-sdr-2.11.5-linux-x64.tar.xz','y','y','make',''
#------------------------------------------------- rtl_433 -------------------------------------------------
  tools[5]='apt','rtl_433','rtl-433','n','n','make',''
#--------------------------------------------- nrf905_decoder ----------------------------------------------
  tools[6]='wget','nrf905_decoder','https://raw.githubusercontent.com/texane/nrf/master/unit/range/nrf905_decoder/main.c','n','y','gcc -O2 -Wall -o nrf905_decoder main.c',''
#-------------------------------------------- kalibrate-HackRF ---------------------------------------------
  tools[7]='wget','kalibrate-HackRF','https://github.com/scateu/kalibrate-hackrf/archive/master.zip','y','y',"./bootstrap && CXXFLAGS='-W -Wall -O3' ./configure && make",''
tools[7,0]='apt','Libtool','libtool','n','n','',''
tools[7,0]='apt','Libtool','libhackrf-dev','n','n','',''







# -- Define Colors

   red='\033[031;1m';
yellow='\033[033;1m';
 white='\033[037;1m';
 green='\033[032;1m';
normal='\033[037;0m';
  blue='\033[034;1m';


# -- Define Global Variables
	iPath="";
TimeDelay=0.1;
  NewName="";




# -- check internet connection
isOnline()
{ 
	ping -q -w1 -c1 google.com &>/dev/null && echo 1 || echo 0 ;
#	ping -q -w1 -c1 192.168.15.120 &>/dev/null && echo 1 || echo 0 ;
}



# -- check root user
rootCheck()
{
	echo $UID;
}



# -- check if you inserted installing path
setPath()
{
	if [ ! -n "$1" ] || [ ! -d "$1" ] ; then
		iPath="$(pwd)";
	else
		iPath="$1";
	fi 
}





# -- Check if The Path is Empty
isFileExists()
{
	sleep $TimeDelay
	if [ -f "$iPath/$1" ] ; then
		echo 0;
	else
		echo 1;
	fi
}



# -- check if Compressed
isCompressed()
{
  if [ $1 = 'y' ] ; then 
		echo '0'
  else 
		echo '1'
  fi 
}


# -- check Installer flag 
isInstaller()
{
  if [ $1 = 'y' ] ; then 
		echo '0'
  else 
		echo '1'
  fi
}



# -- unzip 
_unzip()
{
	sleep $TimeDelay
	unzip -l "$iPath/$1" | sed -n -e '5p' | cut -c 31- | cut -d'/' -f 1
	$(unzip -o -qq "$iPath/$1" -d "$iPath")
	return $?
}



# -- tar 
_tar()
{
	tar -xvf "$iPath/$1" --directory "$iPath" | cut -d'/' -f1 | sed -n -e '1p'	
	return $?
}



# -- apt install 
_apt()
{
	apt install -y $2 &> /dev/null
	if [ "$?" = "0" ] ; then
		echo -e "[apt   ] install ${white}$2${normal} is ${green}done${normal} successfully.";
		return 0;
	else
		echo -e "[apt   ] install ${white}$2${normal} is ${red}FAILED${normal}.";
		return 1
	fi
}




# -- _rm file
_rm()
{
	sleep $TimeDelay;
	if [ -f "$2/$1" ] ; then 
		rm "$2/$1";
	elif [ -d "$2/$1" ] ; then
		rm -r "$2/$1";
	fi

	if [ "$?" = "0" ] ; then
		echo -e "[rm    ] ${white}$1${normal}, ${green}deleted${normal} successfully .";
		return 0
	else
		echo -e "[rm    ] ${white}$1${normal}, ${red}FAILED${normal} to delete .";
		return 1;
	fi	
}




# -- wget
_wget()
{
	$(wget $1 -O "${iPath}/$2" &> /dev/null)
	sleep $TimeDelay
	if [ "$?" = "0" ] ; then 
		echo 0
	else 
		echo 1
	fi 	
}


# -- rename the file 
_rename()
{
	_rm $2 $iPath
	if [[ "$?" != "0" ]]
	then
		return 1;
	fi 
	mv "$iPath/$1" "$iPath/$2"
	return $?
}



_make()
{
	if [ $(isCompressed $2) = 0 ] ; then 
		echo -e "[Path  ] $iPath/$NewName";
		if [ "$3" != "" ] ; then echo -e "[cmd   ] ${3}"; fi 		
		cd $iPath/$NewName ;		
		if [ $? = '0' ] ; then
			if [[ $(eval $3 &> /dev/null) = 0 ]] ; then
				echo -e "[make  ] ${white}$1${normal}, ${green}Installed successfully${normal}.";
			fi		
		fi		
	else 
		echo -e "[Path  ] $iPath";
		cd $iPath ;
		if [ $? = '0' ] ; then
			if [ "$($3)" = "0" ] ; then
				echo -e "[make  ] ${white}$1${normal}, ${green}Installed successfully${normal}.";
			fi		
		fi			
	fi
	
}



# -- unpack the package
_unpack()
{
	ExtractExtension=$(echo $1 | rev | cut -d '.' -f 1 | rev)
	     ExtractName=$(echo $1 | rev | cut -d '.' -f 2- | rev)
		 
	echo -e "[comp  ] ${white}$1${normal} Compression Type is ${white}$ExtractExtension ${normal}."
	if [ "$ExtractExtension" = "zip" ] ; then
		NewName=$(_unzip "$1")
		if [[ "$?" -eq "0" ]] ; then 
			echo -e "[zip   ] ${white}$1${normal} extracted to ${white}$NewName ${green}Successfully${normal}."
		else
			echo -e "[zip   ] ${white}$1${normal} extracting to ${white}$NewName ${normal}is ${red}Failed${normal}."
			return 1
		fi 
	elif [ "$ExtractExtension" == "tar" ] || [ "$ExtractExtension" == "xz" ] || [ "$ExtractExtension" == "gz" ]
	then
		NewName=$(_tar "$1")
		if [[ "$?" -eq "0" ]] ; then 
			echo -e "[tar   ] ${white}$1${normal} extracted to ${white}$NewName ${green}Successfully${normal}."
		else
			echo -e "[tar   ] ${white}$1${normal} extracting to ${white}$NewName ${normal}is ${red}Failed${normal}."
			return 1
		fi 
	else 
		echo -e "[-     ] Not Knownen."
		return 0;	
	fi
	return $?
}











# -- wget the file and detect FileName
wgetFunc()
{
	ExtractFileName=$(echo $2 | cut -d '/' -f $(($(echo $2 | grep -o '/' | wc -l)+1)));	
	Link=$2;
	if [[ $(isFileExists $ExtractFileName) -eq 0 ]] ; then
		_rm "$ExtractFileName" "$iPath"
		if [[ $? -eq 1 ]]
		then 
			return 1
		fi 
	fi
	
	if [ $(_wget ${Link} $ExtractFileName) -eq 0 ] ; then
		echo -e "[wget  ] ${white}$1${normal}, ${green}Downloaded successfully${normal}.";
	else 
		echo -e "[wget  ] ${white}$1${normal}, ${red}Downloaded unsuccessfully${normal}.";
		return 1
	fi
	
	if [[ "$?"  -eq '0' ]] ; then
		if [ $(isCompressed $3) = 0 ] ; then 
			_unpack $ExtractFileName $1;
			if [ $? = 0 ] ; then 
			_rm $ExtractFileName $iPath
			fi 
		fi
		
		if [ "$6" != "" ] ; then 
			_rename $NewName $6 ;
			if [ $? -eq 0 ] ; then 
				echo -e "[rename] ${white}$NewName${normal} renamed to ${white}$6 ${green}successfully${normal}.";
				NewName="$6";
			else 
				echo -e "[rename] ${white}$NewName${normal} renamed to ${white}$6 ${red}unsuccessfully${normal}.";
				return 1;
			fi 
			
		fi
		
		if [ $(isInstaller $4)  = 0 ] ; then   _make $ExtractFileName $3 "$5"; fi
		
		sleep $TimeDelay
		if [[ "$?" -eq '0' ]] ; then
			$(echo -e "")
		else
			return 1;
		fi
	else 
		return 1;
	fi
	return 0;
}











# -- prerequisitesList List
prerequisitesList()
{
	ToolName=$(echo ${tools[$1]} | cut -d ',' -f 2)
	sleep $TimeDelay
	c=0;
	while [ -n "${tools[$1,$c]}" ];do 
		      wgetOrApt=$(echo ${tools[$1,$c]} | cut -d ',' -f 1)
		    PackageName=$(echo ${tools[$1,$c]} | cut -d ',' -f 2)
		        Package=$(echo ${tools[$1,$c]} | cut -d ',' -f 3)
		CompressionType=$(echo ${tools[$1,$c]} | cut -d ',' -f 4)
		   InstallOrNot=$(echo ${tools[$1,$c]} | cut -d ',' -f 5)
		MakeFileOptions=$(echo ${tools[$1,$c]} | cut -d ',' -f 6)
			   RenameTo=$(echo ${tools[$1,$c]} | cut -d ',' -f 7)
		
		
		echo -e "[Prereq] ${yellow}${PackageName}'s${normal} downloading and installing.";
		
		
		if [ $wgetOrApt = "apt" ] ; then 
			_apt "${PacakgeName}" "${Package}"
		else
			wgetFunc "${PackageName}" "${Package}" "${CompressionType}" "${InstallOrNot}" "${MakeFileOptions}" "$RenameTo"
		fi
		
		if [ "$?" = "1" ] ; then
			return 1
		fi
		let "c+=1"
	done
	return 0
}




# -- prerequisitesList List
toolInstaller()
{
	sleep $TimeDelay
		  wgetOrApt=$(echo ${tools[$1]} | cut -d ',' -f 1)
		PackageName=$(echo ${tools[$1]} | cut -d ',' -f 2)
			Package=$(echo ${tools[$1]} | cut -d ',' -f 3)
	CompressionType=$(echo ${tools[$1]} | cut -d ',' -f 4)
	   InstallOrNot=$(echo ${tools[$1]} | cut -d ',' -f 5)
	MakeFileOptions=$(echo ${tools[$1]} | cut -d ',' -f 6)
		   RenameTo=$(echo ${tools[$1]} | cut -d ',' -f 7)

	if [ $wgetOrApt = "apt" ] ; then 
		_apt "${PacakgeName}" "${Package}"
	else
		wgetFunc "${PackageName}" "${Package}" "${CompressionType}" "${InstallOrNot}" "${MakeFileOptions}" "$RenameTo"
	fi
	
	if [ "$?" = "1" ] ; then
		return 1
	fi

	return 0
}




mainFunction()
{
	ToolNumber=0;
	while [ -n "${tools[$ToolNumber]}" ]
	do 
		ToolName=$(echo ${tools[$ToolNumber]} | cut -d ',' -f 2)
		
		echo -e "[ ${red}Tool${normal} ] ${white}${ToolName}${normal} and its prerequisites downloading.";
		
		prerequisitesList $ToolNumber
		if [ "$?" = "0" ] ; then 	
			echo -e "[${green}■■■■■■${normal}] All ${white}${ToolName}'s${normal} prerequisites downloaded and ${green}Installed${normal} Successfully.";
			echo -e "[${blue} ---> ${normal}] Installing ${white}${ToolName}'s${normal} will start.";
			toolInstaller $ToolNumber			
		else 						
			echo -e "[${red}■■■■■■${normal}] ${white}${ToolName}'s${normal} prerequisites ${red}FAILED${normal} to download and Install Successfully.";
		fi 
		let "ToolNumber+=1";
	done	

}



main()
{
	echo -e "[*     ] Check internet Connection..";	
	if [[ $(isOnline) -eq 1 ]] ; then
		echo -e "[+     ] You are ${green}online.${normal}";
		sleep $TimeDelay;
	else
		echo -e "[-     ] You are ${red}offline.${normal}";
		sleep $TimeDelay;
		echo -e "[*     ] ${yellow}Bye.${normal}";
		exit 0;
	fi	
	
	if [[ $(rootCheck) -eq '0' ]] ; then
		echo -e "[+     ] You are ${green}root${normal}.";
		sleep $TimeDelay;
		echo -e "[*     ] We will Continue...";		
		sleep $TimeDelay;
		setPath $1;
		echo -e "[${white}Path ${normal} ] Installing path : ${white}${iPath}${normal}.";		
		sleep $TimeDelay;
		
		#-- Start Installing 
		echo -e "[*     ] ${red}We Will start in 3s${normal}.";
		sleep 3;
		echo -e "[${yellow}START${normal} ]";
		mainFunction
		echo -e "[${yellow}END${normal}   ]";
		echo -e "[*     ] ${yellow}Installation Finished${normal}.";
		#--   End Installing 
		
	else
		echo -e "[-     ] You are NOT ${red}root${normal}.";
		sleep $TimeDelay;
		echo -e "[*     ] We will Stop here.";
		sleep $TimeDelay;
		echo -e "[+     ] ${yellow}Bye.${normal}";
	fi
	return 0;
}





hlp()
{
	echo -e ""
	echo -e "#----------------------------------------------------------------,";
	echo -e "#                                                                |";
	echo -e "#             ${red}●${normal} ${red}●${normal}                           ${red}●${normal}                    |";
	echo -e "#         ${red}●${normal}   | |     ${red}●${normal}         ${red}●${normal}         ${red}●${normal} | ${red}●${normal}     ${red}●${normal}            |";
	echo -e "#         | ${red}●${normal} | | |   | ${red}●${normal}       |       ${red}●${normal} | | |   ${red}●${normal} |            |";
	echo -e "#         | | | | |   | |       |       | | | | ${red}●${normal} | |            |";
	echo -e "#---+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+------------|";
	echo -e "#   | | |           |     | | |   | | |                          |";
	echo -e "#   ${red}●${normal} | ${red}●${normal}           |     | ${red}●${normal} ${red}●${normal}   | | |                          |";
	echo -e "#     |             |     ${red}●${normal}       | | ${red}●${normal}       ${white} SDR for debian${normal}    |";
	echo -e "#     ${red}●${normal}             |             | ${red}●${normal}         ${white} v0.1 2020.Oct.9${normal}   |";
	echo -e "#                   ${red}●${normal}             ${red}●${normal}                              |";
	echo -e "#----------------------------------------------------------------+";
	echo -e "# usage  : ./sdrGr4bb3r [PathToInstall] (def. : CurrentFolder )  |";
	echo -e "# Author : Muath Abdullah                                        |";
	echo -e "#  Email : m0az@outlook.com                                      |";
	echo -e "#----------------------------------------------------------------'";
	echo -e ""
}






# -- First Run Part

if [ -n $1 ] && [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
	hlp;
else
	main $1
fi


