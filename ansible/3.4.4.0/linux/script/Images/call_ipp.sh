#!/bin/sh

#
# CREATED BY : Smiley Mahajan
# CREATED ON : 23-04-2017
# CHANGED BY : Komal Gulati
# CHANGED ON : 25-04-2017
# CHANGED ON : 03-05-2017
# Changes made in the scp commands so that it work even when number of files increase. 
# Changes made to include generic scripts  like clean_folder.sh, clean_file.sh, move_folder.sh
# Changes made to change hash location. Location of Hash files for all types of images is same now.
# Passed XSLT as parameter to IPP code in order to change callout XML
# Changes made to remove thumbnail generation
# Made minor changes in Logs e.g count in CapturedTIFF folder
# The parameters thumb_width and thumb_height are no longer passed to the script.
#
# CHANGED BY : Amardeep Kaur
# CHANGED ON : 15-07-2019
# COMMENTS: Added parameters thumbnail_Width and thumbnail_Height for thumbnail generation
#
# CHANGED BY : Amardeep Kaur
# CHANGED ON : 21-10-2019
# COMMENTS	 : Modified script to 
#				1. Reduce script calling arguments.
#				2. Make script generic with minimum changes required across different OEMs.
#
#
# CHANGED BY : Nitish K Mishra
# CHANGED ON : 19-01-2026
# COMMENTS   : Modified script to
#               1.Add SVG Image Load Process 
#               2.Remove possible PII data from publishing logs
#               3.Add IPP process for model image
#
# SCRIPT : call_ipp.sh
#
# TYPICAL SCRIPT LOCATION : /N/Nissan/NISCornerstone/1.0.0.0/app/script/Images/call_ipp.sh
#
# DESCRIPTION : This script performs the Process - 2 of Image Processing which includes :
#					1. Copying the Captured images from Pub Linux to Image Server
#  					2. IPP processing and applying xslt over captured images
#					3. Generating the Image hash and Callout Hash on Image Server
#					4. Copying the processed images, Image Hash and CallOut Hash from Image Server to Pub Linux
#
#
# Number of Arguments : 11
#	1  - pub_root_path			    : This variable contains the pub server root path.
#	2  - epo_root_path				: This variable contains the pub server epo path.
#	3  - service_acc	            : This variable contains the service account name.
#	4  - img_srvr					: This variable contains the image server name.
#	5  - img_srvr_root				: This variable contains the image server root path.
#	6 - img_type                  	: This variable contains the image type identifier.
#	7 - img_output_format         	: This variable contains the format in which the output is expected.
#	8 - image_height            	: This variable contains the height of the image.	
#	9 - image_width			  		: This variable contains the width of the image.	
#	10 - thumbnail_Height		  	: This variable contains the height of the thumbnail.	
#	11 - thumbnail_Width         	: This variable contains the width of the thumbnail.	
#
# NOTE: If no thumbnail generation is required along with illustration processing, remove the Image Processor thumbnail generation API from execute_ipp.py script.
#
# PROCESS 1 SCRIPT CALLING :  
# sh call_ipp.sh /N/Nissan/NISCornerstone/1.0.0.0/ /N/Nissan/NISCornerstone/EPO/ pacepc_dev_1 rich-imag-01-rv /EPC-IMAGE-NGDEV1/nis/1.0.0.0/IPP_Processing/ illustration png 3508 2496 215 245
#   pub_root_path='/N/Nissan/NISCornerstone/1.0.0.0/'
#   epo_root_path='/N/Nissan/NISCornerstone/EPO/'
#	service_acc='pacepc_dev_1'
#	img_srvr='rich-imag-27-rv'
#	img_srvr_root='/EPC-IMAGE-NGDEV/nis/1.0.0.0/IPP_Processing/'
#	img_type='illustration'
#	img_output_format='png'
#	image_height=3508
#	image_width=2496
#	thumbnail_Height=215
#	thumbnail_Width=245
#

pub_root_path=$1
epo_root_path=$2
service_acc=$3
img_srvr=$4
img_srvr_root=$5
img_type=$6
img_output_format=$7
image_height=$8
image_width=$9
thumbnail_Height=${10}
thumbnail_Width=${11}

log_file_path=$pub_root_path/log/image_log/	
pubsrvr_script_path=$pub_root_path/app/script/Images/
imgsrvr_script_path=$img_srvr_root/Script/
imgsrvr_input_images=$img_srvr_root/InputImages/
imgsrvr_output_images=$img_srvr_root/OutputImages/
imgsrvr_error_log=$img_srvr_root/Error/
imgsrvr_base_path=`dirname $imgsrvr_input_images`
imgservr_input_folder=`basename $imgsrvr_input_images`
imgservr_output_folder=`basename $imgsrvr_output_images`
csv_path=$pub_root_path/data/depot/workarea/ImageProcess/
xslt_path=$imgsrvr_script_path'nissancalloutprocessor.xsl'


#Setting image input and output folders as per image type
if ([ $img_type == "illustration" ])
then 
	pubserver_input=$epo_root_path/CapturedImages/
	pubsrvr_output_images=$pub_root_path/data/depot/workarea/ImageProcess/IllustrationImages/OutputImages/
elif ([	$img_type == "svg_illustration" ])
then 
	pubserver_input=$epo_root_path/SVGImages/
	pubsrvr_output_images=$pub_root_path/data/depot/workarea/ImageProcess/IllustrationImages/OutputImages/
elif ([ $img_type == "chapter" ])
then
	pubserver_input=$epo_root_path/Images/ChapterImages/
	pubsrvr_output_images=$pub_root_path/data/depot/workarea/ImageProcess/ChapterImages/OutputImages/
elif ([ $img_type == "model" ])
then
	pubserver_input=$epo_root_path/Images/ModelImages/
	pubsrvr_output_images=$pub_root_path/data/depot/workarea/ImageProcess/ModelImages/OutputImages/
elif ([ $img_type == "pdf_gi" ])
then
	pubserver_input=$epo_root_path/Images/Attachments/GeneralInformation/
	pubsrvr_output_images=$pub_root_path/data/depot/workarea/ImageProcess/Attachments/OutputImages/
elif ([ $img_type == "pricebook" ])
then
	pubserver_input=$epo_root_path/Images/Attachments/Pricebook/
	pubsrvr_output_images=$pub_root_path/data/depot/workarea/ImageProcess/Attachments/OutputImages/
fi

pubserver_input_folder=`basename $pubserver_input`
pubservr_base_path=`dirname $pubsrvr_output_images`
pubserver_output_folder=`basename $pubsrvr_output_images`


NOW=$(date +"%Y-%m-%d_%H:%M:%S")
LOG_FILE=$log_file_path'call_ipp_p2-'$NOW'.log'

printf "Script Name Executed : call_ipp.sh\n" >> ${LOG_FILE}
printf "Log File Location : $LOG_FILE\n" >> ${LOG_FILE}
printf "Arguments Recieved are :\n" >> ${LOG_FILE}
printf "1	- pub_root_path 	: $pub_root_path\n" >> ${LOG_FILE}
printf "2	- epo_root_path		: $epo_root_path\n" >> ${LOG_FILE}
#printf "3	- service_acc		: $service_acc\n" >> ${LOG_FILE}
#printf "4	- img_srvr			: $img_srvr\n" >> ${LOG_FILE}
printf "5	- img_srvr_root		: $img_srvr_root\n" >> ${LOG_FILE}
printf "6	- img_type			: $img_type\n" >> ${LOG_FILE}
printf "7	- img_output_format : $img_output_format\n" >> ${LOG_FILE}
printf "8	- image_height		: $image_height\n" >> ${LOG_FILE}
printf "9	- image_width		: $image_width\n" >> ${LOG_FILE}
printf "10	- thumbnail_height	: $thumbnail_Height\n" >> ${LOG_FILE}
printf "11	- thumbnail_width	: $thumbnail_Width\n" >> ${LOG_FILE}

printf "\n" >> ${LOG_FILE}
date '+DATE: %m/%d/%y	TIME:%H:%M:%S''..........INFO: call_ipp.sh Execution Started.' >> ${LOG_FILE}
printf "\n" >> ${LOG_FILE}


#Checking if all the required parameters are recieved.
if [ -z "$1" ] | [ -z "$2" ] | [ -z "$3" ] | [ -z "$4" ] | [ -z "$5" ] | [ -z "$6" ] | [ -z "$7" ] | [ -z "$8" ] | [ -z "$9" ] | [ -z "${10}" ] | [ -z "${11}" ]
then
    printf "Arguments are not appropriate.
	call_ipp.sh takes 11 arguments :	
	1  - pub_root_path		: This variable contains the pub server root path.
	2  - epo_root_path		: This variable contains the pub server epo path.
	3  - service_acc	    : This variable contains the service account name.
	4  - img_srvr			: This variable contains the image server name.
	5  - img_srvr_root		: This variable contains the image server root path.
	6 - img_type            : This variable contains the image type identifier.
	7 - img_output_format   : This variable contains the format in which the output is expected.
	8 - image_height        : This variable contains the height of the image.	
	9 - image_width			: This variable contains the width of the image.	
	10 - thumbnail_Height	: This variable contains the height of the thumbnail.	
	11 - thumbnail_Width    : This variable contains the width of the thumbnail.	
	\n">> ${LOG_FILE}
	exit 1
fi

printf "Other script variables :\n" >> ${LOG_FILE}
printf "1	- log_file_path				: $log_file_path\n" >> ${LOG_FILE}
printf "2	- pubsrvr_script_path		: $pubsrvr_script_path\n" >> ${LOG_FILE}
printf "3	- imgsrvr_script_path		: $imgsrvr_script_path\n" >> ${LOG_FILE}
printf "4	- imgsrvr_input_images		: $imgsrvr_input_images\n" >> ${LOG_FILE}
printf "5	- imgsrvr_output_images		: $imgsrvr_output_images\n" >> ${LOG_FILE}
printf "6	- imgsrvr_error_log			: $imgsrvr_error_log\n" >> ${LOG_FILE}
printf "7	- imgsrvr_base_path			: $imgsrvr_base_path\n" >> ${LOG_FILE}
printf "8	- imgservr_input_folder		: $imgservr_input_folder\n" >> ${LOG_FILE}
printf "9	- imgservr_output_folder	: $imgservr_output_folder\n" >> ${LOG_FILE}
printf "10	- csv_path					: $csv_path\n" >> ${LOG_FILE}
printf "11	- xslt_path					: $xslt_path\n" >> ${LOG_FILE}
printf "12	- pubserver_input			: $pubserver_input\n" >> ${LOG_FILE}
printf "13	- pubsrvr_output_images		: $pubsrvr_output_images\n" >> ${LOG_FILE}
printf "14	- pubserver_input_folder	: $pubserver_input_folder\n" >> ${LOG_FILE}
printf "15	- pubservr_base_path		: $pubservr_base_path\n" >> ${LOG_FILE}
printf "16	- pubserver_output_folder	: $pubserver_output_folder\n" >> ${LOG_FILE}


printf "\nNumber of files in $pubserver_input : " >> ${LOG_FILE}
find $pubserver_input -type f | wc -l >> ${LOG_FILE}

#/usr/bin/ssh $service_acc@$img_srvr sh $imgsrvr_script_path'clean_file.sh' $imgsrvr_script_path
scp -rp $pubsrvr_script_path* $imgsrvr_script_path
printf "\nScripts copied to image server successfully.\n" >> ${LOG_FILE}

sh $imgsrvr_script_path'clean_folder.sh' $imgsrvr_base_path $imgservr_input_folder
printf "\n$imgsrvr_input_images folder cleaned up successfully. \n" >> ${LOG_FILE}

scp -rp $pubserver_input $imgsrvr_base_path
sh $imgsrvr_script_path'move_folder.sh' $imgsrvr_base_path/$pubserver_input_folder $imgsrvr_input_images
printf "\nNumber of files copied in $imgsrvr_input_images : " >> ${LOG_FILE}
find $imgsrvr_input_images -type f | wc -l >> ${LOG_FILE}

if ([ $img_type == "illustration" ] || [ $img_type == "chapter" ])
then
	sh $imgsrvr_script_path'clean_file.sh' $imgsrvr_output_images
	printf "\n$imgsrvr_output_images folder cleaned up successfully. \n" >> ${LOG_FILE}
	
	sh $imgsrvr_script_path'clean_file.sh' $imgsrvr_error_log
	printf "\n$imgsrvr_error_log folder cleaned up successfully. \n" >> ${LOG_FILE}

	printf "\nIPP Call Initiated for image type $img_type.\n" >> ${LOG_FILE}
	ssh $service_acc@$img_srvr /opt/cornerstone/links/python/publishing_component_python_link $imgsrvr_script_path'execute_ipp.py' $img_output_format $imgsrvr_input_images $imgsrvr_output_images $imgsrvr_error_log'execute_ipp_p2_'$NOW'.log' $img_type $image_height $image_width $thumbnail_Height $thumbnail_Width $xslt_path
	printf "\nIPP Call Completed.\n" >> ${LOG_FILE}

	printf "\nNumber of files generated in $imgsrvr_output_images after IPP call : " >> ${LOG_FILE}
	find $imgsrvr_output_images -type f | wc -l >> ${LOG_FILE}

elif ([ $img_type == "model" ])
then 
	sh $imgsrvr_script_path'clean_file.sh' $imgsrvr_output_images
	printf "\n$imgsrvr_output_images folder cleaned up successfully. \n" >> ${LOG_FILE}
	
	sh $imgsrvr_script_path'clean_file.sh' $imgsrvr_error_log
	printf "\n$imgsrvr_error_log folder cleaned up successfully. \n" >> ${LOG_FILE}

	printf "\nIPP Call Initiated for image type $img_type.\n" >> ${LOG_FILE}
	ssh $service_acc@$img_srvr /opt/cornerstone/links/python/publishing_component_python_link $imgsrvr_script_path'execute_ipp.py' $img_output_format $imgsrvr_input_images $imgsrvr_output_images $imgsrvr_error_log'execute_ipp_p2_'$NOW'.log' $img_type $image_height $image_width $thumbnail_Height $thumbnail_Width $xslt_path
	printf "\nIPP Call Completed.\n" >> ${LOG_FILE}

	printf "\nNumber of files generated in $imgsrvr_output_images after IPP call : " >> ${LOG_FILE}
	find $imgsrvr_output_images -type f | wc -l >> ${LOG_FILE}
	
elif ([ $img_type == "pdf_gi" ] || [ $img_type == "pricebook" ])
then
	sh $imgsrvr_script_path'clean_folder.sh' $imgsrvr_base_path $imgservr_output_folder
	printf "\n$imgsrvr_output_images folder cleaned up successfully. \n" >> ${LOG_FILE}
	
	scp -rp $pubserver_input $imgsrvr_base_path
	sh $imgsrvr_script_path'move_folder.sh' $imgsrvr_base_path/$pubserver_input_folder $imgsrvr_output_images
	printf "\nNumber of files copied in $imgsrvr_output_images : " >> ${LOG_FILE}
	find $imgsrvr_output_images -type f | wc -l >> ${LOG_FILE}
elif ([ $img_type == "svg_illustration" ])
then
	sh $imgsrvr_script_path'clean_file.sh' $imgsrvr_output_images
	printf "\n$imgsrvr_output_images folder cleaned up successfully. \n" >> ${LOG_FILE}
	
	sh $imgsrvr_script_path'clean_file.sh' $imgsrvr_error_log
	printf "\n$imgsrvr_error_log folder cleaned up successfully. \n" >> ${LOG_FILE}

	printf "\nIPP Call Initiated for image type $img_type.\n" >> ${LOG_FILE}
	ssh $service_acc@$img_srvr /opt/cornerstone/links/python/publishing_component_python_link $imgsrvr_script_path'Nissan_ipp_svg.py' -o $imgsrvr_output_images $imgsrvr_input_images	
	printf "\nIPP Call Completed.\n" >> ${LOG_FILE}

	printf "\nNumber of files generated in $imgsrvr_output_images after IPP call : " >> ${LOG_FILE}
	find $imgsrvr_output_images -type f | wc -l >> ${LOG_FILE}
fi


printf "\nload_png_images.csv creation started.\n" >> ${LOG_FILE}
printf "Variable1  - pubsrvr_output_images : $pubsrvr_output_images\n" >> ${LOG_FILE}
printf "Variable2  - imgsrvr_output_images : $imgsrvr_output_images\n" >> ${LOG_FILE}
printf "Variable3  - img_type : $img_type\n" >> ${LOG_FILE}
printf "Variable4  - img_output_format : $img_output_format\n" >> ${LOG_FILE}
printf "Variable5  - imgsrvr_base_path : $imgsrvr_base_path\n" >> ${LOG_FILE}
ssh $service_acc@$img_srvr /opt/cornerstone/links/python/publishing_component_python_link $imgsrvr_script_path'create_image_csv.py' $pubsrvr_output_images $imgsrvr_output_images $img_type $img_output_format $imgsrvr_base_path'/load_png_images.csv'
printf "\nload_png_images.csv creation completed.\n" >> ${LOG_FILE}	 


sh $pubsrvr_script_path'clean_folder.sh' $pubservr_base_path $pubserver_output_folder
printf "\n$pubsrvr_output_images folder cleaned up successfully. \n" >> ${LOG_FILE}

scp -rp $imgsrvr_output_images $pubservr_base_path
printf "\nNumber of files copied in $pubsrvr_output_images : " >> ${LOG_FILE}
find $pubsrvr_output_images -type f | wc -l >> ${LOG_FILE}

scp -rp $imgsrvr_base_path/*.csv $csv_path
printf "\nNumber of CSV files copied to $csv_path : " >> ${LOG_FILE}
find $csv_path/*csv -type f | wc -l >> ${LOG_FILE}

scp -rp $imgsrvr_error_log/*.log $log_file_path
printf "\nLog files of Image Server copied to $log_file_path : " >> ${LOG_FILE}


printf "\n" >> ${LOG_FILE}
date '+DATE: %m/%d/%y	TIME:%H:%M:%S''..........INFO: call_ipp.sh Execution Ended.' >> ${LOG_FILE}
printf "\n" >> ${LOG_FILE}



