#!/usr/bin/sh
v=video
a=audio
p=playlist
c=channel
f=urls.txt
fco=$(wc -l < urls.txt)


# first if loop to check if urls.txt already exists, for other than youtube.
# contains 1 if loop and 1 case statement.
if [[ -f "$1" ]]; 
	then
	echo "Using $1"
	echo "1.) $v"
	echo "2.) $a"
	echo "3.) exit"
	read format
		case $format in
		1) 
		echo "Using $1"
		echo "$fco videos will be download"
		<$1 xargs -I{} -P30 bash -c 'yt-dlp -k "{}" --external-downloader aria2c'
		;;
		
		2)	
		echo "Using $1"
		echo "$fco audios will be download"
		<$1 xargs -I{} -P30 bash -c 'yt-dlp -x --audio-format mp3 "{}" --external-downloader aria2c'
		;;
		
		3)
		echo "Aborted"
		exit
		;;

		*)
		echo "Nothing choosen, script ended."
		;;
		esac
		exit
fi
# first loop and case ended

if [[ -f "$f" ]]; 					
	then
	echo "##########################################################################"
	echo "urls.txt already exists"
	awk -F, '{print $0} NR==6{exit}' OFS=', ' $f
	echo "##########################################################################"
	echo "!!!! Do you want to overwrite urls.txt it? !!!!"
	echo "1.) no" 
	echo "2.) yes"
	read overwrite

	case $overwrite in
	1) 
	echo "Aborted because urls.txt already exists"
	exit
	;;
	
	2)
	# this will make the script to not exit but go to next commands.
	;;
	
	*)
	echo "Aborted because urls.txt already exists"
	exit
	;;
esac
fi
# second if loop and case ended here.
# case for asking what method to download

echo "Paste url"

read urls
yt-dlp --flat-playlist --print url --print title $urls > $f
head urls.txt
sed -i '0~2d' $f 
numbers=$(awk 'END { print NR }' urls.txt )
echo "Found $numbers files"
	echo "1.) $v"
	echo "2.) $a"
	echo "3.) exit"
	read format
		case $format in
		1) 
		echo "$numbers videos will be download"
		<urls.txt xargs -I{} -P30 bash -c 'yt-dlp "{}"'
		;;
		
		2)	
		echo "$numbers audios will be download"
		<urls.txt xargs -I{} -P30 bash -c 'yt-dlp -x --audio-format mp3 "{}"'
		;;
		
		3)
		echo "Aborted"
		exit
		;;

		*)
		echo "Nothing choosen, script ended."
		;;
		esac
		exit



































