#!/bin/sh
#!/bin/sh
#!/bin/sh
#!/bin/sh

#
# CREATED BY : Nitish Kumar Mishra
# CREATED ON : 15-01-2026
#
# SCRIPT : move_svg_images.sh
#
# TYPICAL SCRIPT LOCATION : /N/Nissan/NISCornerstone/1.0.0.0/app/script/move_svg_images.sh
#
# DESCRIPTION : This script moves the downloaded svg image file to EPO.
#
# Number of Arguments : 3
#	$1  - svg_src_path        : This variable contains the path of the folder from where the contents need to be unzipped.
#   $2  - svg_trg_path 		  : This variable contains the path of the folder from where the contents need to be Placed.
#

svg_src_path=$1
svg_trg_path=$2

NOW=$(date +"%Y-%m-%d_%H-%M-%S")
log_file=/N/Nissan/NISCornerstone/log_Nissan_1/image_log/move_svg_images-$NOW.log

total_images=0
svg_count=0
svgz_count=0
both_format_count=0
total_files_received=0

echo "----------------------------------------" >> "$log_file"
echo "SVG Image Move Script Started : $(date)" >> "$log_file"
echo "Source Path : $svg_src_path" >> "$log_file"
echo "Target Path : $svg_trg_path" >> "$log_file"
echo "----------------------------------------" >> "$log_file"

# ----------------------------------------
# Count total physical files (case-insensitive)
# ----------------------------------------
svg_files=$(find "$svg_src_path" -maxdepth 1 -type f -iname "*.svg" 2>/dev/null | wc -l)
svgz_files=$(find "$svg_src_path" -maxdepth 1 -type f -iname "*.svgz" 2>/dev/null | wc -l)
total_files_received=$((svg_files + svgz_files))

# ----------------------------------------
# Get unique base names
# ----------------------------------------
bases=$(find "$svg_src_path" -maxdepth 1 -type f \( -iname "*.svg" -o -iname "*.svgz" \) \
        -exec basename {} \; | sed 's/\.[^.]*$//' | sort -u)

for base in $bases
do
    has_svg=0
    has_svgz=0

    svg_file=$(find "$svg_src_path" -maxdepth 1 -type f -iname "$base.svg" 2>/dev/null | head -n 1)
    svgz_file=$(find "$svg_src_path" -maxdepth 1 -type f -iname "$base.svgz" 2>/dev/null | head -n 1)

    if [ -n "$svg_file" ]; then
        has_svg=1
    fi

    if [ -n "$svgz_file" ]; then
        has_svgz=1
    fi

    if [ $has_svg -eq 1 ] && [ $has_svgz -eq 1 ]; then
        both_format_count=$((both_format_count + 1))
    fi

    if [ $has_svg -eq 1 ]; then
        svg_count=$((svg_count + 1))
        cp "$svg_file" "$svg_trg_path"/
        echo "Copied SVG  : $(basename "$svg_file")" >> "$log_file"
    elif [ $has_svgz -eq 1 ]; then
        svgz_count=$((svgz_count + 1))
        cp "$svgz_file" "$svg_trg_path"/
        echo "Copied SVGZ : $(basename "$svgz_file")" >> "$log_file"
    fi

    total_images=$((total_images + 1))
done

echo "----------------------------------------" >> "$log_file"
echo "Total Files Received (SVG+SVGZ) in ZIP : $total_files_received" >> "$log_file"
echo "Total Images Downloaded (SVG+SVGZ) at EPO : $total_images" >> "$log_file"
echo "Total SVG Images Downloaded  at EPO        : $svg_count" >> "$log_file"
echo "Total SVGZ Images Downloaded at EPO        : $svgz_count" >> "$log_file"
echo "Images Received in Both Format : $both_format_count" >> "$log_file"
echo "----------------------------------------" >> "$log_file"
echo "Script Completed : $(date)" >> "$log_file"
echo "----------------------------------------" >> "$log_file"

exit 0
