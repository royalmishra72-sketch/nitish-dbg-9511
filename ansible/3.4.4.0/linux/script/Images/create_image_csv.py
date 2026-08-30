#
# CREATED BY : Amardeep Kaur
# CREATED ON : 10-03-2023
#
# CHANGED BY : Nitish K Mishra
# CHANGED ON : 20-06-2024
#			CHANGE: Added thread-locking on output. Removed some unused imports.
#                 : Added pillow module instead imghdr to validate image file .
# CHANGED ON : 20-06-2024               
#                 : Added SVG Image type 
#
# SCRIPT : create_image_csv.py
#
# TYPICAL SCRIPT LOCATION : /N/Nissan/NISCornerstone/1.0.0.0/app/script/Images/create_image_csv.py
#
# DESCRIPTION : This script will create image load information based on their image types.

import os
import sys
import threading
from PIL import Image, UnidentifiedImageError
from sbs.imageutilities.imageinfo import IDGenerator
from sbs.threadsupport import ThreadPool

pubservrOutputPath = sys.argv[1]
sourceFilePath = sys.argv[2]
imageType = sys.argv[3]
imageFormat = sys.argv[4]
outputFileName = sys.argv[5]

outputImageCsv = None
threadCount = 8

try:
	outputImageCsv = open(outputFileName, 'w')
except:
	print('The output file could not be created.')
	sys.exit()

idGenerator = IDGenerator()
output_lock = threading.Lock()

def isImage(filename):
    try:
        with Image.open(filename) as img:
            return True
    except UnidentifiedImageError:
        return False
    except FileNotFoundError:
        return False

def processFile(filename):
	if isImage(filename):
		imageFile, imageHash = idGenerator.processImage(filename)
		imgName = os.path.splitext(imageFile)[0]
		# Append callout information if callout is available
		if imageType == "illustration" or imageType == "svg_illustration":
			calloutFileName = (os.path.splitext(filename)[0])+'.xml'
			calloutFileBaseName = os.path.basename(calloutFileName)
			for root, dirs, files in os.walk(sourceFilePath):
				if calloutFileBaseName in files:
					calloutFile, calloutHash = idGenerator.processFile(calloutFileName)
					with output_lock:
						outputImageCsv.write(imgName + ',' + imageHash + ',' + pubservrOutputPath+imageFile + ',' + calloutHash + ',' + pubservrOutputPath+calloutFile + ',' + imageType + ',' + imageFormat + '\n')
				else:
					with output_lock:
						outputImageCsv.write(imgName + ',' + imageHash + ',' + pubservrOutputPath+imageFile + ',,,' + imageType + ',' + imageFormat + '\n')
		elif imageType == "chapter" or imageType == "model":
			with output_lock:
				outputImageCsv.write(imgName + ',' + imageHash + ',' + pubservrOutputPath+imageFile + ',,,' + imageType + ',' + imageFormat + '\n')
	else:
		if imageType == "pdf_gi" or imageType == "pricebook":
			theFile, theHash = idGenerator.processFile(filename)
			with output_lock:
				outputImageCsv.write(theFile + ',' +theHash + ',' + pubservrOutputPath+theFile + ',,,' + imageType + ',' + imageFormat + '\n')

pool = ThreadPool(threadCount)

for aFile in [filter for filter in os.listdir(sourceFilePath) if not filter=='hash.csv']: 
	pool.add_task(processFile, os.path.join(sourceFilePath, aFile))

pool.wait_completion()
outputImageCsv.close()
