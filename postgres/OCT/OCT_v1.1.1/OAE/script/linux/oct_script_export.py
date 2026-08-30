import os
import csv
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
import fnmatch
import socket
import logging
import sys
from datetime import datetime
import hashlib

#
# CREATED BY : Bipin Kumar
# CREATED ON : 01-Jun-20124
#
# Modified by :	Richa Thakur
# Modified on :	26-Jul-2024
#
# TYPICAL SCRIPT LOCATION : /F/Ford/FRDCornerstone/1.0.0.0/app/script/OCT/oct_script_export.py
#
# DESCRIPTION : This script will export the list of Directorys and files with their content in a csv and send them on to emails based on input parameters.
# Change Desc : i) Added the check for directories and files permissions
#               ii) Created hash for Jar and python class fille
#               iii) Support for Excluded the multiple file pattern
#               iv) Support to compare file hash if context is not being loaded in csv 
#               v) Changed the variable and made it case insensitive  
#  Ref#   NAME              DATE         Comment                        
#  1     Richa Thakur      18-08-2025   FDNGPUB-2559 : Remove use of python current version in the script

input_directory= sys.argv[1]
csv_file_path= sys.argv[2]
sender_email=sys.argv[3]
recipient_email=sys.argv[4]
exclude_subdirs=sys.argv[5]
exclude_file_list=sys.argv[6]
exclude_file_pattern=sys.argv[7]
db_name=sys.argv[8]
hash_comparable_file_pattern_list=sys.argv[9]

current_date= datetime.now().strftime("%Y%m%d")

identification = (socket.gethostname().split('.')[0].replace('-','_') +'_'+ input_directory.split('/')[4])

file_name= db_name.lower() + '_' + identification.replace('rich_','') + '_oct_script_export_'+current_date+'.csv'

logging.basicConfig(level=logging.INFO)

# Function to generate SHA-256 hash of a string
def generate_hash(value):
    hash_object = hashlib.sha256(value.encode())
    hex_dig = hash_object.hexdigest()
    return hex_dig
    
def traverse_and_collect(directory, exclude_subdirs, exclude_file_list,exclude_file_pattern,hash_comparable_file_pattern_list):
    exclude_subdirs_list = [subdir.strip().casefold() for subdir in exclude_subdirs.split(',')]
    exclude_file_list = [filenm.strip().casefold() for filenm in exclude_file_list.split(',')]
    exclude_file_list.append(file_name) # Exclude oct_script_contents
    #exclude_file_pattern_list = [subdir.strip() for filepanm in exclude_file_pattern.split(',')]
    exclude_file_patterns = [pattern.strip().casefold() for pattern in exclude_file_pattern.split(',')]
    hash_comparable_file_patterns = [pattern.strip().casefold() for pattern in hash_comparable_file_pattern_list.split(',')]    
     
    
    file_info = []

    # Add Host name
    file_info.append({
                'schema_name': 'PBA SERVER',
                'object_type': 'IDENTIFICATION',
                'object_name': 'HOST NAME',  
                'definition':  identification.encode('utf-8').hex()
            })
    logging.info(f"Host name Added {identification}")

    # Add File name
    file_info.append({
                'schema_name': 'PBA SERVER',
                'object_type': 'IDENTIFICATION',
                'object_name': 'FILE NAME',  
                'definition':  file_name.encode('utf-8').hex()
            })
    logging.info(f"File name Added {file_name}")
    
    for root, dirs, files in os.walk(directory):
        # Convert root to lower case for comparison
        root_casefold = root.casefold()
        
        # List of Directories  After excluding list of sub directories
        dirs[:] = [dir_name for dir_name in dirs if dir_name.casefold() not in exclude_subdirs_list]
        logging.info(f"Excluding Sub Directory : {exclude_subdirs_list} ")
        logging.info(f"Directories  After excluding Sub directories : {dirs}")

        
        if not any(exclude_subdir in root_casefold for exclude_subdir in exclude_subdirs_list):
            dir_stat = os.stat(root)
            mode = dir_stat.st_mode
            permissions = 'PERMISSION: ' + oct(mode)[-3:] + '\n'  # Get octal representation of permissions
            
        # Add directory entry
        file_info.append({
            'schema_name': 'PBA SERVER',
            'object_type': 'Directory',
            'object_name':  root,  # Enclose in double quotes
            'definition': (permissions+'DIR').encode('utf-8').hex()
        })
        logging.info(f"Added directory {root} {permissions}")
        
        for file in files:
            # Excelude give list of file
            if file.casefold() in exclude_file_list:
                logging.info(f"Skipping file:  {file}")
                continue
                
            # Excelude the file matching with given pattern
            if any(fnmatch.fnmatch(file.casefold(), f'*{pattern}*') for pattern in exclude_file_patterns):                
                logging.info(f"Skipping file {file} matching pattern {exclude_file_patterns}")
                continue
                
            # Excelude the hidden files
            if file.startswith('.'):
                logging.info(f"Skipping hidden files: {file} starting with '.'")
                continue
                
            file_path = os.path.join(root, file)
            file_stat = os.stat(file_path)
            mode = file_stat.st_mode
            permissions = 'PERMISSION: '+oct(mode)[-3:]+'\n'  # Get octal representation of permissions
            logging.info(f"Collected content from {file_path} {permissions}")
           
            try:
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    if any(fnmatch.fnmatch(file.casefold(), f'*{pattern}*') for pattern in hash_comparable_file_patterns):
                        file_info.append({
                            'schema_name': 'PBA SERVER',
                            'object_type': 'Script',
                            'object_name': file_path,
                            # 'definition': content # Encode to hash
                            'definition': (permissions+generate_hash(content.replace('\\','\\\\'))).encode('utf-8').hex() # Encode to hash
                            }) 
                        logging.info(f"Files for which hash value will be compared {file} ")        
                            
                    else:
                        file_info.append({
                            'schema_name': 'PBA SERVER',
                            'object_type': 'Script',
                            'object_name': file_path,
                            # 'definition': content # Encode to hexadecimal
                            'definition': (permissions+content.replace('\\','\\\\')).encode('utf-8').hex() # Encode to hexadecimal
                })
                logging.info(f"Collected content from {file_path}")
                f.close()
            except Exception as e:
                logging.error(f"Could not read file {file_path}: {e}")

    return file_info
    
def write_to_csv(file_info, csv_file_path):
    try:
        with open(csv_file_path, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['schema_name', 'object_type', 'object_name', 'definition']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            #writer.writeheader()
            for info in file_info:
                writer.writerow(info)
            logging.info(f"CSV file written to {csv_file_path}")
    except Exception as e:
        logging.error(f"Failed to write CSV file {csv_file_path}: {e}")

#Send the email
def send_mail(csv_file_path,subject, sender_email,recipient_email):
    
    # Create a multipart message
    msg = MIMEMultipart()
    body_part = MIMEText("Hi,\n\nPlease find the attached script csv file from " + identification+".\n\nThanks&Regards\nOCT Team", 'plain')
    msg['Subject'] = subject
    
    email_list= [item.strip() for item in recipient_email.split(',')]
    
    msg['From'] = sender_email
    msg['To'] = ', '.join(email_list)
    # Add body to email
    msg.attach(body_part)

    # Attach the file with filename to the email
    try:
        with open(csv_file_path, 'rb') as file:
            part = MIMEApplication(file.read(), Name=os.path.basename(csv_file_path))
            part['Content-Disposition'] = f'attachment; filename="{os.path.basename(csv_file_path)}"'
            msg.attach(part)
        logging.info(f"Attached file {csv_file_path}")
    except Exception as e:
        logging.error(f"Failed to attach file {csv_file_path}: {e}")
        raise RuntimeError(f"Failed to attach file {csv_file_path}: {e}")
        return

    # Create SMTP object
    try:
        smtp_obj = smtplib.SMTP('smtp.snapbs.com', 25)
        smtp_obj.sendmail(msg['From'],email_list, msg.as_string())
        logging.info(f"Email sent to {email_list}")
        # Disconnect to server
        smtp_obj.quit()        
    except Exception as e:
        logging.error(f"Failed to send email: {e}")
        raise RuntimeError(f"Failed to send email: {e}")
        
    # Delete the file after sending the email
    try:
        os.remove(csv_file_path)
        logging.info(f"Deleted file {csv_file_path}")
    except Exception as e:
        logging.error(f"Failed to delete file {csv_file_path}: {e}")
        raise RuntimeError(f"Failed to delete file {csv_file_path}: {e}")

if __name__ == "__main__":

    file_info = traverse_and_collect(input_directory,exclude_subdirs,exclude_file_list,exclude_file_pattern,hash_comparable_file_pattern_list) 
    
    output_csv_file = os.path.join(csv_file_path, file_name)
    
    write_to_csv(file_info, output_csv_file)
    
    subject = "OCT: "+db_name+" - Directory and File Contents from "+ identification 
    send_mail(output_csv_file, subject, sender_email, recipient_email)   
    