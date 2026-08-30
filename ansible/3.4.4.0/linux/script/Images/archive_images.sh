#!/bin/sh

# CREATED BY : Smiley Mahajan
# CREATED ON : 29-06-2018
#
# CHANGED BY : Amardeep Kaur
# CREATED ON : 18-07-2019
# COMMENTS: Removed parameter pubservr_script_path.  	
#
# CHANGED BY : Amardeep Kaur
# CREATED ON : 23-10-2019
# COMMENTS: Reduced the number of script calling arguments.
#
# CHANGED BY : Nitish K Mishra
# CREATED ON : 19-01-2026
# COMMENTS: Add SVG Image archive Processs
#
# SCRIPT : archive_images.sh
#
# TYPICAL SCRIPT LOCATION : /N/Nissan/NISCornerstone/1.0.0.2/app/script/Images/archive_images.sh
#
# DESCRIPTION : This script :
#				1. Prepares list of images to process.
#				2. Archives the images from one location to a specified location.
#
# Number of Arguments : 3
#	1  - pub_root_path     : This variable contains the pub server root path.
#	2  - epo_root_path     : This variable contains the pub server epo path.
#	3  - img_type		   : This variable contains the image type identifier.
#
#
# SCRIPT CALLING :  
# sh archive_images.sh /N/Nissan/NISCornerstone/1.0.0.2/ /N/Nissan/NISCornerstone/EPO2/ illustration
# pub_root_path='/N/Nissan/NISCornerstone/1.0.0.2/'
# epo_root_path='/N/Nissan/NISCornerstone/EPO2/'
# img_type='illustration'
#

pub_root_path=$1
epo_root_path=$2
img_type=$3

log_file_path=$pub_root_path/log/image_log/
imgsToProcess=$pub_root_path/data/depot/workarea/ImageProcess/images_to_process.txt

#---------------------------------------------
# Set source and archive folders
#---------------------------------------------
if [ "$img_type" = "illustration" ]
then
    process_from=$epo_root_path/CapturedImages/
    archive_from=$process_from
    archive_to=$pub_root_path/data/depot/archive/Images/IllustrationImages/

elif [ "$img_type" = "svg_illustration" ]
then
    process_from=$epo_root_path/SVGImages/
    archive_from=$process_from
    archive_to=$pub_root_path/data/depot/archive/Images/SVGImages/

elif [ "$img_type" = "chapter" ]
then
    process_from=$epo_root_path/Images/ChapterImages/
    archive_from=$process_from
    archive_to=$pub_root_path/data/depot/archive/Images/ChapterImages/

elif [ "$img_type" = "model" ]
then
    process_from=$epo_root_path/Images/ModelImages/
    archive_from=$process_from
    archive_to=$pub_root_path/data/depot/archive/Images/ModelImages/

elif [ "$img_type" = "pdf_gi" ]
then
    # Read filenames from CatalogPDF --Due to Report Purpose
    process_from=$epo_root_path/CatalogPdf/

    # Archive actual files from GI folder
    archive_from=$epo_root_path/Images/Attachments/GeneralInformation/

    archive_to=$pub_root_path/data/depot/archive/Images/Attachments/GeneralInformation/

elif [ "$img_type" = "pricebook" ]
then
    process_from=$epo_root_path/Images/Attachments/Pricebook/
    archive_from=$process_from
    archive_to=$pub_root_path/data/depot/archive/Images/Attachments/Pricebook/
fi

NOW=$(date +"%Y-%m-%d_%H:%M:%S")
LOG_FILE=$log_file_path/archive_images-$NOW.log

printf "Script Name Executed : archive_images.sh\n" >> "$LOG_FILE"
printf "Log File Location : $LOG_FILE\n" >> "$LOG_FILE"
printf "Arguments Received are :\n" >> "$LOG_FILE"
printf "1 - pub_root_path : $pub_root_path\n" >> "$LOG_FILE"
printf "2 - epo_root_path : $epo_root_path\n" >> "$LOG_FILE"
printf "3 - img_type      : $img_type\n" >> "$LOG_FILE"

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
    printf "Invalid arguments.\n" >> "$LOG_FILE"
    exit 1
fi

printf "\nOther variables:\n" >> "$LOG_FILE"
printf "process_from : $process_from\n" >> "$LOG_FILE"
printf "archive_from : $archive_from\n" >> "$LOG_FILE"
printf "archive_to   : $archive_to\n" >> "$LOG_FILE"

#---------------------------------------------
# Create images_to_process.txt
#---------------------------------------------
printf "\nCreating images_to_process.txt\n" >> "$LOG_FILE"

> "$imgsToProcess"

if [ -d "$process_from" ]
then
    cd "$process_from" || exit 1

    for f in *
    do
        [ -f "$f" ] && echo "$f||$img_type" >> "$imgsToProcess"
    done
fi

printf "images_to_process.txt created.\n" >> "$LOG_FILE"

#---------------------------------------------
# Archive files
#---------------------------------------------
printf "\nArchiving files from $archive_from to $archive_to\n" >> "$LOG_FILE"

find "$archive_from" -type f -exec mv -f {} "$archive_to" \;

printf "Files archived successfully.\n" >> "$LOG_FILE"

exit 0