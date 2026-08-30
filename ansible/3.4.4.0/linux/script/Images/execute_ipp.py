#
# CREATED BY : Smiley Mahajan
# CREATED ON : 23-04-2017
#
# CHANGED BY : Amardeep Kaur
# CHANGED ON : 22-10-2019
# COMMENTS: Modified script as per Nissan requirements
# Added thumbnail generation steps for illustration images
#
#CHANGED BY : Nitish K Mishra
# CHANGED ON : 22-10-2019
# COMMENTS: Remove Unused python Library
#
# SCRIPT : execute_ipp.py
# TYPICAL SCRIPT LOCATION : /N/Nissan/NISCornerstone/1.0.0.0/app/script/Images/execute_ipp.py
# PURPOSE : Build the thumbnail and the file format png from the the original image file.
#
# PROCESS 2 SCRIPT CALLING :  
# python execute_ipp.py png /E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/InputImages/ /E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/OutputImages/ /E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/Error/execute_ipp_p2.log illustration 3508 2496 215 245 /E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/Script/nissancalloutprocessor.xsl
#	img_format="png"
#	img_inputpath="/E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/InputImages/"
#	img_outputpath="/E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/OutputImages/"
#	error_file="/E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/Error/execute_ipp_p2.log"
#	image_process="illustration"
#	image_height=3508
#	image_width=2496
#	thumbnail_Height=215
#	thumbnail_Width=245
#   stylesheetImageData=/E/Nissan/NISCornerstone/1.0.0.2/data/ImageProcess/Script/nissancalloutprocessor.xsl

import sys
import logging
from sbs.imageconversion.imageprocessor import ImageProcessor
from sbs.imageutilities.imageinfo import ImageInfo
from sbs.threadsupport import ThreadPool

def main():
	#global img_err 
	
	img_format=sys.argv[1]
	img_inputpath=sys.argv[2]
	img_outputpath=sys.argv[3]
	error_file=sys.argv[4]
	image_process=sys.argv[5]
	img_height=sys.argv[6]
	img_width=sys.argv[7]
	thumbnail_Height=sys.argv[8]
	thumbnail_Width=sys.argv[9] 
	logging.basicConfig(level = logging.INFO, filename = error_file, filemode = "w")
	logging.info( "**************** Execution Start - execute_ipp.py ****************\n" )
	logging.info( "Arguments Recieved are : " )
	logging.info( " 1 - img_format : %s", img_format )
	logging.info( " 2 - img_inputpath : %s", img_inputpath )
	logging.info( " 3 - img_outputpath : %s", img_outputpath )
	logging.info( " 4 - error_file: %s \n", error_file )
	logging.info( " 5 - image_process: %s \n", image_process )
	logging.info( " 6 - img_height: %s \n", img_height )
	logging.info( " 7 - img_width: %s \n", img_width )
	logging.info( " 8 - thumbnail_Height: %s \n", thumbnail_Height )
	logging.info( " 9 - thumbnail_Width: %s \n", thumbnail_Width )
	
	#img_err=open(error_file,"w")
	try:
		print ('...1')
		img_process=ImageProcessor (img_outputpath,16)
		
		
		print ('...2')
		#Setting Image Attributes   
		if image_process == "illustration": 
			logging.info('Setting Image Attributes for img_format %s.\n', image_process) 
			stylesheetImageData=sys.argv[10]
			#For PNG and XML Image Process
			img_process.format=img_format
			img_process.imageDataStylesheet = stylesheetImageData
			img_process.extractCallouts=False
			img_process.calloutShape = "roundedRectangle"
			img_process.optimize=True
			img_process.align = True
			img_process.trim = False
			img_process.maxHeight=img_height
			img_process.maxWidth=img_width
			img_process.thumbnail = True
			img_process.thumbnailHeight = thumbnail_Height
			img_process.thumbnailWidth = thumbnail_Width
			#img_process.depthGray = 4
		elif image_process == "chapter":
			logging.info('Setting Image Attributes for img_format %s.\n', image_process) 
			img_process.format=img_format
			img_process.thumbnail=True
			img_process.thumbnailWidth=thumbnail_Width
			img_process.thumbnailHeight=thumbnail_Height
			img_process.thumbnailOnly=True
			img_process.jpegThumbnails=True
		elif image_process == "model":
			logging.info('Setting Image Attributes for image_type %s.\n', image_process)
			img_process.format=img_format
			img_process.thumbnail=True
			img_process.thumbnailWidth=thumbnail_Width
			img_process.thumbnailHeight=thumbnail_Height
			img_process.thumbnailOnly=True
			img_process.noThumbNormalize = True
			img_process.trim= True
			img_process.addBorder=True
		print ('...3')
		img_process.initialize()
		
		print ('...4')
		img_process.processDirectory(img_inputpath)
		
		print ('...5')
		logging.info( "**************** Execution Ended - execute_ipp.py ****************\n" )
	
	except Exception as e:
		print ('...4sss')
		logging.info ("Exception in main: %s \n", e) 
		logging.info( "**************** Execution Ended - execute_ipp.py ****************\n" )   
		#img_err.write(datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f: ") + e.message + ': error in generation' + '\n')
		#img_err.flush()
		raise
	finally:
		#img_err.close()
		del img_process
	

if __name__=='__main__':
	main()