#!/usr/bin/python

import os
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

if len(sys.argv) < 2:
	print("[error] dir name not provided")
	exit(-1)

number=1
cam_name = ''
time_delay = datetime.timedelta()
try:
	opts, args = getopt.getopt(sys.argv[1:],"hc:t:",["camera=","time"])
except getopt.GetoptError:
	print('renameImgs.py -c <camera_name> -t <time_delay h:m:s> dir_name')
	sys.exit(2)
for opt,arg in opts:
	if opt == '-h':
		print('renameImgs.py -c <camera_name> -t <time_delay> dir_name')
		sys.exit()
	elif opt in ("-c","--camera"):
		cam_name = arg
	elif opt in ("-t","--time"):
		time_split = arg.split(":")
		print("delay split: {}".format(time_split))
		time_delay = datetime.timedelta(hours=int(time_split[0]),minutes=int(time_split[1]),seconds=int(time_split[2]))
		
dir = sys.argv[-1]
print("dir: "+dir)
print("cam: "+cam_name)
print("time: "+str(time_delay))
files = {}

for filename in sorted(os.listdir(dir)):
	#check for images in the directory
	if filename.endswith(".jpg") or filename.endswith(".JPG") or filename.endswith(".jpeg") or filename.endswith(".JPEG") or filename.endswith(".PNG")or filename.endswith(".png"):
		date = get_date_taken(dir+"/"+filename)
		if date:
			files[filename] = date

sorted_files  = sorted(files.items(), key=lambda kv: kv[1])

files = {}

for filename, date in sorted_files:
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
	
#look for duplicate
nb_duplicates,files = findDuplicates(files)

for old_name, new_name in files.items():
	print("{} -> {}".format(old_name,new_name))
	
#wait fro approval	
print("{} duplicates. Would you like to continue? [Y/N]".format(nb_duplicates))
x = input()

#rename or exit
if x=='Y' or x=='y':
	for old_name, new_name in files.items():
		os.rename(dir+"/"+old_name,dir+"/"+new_name)
	print("{} files renamed!".format(len(files)))
else:
	exit()
	

