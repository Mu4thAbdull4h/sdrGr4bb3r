#!/bin/bash



# -- Define Colors
	c30='\e[30m';		#black;	
	c31='\e[31;1m'; 	#red
	c32='\e[32;1m'; 	#green
	c33='\e[33;1m'; 	#yellow
	c34='\e[34;1m'; 	#blue
	c27='\e[37;1m'; 	#white 
	c37='\e[37;2m'; 	#darkwhite	 
	c39='\e[39;0m'; 	#normal
	c08='\e[8m';		#hidden
	c22='\e[32;2m'; 	#greendark 
	c23='\e[32;2m'; 	#yellowdark 
	c05='\e[5m';		#blink
	c25='\e[25m';		#unblink
  
declare -A tools
#                   tools[toolOrder]=[wget|apt],[toolName  ],[link|PackageName],[compressed(y),uncompressed(n)],[Installer(y),notInstaller(n)],[installcommand],[Rename]
# tools[toolOrder,PrerequisiteOrder]=[wget|apt],[PrereqName],[link|PackageName],[compressed(y),uncompressed(n)],[Installer(y),notInstaller(n)],[installcommand],[Rename]


#------------------------------------------------- dump1090 ------------------------------------------------
   tools[0]='wget','dump1090','https://github.com/MalcolmRobb/dump1090/archive/master.zip','y','y','make',''
 tools[0,0]='apt','Realtek RTL2832U (development)','librtlsdr-dev','n','n','',''
 tools[0,1]='apt','Realtek RTL2832U (library)','librtlsdr0','n','n','',''
#----------------------------------------------- IMSI-Catcher ----------------------------------------------
  tools[1]='wget','IMSI-Catcher','https://github.com/Oros42/IMSI-catcher/archive/master.zip','y','n','',''
tools[1,0]='apt','GnuRadio-Global System for Mobile Communications','gr-gsm','n','n','',''
#-------------------------------------------------- ADSBox -------------------------------------------------
  tools[2]='wget','ADSBox','http://ucideas.org/projects/hard/adsb/adsbox-20170518.tar.gz','y','y','make',''
tools[2,0]='wget','SQLite','https://www.sqlite.org/2020/sqlite-amalgamation-3330000.zip','y','n','','sqlite3'
#-------------------------------------------------- ACARS --------------------------------------------------
  tools[3]='wget','ACARS','https://github.com/gat3way/rtl_acars_ng/archive/master.zip','y','y','make',''
#-------------------------------------------------- Gqrx ---------------------------------------------------
  tools[4]='wget','Gqrx','https://github.com/csete/gqrx/releases/download/v2.11.5/gqrx-sdr-2.11.5-linux-x64.tar.xz','y','n','make',''
#------------------------------------------------- rtl_433 -------------------------------------------------
   tools[5]='apt','rtl_433','rtl-433','n','n','make',''
#--------------------------------------------- nrf905_decoder ----------------------------------------------
  tools[6]='wget','nrf905_decoder','https://raw.githubusercontent.com/texane/nrf/master/unit/range/nrf905_decoder/main.c','n','y','gcc -O2 -Wall -o nrf905_decoder main.c',''
#-------------------------------------------- kalibrate-HackRF ---------------------------------------------
#tools[7]='wget','kalibrate-HackRF','https://github.com/scateu/kalibrate-hackrf/archive/master.zip','y','y',"./bootstrap && CXXFLAGS='-W -Wall -O3' ./configure && make && make install",''
   tools[7]='apt','kalibrate-rtl','kalibrate-rtl','n','n','',''  
 tools[7,0]='apt','Libtool','libtool','n','n','',''
 tools[7,1]='apt','libhackrf-dev','libhackrf-dev','n','n','',''
#----------------------------------------------- GPS-SDR-SIM -----------------------------------------------
  tools[8]='wget','GPS-SDR-SIM','https://github.com/osqzss/gps-sdr-sim/archive/master.zip','y','y','make USER_MOTION_SIZE=4000',''
tools[8,0]='apt','apt-transport-https','apt-transport-https','n','n','',''
#-------------------------------------------- Google Earth Pro ---------------------------------------------
  tools[9]='wget','Google Earth Pro','https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb','n','y','dpkg -i google-earth-pro-stable_current_amd64.deb',''
#------------------------------------ Gr-limesdr Plugin for GNURadio ---------------------------------------
 tools[10]='apt','Gr-limesdr Plugin for GNURadio','gr-limesdr','n','n','',''


# #------------------------------------------------ SigDigger ------------------------------------------------
# # tools[10]='wget','SigDigger','https://github.com/BatchDrake/SigDigger/releases/download/v0.1.0/SigDigger-0.1.0-x86_64-full.AppImage','n','n','',''
# # #------------------------------------------------- Linrad --------------------------------------------------
  # # tools[0]='wget','Linrad','http://www.sm5bsz.com/linuxdsp/archive/lir04-14a.zip','y','y','make xlinrad',''










str00='';
str01='echo -e "${c32}⊕${c39} ${c27}apt Install $2${c39} : ${c22}successful${c39}."';
str02='echo -e "${c31}⊖${c39} ${c27}apt Install $2${c39} : ${c31}FAILED${c39}."';
str03='echo -e "${c37}⊘${c39} ${c37}Deleting path == installing path {c39}, ${c33}delete aborted${c39}."';
str04='echo -e "${c32}⊕${c39} Deleting ${c37}$1${c39} : ${c22}successful${c39}."';
str05='echo -e "${c31}⊖${c39} Deleting ${c37}$1${c39} : ${c31}FAILED${c39}."';
str06='echo -e "${c37}⊘${c39} cd ${c22}$iPath/$NewName${c39}."';
str07='echo -e "${c37}⊘${c39} Command : ${c37}${3}${c39}"';
str08='echo -e "${c32}⊕${c39} ${c27}Installing $4${c39} : ${c22}successful${c39}."';
str09='echo -e "${c31}⊖${c39} ${c27}Installing $4${c39} : ${c31}FAILED${c39}."';
str10='echo -e "${c37}⊘${c39} $iPath"';
str11='echo -e "${c37}⊘${c39} \$${c31}>${c39}${c37}${3}${c39}"';
str12='echo -e "${c32}⊕${c39} ${c27}$4 install ${c39}: ${c22}successful${c39}."';
str13='echo -e "${c31}⊖${c39} ${c27}$4 install ${c39}: ${c31}FAILED${c39}."';
str14='echo -e "${c37}⊘${c39} ${c37}$1${c39} Compression Type is ${c23}${ExtractExtension}${c39}."';
str15='echo -e "${c32}⊕${c39} ${c37}$1${c39} extract to ${c37}$NewName : ${c22}Successful${c39}."';
str16='echo -e "${c31}⊖${c39} ${c37}$1${c39} extract to ${c37}$NewName : ${c39}is ${c31}Failed${c39}."';
str17='echo -e "${c32}⊕${c39} ${c37}$1${c39} extract to ${c37}$NewName : ${c22}Successful${c39}."';
str18='echo -e "${c31}⊖${c39} ${c37}$1${c39} extract to ${c37}$NewName : ${c39}is ${c31}Failed${c39}."';
str19='echo -e "${c32}⊕${c39} Download ${c37}$1${c39} : ${c22}successful${c39}."';
str20='echo -e "${c31}⊖${c39} Download ${c37}$1${c39} : ${c31}FAILED${c39}."';
str21='echo -e "${c32}⊕${c39} ${c37}$NewName${c39} rename to ${c37}$6${c39} : ${c22}successful${c39}."';
str22='echo -e "${c31}⊖${c39} ${c37}$NewName${c39} rename to ${c37}$6${c39} : ${c31}FAILED${c39}."';
str23='echo -e "${c22}⊚${c39} ${c23}${PackageName}${c39} downloading and installing."';
str24='echo -e "${c33}⊛${c25}${c39} ${c32}${ToolName}${c33} and its prerequisites downloading${c39}."';
str25='echo -e "${c32}⊕${c39} ${c37}${ToolName}${c39} prerequisites download and install : ${c22}successful${c39}.";';
str26='echo -e "${c37}⊘${c39} Installing ${c37}${ToolName}${c39} will start."';
str27='echo -e "${c31}⊖${c39} ${c37}${ToolName}${c39} prerequisites download and install : ${c31}FAILED${c39}.";';
str28='echo -e "${c37}⊘${c39} Check internet Connection..";';
str29='echo -e "${c32}⊕${c39} You are ${c32}online.${c39}";';
str30='echo -e "${c31}⊖${c39} You are ${c31}offline.${c39}";';
str31='echo -e "${c33}!${c39} ${c33}Bye.${c39}";';
str32='echo -e "${c32}⊕${c39} You are ${c32}root${c39}.";';
str33='echo -e "${c37}⊘${c39} We will Continue...";';
str34='echo -e "${c37}⊘${c39} Installing path : ${c37}${iPath}${c39}.";';
str35='echo -e "${c33} ${c39} ${c33}We Will start${c39}.";';
str36='echo -e "${c39}\n☢${c39} - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -";';
str37='echo -e "${c39}☢${c39} - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n";';
str38='echo -e "${c33} ${c39} ${c33}Installation Finished${c39}.\n";';
str39='echo -e "${c31}⊖${c39} You are NOT ${c31}root${c39}.";';
str40='echo -e "${c37}⊘${c39} We will Stop here.";';
str41='echo -e "${c33}!${c39} ${c33}Bye.${c39}";';





# -- Define Global Variables
	iPath="";
  NewName="";


		


# -- check internet connection
isOnline()
{
	
	ping -q -w1 -c1 google.com &>/dev/null && true || false ;
#	ping -q -w1 -c1 192.168.15.120 &>/dev/null && echo 1 || echo 0 ;
}



# -- check root user
isRoot()
{
	if [[ $UID -eq 0 ]]
	then
		 true  ; return ;
	else false ; return ;	
	fi	
}



# -- check if you inserted installing path
setiPath()
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
	[ -f "$iPath/$1" ]
}


#
# These Three Functions are for use after extract Payload information
# from the Tools Array
# ------------------------------------------------------------------.
getExtension()														#
{																	# 
	echo $1 | rev | cut -d '.' -f 1 | rev;							#
}																	#
getName()															#
{																	#
	echo $1 | rev | cut -d '.' -f 2- | rev;							#
}																	#
getFileName()														#
{																	#
	echo $1 | cut -d '/' -f $(($(echo $1 | grep -o '/' | wc -l)+1));#
}																	#
# ------------------------------------------------------------------`




# -- -- -- -- Conditions checking start 
isdeb() 
{
	if [ "$1" = 'deb' ]
	then
		 true  ; return ;
	else false ; return ;	
	fi	
}
isCompressed()
{
	if [ "$1" = 'y' ]
	then
		 true  ; return ;
	else false ; return ;	
	fi	
}
isInstaller()
{
	if [ "$1" = 'y' ]
	then
		 true  ; return ;
	else false ; return ;	
	fi	
}
isApt()
{
	if [ "$1" = 'apt' ]
	then
		 true  ; 
	else false ; 	
	fi	
}
isExists()
{
	if [ -n "${tools[$1]}" ]
	then
		 true  ; return ;
	else false ; return ;	
	fi	
}
# -- -- -- -- Conditions checking end 




# -- Tools Array Informations extraction start
getPckgType()
{
	if [ $2 ] ; then
		echo "${tools[$1,$2]}" | cut -d ',' -f 1;
	else
		   echo "${tools[$1]}" | cut -d ',' -f 1;
	fi
}
getPckgName()
{
	if [ $2 ] ; then
		echo "${tools[$1,$2]}" | cut -d ',' -f 2;
	else
		   echo "${tools[$1]}" | cut -d ',' -f 2;
	fi
}
getPckgPayload()
{
	if [ $2 ] ; then
		echo "${tools[$1,$2]}" | cut -d ',' -f 3;
	else
		   echo "${tools[$1]}" | cut -d ',' -f 3;
	fi
}
getPckgCompression()
{
	if [ $2 ] ; then
		echo "${tools[$1,$2]}" | cut -d ',' -f 4;
	else
		   echo "${tools[$1]}" | cut -d ',' -f 4;
	fi
}
getPckgInstaller()
{
	if [ $2 ] ; then
		echo "${tools[$1,$2]}" | cut -d ',' -f 5;
	else
		   echo "${tools[$1]}" | cut -d ',' -f 5;
	fi
}
getPckgSetup()
{
	if [ $2 ] ; then
		echo "${tools[$1,$2]}" | cut -d ',' -f 6;
	else
		   echo "${tools[$1]}" | cut -d ',' -f 6;
	fi
}
getPckgRename()
{
	if [ $2 ] ; then
		echo "${tools[$1,$2]}" | cut -d ',' -f 7;
	else
		   echo "${tools[$1]}" | cut -d ',' -f 7;
	fi
}
# -- Tools Array Informations extraction end




# -- apt 
_apt()
{
	apt install -y $2 &> /dev/null
	if [ $? ]; then
		  eval $str01;
		  true;return;
	else
		  eval $str02;
		 false;return;
	fi
}

# -- wget
_wget()
{
	$(wget $1 -O "${iPath}/$2" &> /dev/null);
}


# -- unzip 
_unzip()
{
	unzip -l "$iPath/$1" | sed -n -e '5p' | cut -c 31- | cut -d'/' -f 1;
	$(unzip -o -qq "$iPath/$1" -d "$iPath");
}



# -- tar 
_tar()
{
	tar -xvf "$iPath/$1" --directory "$iPath" | cut -d'/' -f1 | sed -n -e '1p';
}






# -- _rm file
_rm()
{

	if [ "$iPath/" = "$2/$1" ] ; then
		eval $str03;
	elif [ -f "$2/$1" ] ; then 
		rm "$2/$1";
	elif [ -d "$2/$1" ] ; then
		rm -r "$2/$1";
	else
		return 1;
	fi

	if [ $? ] ; then
		eval $str04;
		return 0;
	else
		eval $str05;
		return 1;
	fi	
}





# -- rename the file 
_rename()
{
	_rm $2 $iPath;	
	if [ $? ] ;	then
		mv "$iPath/$1" "$iPath/$2";
		return $?;
	fi 
	return 1;	
}






_make()
{
	if $(isCompressed $2); then 
		eval $str06;
		eval $str07;
		cd "$iPath/$NewName";
		if [ $? ] ; then
			if $(eval $3 &> /dev/null) ; then
				eval $str08;
				return 0;
			else
				eval $str09;
				return 1;
			fi
		fi		
	else 
		eval $str10;
		eval $str11;
		cd "$iPath";
		if [ $? ] ; then			
			if $(eval $3 &> /dev/null) ; then
				eval $str12;
				return 0;
			else
				eval $str13;
				return 1;
			fi					
		fi			
	fi
}



# -- unpack the package
_unpack()
{
	ExtractExtension=$(echo $1 | rev | cut -d '.' -f 1 | rev)
	     ExtractName=$(echo $1 | rev | cut -d '.' -f 2- | rev)
		 
	eval $str14;
	if [ "$ExtractExtension" = "zip" ] ; then
		NewName="$(_unzip "$1")"
		if [ $? ]; then 
			eval $str15;
		else
			eval $str16;
			false;return;
		fi 
	elif [ "$ExtractExtension" == "tar" ] || [ "$ExtractExtension" == "xz" ] || [ "$ExtractExtension" == "gz" ]
	then
		NewName="$(_tar "$1")"
		if [ $? ]; then 
			eval $str17;
		else
			eval $str18;
			false;return;
		fi 
	else 
		echo -e "[-     ] unknown."
		false;return;	
	fi
	return $?
}











# -- wget the file and detect FileName
wgetFunc()
{
	ExtractFileName=$(echo $2 | cut -d '/' -f $(($(echo $2 | grep -o '/' | wc -l)+1)));	
	
	Link=$2;
	if $(isFileExists $ExtractFileName); then
		_rm "$ExtractFileName" "$iPath"
		if [ $? ];
		then 
			true;
		else
			false ; return;
		fi 
	fi
	
	if $(_wget $Link $ExtractFileName); then
		eval $str19;
	else 
		eval $str20;
		return 1;
	fi
	
	if [[ "$?"  -eq '0' ]] ; then
		if $(isCompressed $3); then 
			_unpack $ExtractFileName $1;
			if [ $? = 0 ] ; then 
			_rm $ExtractFileName $iPath
			fi 
		fi
		
		if [ "$6" != "" ] ; then 
			_rename $NewName $6 ;
			if [ $? -eq 0 ] ; then 
				eval $str21;
				NewName="$6";
			else 
				eval $str22;
				return 1;
			fi 
			
		fi
		
		if $(isInstaller $4); 
		then   
			_make "$ExtractFileName" "$3" "$5" "$1"; 
		fi
		
		if [ $? ] ; then

			if [[ $(getExtension $(getFileName $2)) = 'deb' ]];
			then 				
				_rm $(getFileName $2) $iPath;
			fi
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

	c=0;
	while [ -n "${tools[$1,$c]}" ];do 
		      wgetOrApt=$(echo ${tools[$1,$c]} | cut -d ',' -f 1)
		    PackageName=$(echo ${tools[$1,$c]} | cut -d ',' -f 2)
		        Package=$(echo ${tools[$1,$c]} | cut -d ',' -f 3)
		CompressionType=$(echo ${tools[$1,$c]} | cut -d ',' -f 4)
		   InstallOrNot=$(echo ${tools[$1,$c]} | cut -d ',' -f 5)
		MakeFileOptions=$(echo ${tools[$1,$c]} | cut -d ',' -f 6)
			   RenameTo=$(echo ${tools[$1,$c]} | cut -d ',' -f 7)
		
		
		eval $str23;
		
		if $(isApt $(getPckgType $1 $c))
		then 
			_apt "$(getPckgName $1 $c)" "$(getPckgPayload $1 $c)"
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

		  wgetOrApt=$(echo ${tools[$1]} | cut -d ',' -f 1)
		PackageName=$(echo ${tools[$1]} | cut -d ',' -f 2)
			Package=$(echo ${tools[$1]} | cut -d ',' -f 3)
	CompressionType=$(echo ${tools[$1]} | cut -d ',' -f 4)
	   InstallOrNot=$(echo ${tools[$1]} | cut -d ',' -f 5)
	MakeFileOptions=$(echo ${tools[$1]} | cut -d ',' -f 6)
		   RenameTo=$(echo ${tools[$1]} | cut -d ',' -f 7)

	if $(isApt $(getPckgType $1))
	then 
		_apt "$(getPckgName $1)" "$(getPckgPayload $1)"
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
		ToolName=$(echo ${tools[$ToolNumber]} | cut -d ',' -f 2);		
		eval $str24;		
		prerequisitesList $ToolNumber
		if [ "$?" = "0" ] ; then 	
			eval $str25;
			eval $str26;
			toolInstaller $ToolNumber
		else 						
			eval $str27;
		fi 
		let "ToolNumber+=1";
	done	
}



main()
{
	eval $str28;
	if isOnline; then
		eval  $str29;
	else
		eval  $str30;
		eval  $str31;
		exit  0;
	fi	
	
	if isRoot ; then
		eval  $str32;
		eval  $str33;
		setiPath $1;
		eval  $str34;
		
		#-- Start Installing 
		eval  $str35;
		eval  $str36;
		mainFunction
		eval  $str37;
		eval  $str38;
		#--   End Installing 
		
	else
		eval  $str39;
		eval  $str40;
		eval  $str41;
	fi
	return 0;
}





hlp()
{
	echo -e ""
	echo -e "#----------------------------------------------------------------,";
	echo -e "#                                                                |";
	echo -e "#             ${c31}●${c39} ${c31}●${c39}                           ${c31}●${c39}                    |";
	echo -e "#         ${c31}●${c39}   | | ${c31}●${c39}   ${c31}●${c39}         ${c31}●${c39}         ${c31}●${c39} | ${c31}●${c39}     ${c31}●${c39}            |";
	echo -e "#         | ${c31}●${c39} | | |   | ${c31}●${c39}       |       ${c31}●${c39} | | |   ${c31}●${c39} |            |";
	echo -e "#         | | | | |   | |       |       | | | | ${c31}●${c39} | |            |";
	echo -e "#---+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+------------|";
	echo -e "#   | | |           |     | | |   | | |                          |";
	echo -e "#   ${c31}●${c39} | ${c31}●${c39}           |     | ${c31}●${c39} ${c31}●${c39}   | | |                          |";
	echo -e "#     |             |     ${c31}●${c39}       | | ${c31}●${c39}       ${c37} SDR for debian${c39}    |";
	echo -e "#     ${c31}●${c39}             |             | ${c31}●${c39}         ${c37} v0.1 2020.Oct.9${c39}   |";
	echo -e "#                   ${c31}●${c39}             ${c31}●${c39}                              |";
	echo -e "#----------------------------------------------------------------+";
	echo -e "# usage  : ./sdrGr4bb3r [PathToInstall] (def. : CurrentFolder )  |";
	echo -e "# Author : Muath Abdullah                                        |";
	echo -e "#  Email : m0az@outlook.com                                      |";
	echo -e "#----------------------------------------------------------------'";
	echo -e ""
}




# -- main Part

if [ -n $1 ] && [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
	hlp;
else
	main $1
fi

