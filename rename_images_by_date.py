#!/usr/bin/python

import os
import argparse
import sys, getopt
import string, datetime
#import collections

from PIL import Image

def get_date_taken(path):
	#get exif info
    info = Image.open(path)._getexif()
    if info:
        for tag, value in info.items():
            if tag == 36867: #if DateTimeOriginal(36867) tag found returns the corresponding value
                return value
    else:
        print("No metadata available for " + path)

def get_cam_model(path):
	#get exif info
	info = Image.open(path)._getexif()
	if info:
		for tag, value in info.items():
			if tag == 272: #if Model(272) tag found returns the corresponding value
				return value.replace("\x00","")
				
				
def findDuplicates(file_dict):
	final_list = []
	duplicates = 0
	for old_name,new_name in file_dict.items():
		if new_name not in final_list:
			final_list.append(new_name)
		else:
			k=1
			while new_name in final_list:
				new_name = new_name.replace(".","("+str(k)+").")
				k += 1
	
			file_dict[old_name] = new_name
			final_list.append(new_name)
			duplicates += 1
			
	return (duplicates, file_dict)

# Create the argument parser, that will display "rename" as program name in output
my_parser = argparse.ArgumentParser(prog="rename", description='Rename file following given pattern.')

# Add the arguments to parse in the CLI
#TODO make real alternative option if necessary
my_parser.add_argument('Dir',
                       metavar='pathTargetDirectory',
                       type=str,
                       help='Idk. Surely target folder to rename pics')
                     
my_parser.add_argument('--undated',
                        action='store_true',
                        help='If specified, pictures do not need date for renaming')
my_parser.add_argument('--cam','-c',
                       metavar='cameraName',
                       type=str,
                       help='Idk. Maybe the camera name to use for a renaming')
my_parser.add_argument('--time','-t',
                       metavar='timeDelay',
                       type=str,
                       help='Idk. Something about time')
my_parser.add_argument('--suffix', '-s',
                      metavar='suffix',
                      type=str,
                      default="",
                      help='Specify suffix for new renaming')
my_parser.add_argument('--prefix', '-p',
                      metavar='prefix',
                      type=str,
                      default="",
                      help='Specify prefix for new renaming')                       
my_parser.add_argument('--verbose', '-v',
                        action='store_true',
                        help='If specified, plenty of printings')
# Execute the parse_args() method
args = my_parser.parse_args()
                       
number=1
cam_name = args.cam
time = args.time
time_delay = datetime.timedelta()
useDate = not args.undated
suffix = args.suffix
prefix = args.prefix
isVerbose = args.verbose

if isVerbose:
    print("Dated value: " + str(useDate))

if time is not None: 
   time_split = time.split(":") #Possible to split on String?
   print("delay split: {}".format(time_split))
   time_delay = datetime.timedelta(hours=int(time_split[0]),minutes=int(time_split[1]),seconds=int(time_split[2]))
   print("time: " + str(time_delay))
if cam_name is not None:
   print("camera name: " + cam_name)
dir = args.Dir #sys.argv[-1]
print("target directory: " + dir)
files = {}

#Find 'valid' file to rename
for filename in sorted(os.listdir(dir)):
    if isVerbose:
        print("File found: " + filename)
	#check for images in the directory
    if filename.endswith(".jpg") or filename.endswith(".JPG") or filename.endswith(".jpeg") or filename.endswith(".JPEG") or filename.endswith(".PNG")or filename.endswith(".png"):
        date = get_date_taken(dir+"/"+filename)
        if date and useDate:
            files[filename] = date
        else:
            files[filename] = filename

if isVerbose:
    print("Found {} file(s) to rename.".format(len(files)))

if len(files) == 0:
    print("No file found. Aborted.")
    sys.exit()
sorted_files  = sorted(files.items(), key=lambda kv: kv[1])

#files = {}

#Rename 
for filename, date in sorted_files:
    if useDate: #TODO better with extracted method and switch case without break
	    _date_,_time_ = date.split(" ")
	    date_split = _date_.split(":")
	    time_split = _time_.split(":")
	    date_struct = datetime.datetime(year=int(date_split[0]), month=int(date_split[1]), day=int(date_split[2]), hour=int(time_split[0]), minute=int(time_split[1]),second=int(time_split[2]))
	
	    if(cam_name == get_cam_model(dir+"/"+filename)):
		    date_struct = date_struct + time_delay
	    else:
		    print((cam_name,get_cam_model(dir+"/"+filename)))

	    new_filename = str(date_struct.year)+"_"+str(date_struct.month).zfill(2)+"_"+str(date_struct.day).zfill(2)+"_"+str(date_struct.hour).zfill(2)+"_"+str(date_struct.minute).zfill(2)+"_"+str(date_struct.second).zfill(2)+filename[filename.rfind("."):]
	    files[filename] = new_filename
    
    if prefix != "":
        previousname = files[filename]
        new_filename = prefix + "_" + previousname
        files[filename] = new_filename
        if isVerbose:
            print("Prefix added: " + filename + " -> " + new_filename)
    if suffix != "":
        previousname,ext = files[filename].split(".")
        new_filename = previousname + "_" + suffix + "." + ext
        files[filename] = new_filename
        if isVerbose:
            print("Suffix added: " + filename + " -> " + new_filename)

#look for duplicate
nb_duplicates,files = findDuplicates(files)

for old_name, new_name in files.items():
	print("{} -> {}".format(old_name,new_name))
	
#wait fro approval	
print("Would you like to continue the renaming (There is {} duplicate(s) over {} files)? [Y/N]".format(nb_duplicates, len(files)))
x = input()

#rename or exit
if x=='Y' or x=='y':
	for old_name, new_name in files.items():
		os.rename(dir+"/"+old_name,dir+"/"+new_name)
	print("{} files renamed!".format(len(files)))
else:
	exit()
	

