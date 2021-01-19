#!/usr/bin/python

import os
import argparse
import sys
import datetime

import numpy as np
from PIL import Image


def get_date_taken(path):
    # get exif info
    info = Image.open(path)._getexif()
    if info:
        for tag, value in info.items():
            # if DateTimeOriginal(36867) tag found returns the corresponding
            # value
            if tag == 36867:
                return value
    else:
        print("No metadata available for " + path)
        return

def get_cam_model(path):
    # get exif info
    info = Image.open(path)._getexif()
    if info:
        for tag, value in info.items():
            if tag == 272:  # if Model(272) tag found returns the corresponding value
                return value.replace("\x00", "")
    else:
        print("No metadata available for " + path)
        return


def find_duplicates(file_dict):
    final_list = []
    duplicates = 0
    for old_name, new_name in file_dict.items():
        if new_name not in final_list:
            final_list.append(new_name)
        else:
            k = 1
            while new_name in final_list:
                new_name = new_name.replace(".", "(" + str(k) + ").")
                k += 1

            file_dict[old_name] = new_name
            final_list.append(new_name)
            duplicates += 1

    return (duplicates, file_dict)


###################
# Argument parser #
###################


# Create the argument parser, that will display "rename" as program name
# in output
my_parser = argparse.ArgumentParser(
    prog="rename",
    description='Rename file following given pattern.')

# Add the arguments to parse in the CLI
my_parser.add_argument(
    'dir',
    metavar='TARGET_DIR',
    type=str,
    help='Input/Output directory -i.e. the target folder containing pics '
         'to rename')

my_parser.add_argument(
    '--no_date',
    action='store_true',
    help='If specified, pictures do not need date for renaming')
my_parser.add_argument(
    '--cam',
    '-c',
    metavar='CAMERA_NAME',
    type=str,
    help='Camera for which a time delay should be applied '
         '(to be used with --time_delay)')
my_parser.add_argument(
    '--time_delay',
    '-t',
    metavar='DELAY',
    type=str,
    help='Time delay to be applied to a Camera (to be used with --cam). '
         'Format "00:00:00" supported".')
my_parser.add_argument('--suffix', '-s',
                       metavar='SUFFIX',
                       type=str,
                       default="",
                       help='Specify suffix for new renaming')
my_parser.add_argument('--prefix', '-p',
                       metavar='PREFIX',
                       type=str,
                       default="",
                       help='Specify prefix for new renaming')
my_parser.add_argument('--verbose', '-v',
                       action='store_true',
                       help='If specified, plenty of printings')

# Extract arguments
args = my_parser.parse_args()

cam_name = args.cam
time_delay = args.time_delay
date_time_delay = datetime.timedelta()
use_date = not args.no_date
suffix = args.suffix
prefix = args.prefix
is_verbose = args.verbose


###############
# Main script #
###############


# Initial checks
if (time_delay and not cam_name) or (cam_name and not time_delay):
    my_parser.error("--time_delay requires --cam_name and "
                    "--cam_name requires --time_delay.")
if is_verbose:
    print("using dates? " + str(use_date))

if time_delay:
    time_split = time_delay.split(":")
    print("delay split: " + time_split)
    date_time_delay = datetime.timedelta(
        hours=int(
            time_split[0]), minutes=int(
            time_split[1]), seconds=int(
                time_split[2]))
    print("time: " + str(date_time_delay))
if cam_name:
    print("camera name: " + cam_name)

dir = args.dir
print("target directory: " + dir)
files = {}

# Find 'valid' file to rename
for filename in sorted(os.listdir(dir)):
    if is_verbose:
        print("File found: " + filename)
        # check for images in the directory
    if filename.endswith((".jpg", ".JPG", ".jpeg", ".JPEG", ".PNG", ".png")):
        date = get_date_taken(dir + "/" + filename)
        if use_date:
            if date:
                files[filename] = date
        else:
            files[filename] = filename

if is_verbose:
    print("Found {} file(s) to rename.".format(len(files)))

# sort dict by date
sorted_files = sorted(files.items(), key=lambda kv: kv[1])

if len(files) == 0:
    print("No file found. Aborted.")
    sys.exit()
sorted_files = sorted(files.items(), key=lambda kv: kv[1])

# Rename
for filename, date in sorted_files:
    main_name, ext = filename.split(".")

    if use_date and date:
        print(date)
        _date_, _time_ = date.split(" ")
        date_split = _date_.split(":")
        time_split = _time_.split(":")
        date_struct = datetime.datetime(
            year=int(date_split[0]), month=int(date_split[1]),
            day=int(date_split[2]), hour=int(time_split[0]),
            minute=int(time_split[1]), second=int(time_split[2]))

        if cam_name == get_cam_model(dir + "/" + filename):
            date_struct = date_struct + date_time_delay
        else:
            print((cam_name, get_cam_model(dir + "/" + filename)))

        new_name = \
            str(date_struct.year) + "_" + \
            str(date_struct.month).zfill(2) + "_" + \
            str(date_struct.day).zfill(2) + "_" + \
            str(date_struct.hour).zfill(2) + "_" + \
            str(date_struct.minute).zfill(2) + "_" + \
            str(date_struct.second).zfill(2)
        files[filename] = new_name + "_" + ext

    if prefix:
        files[filename] = prefix + "_" + main_name + "." + ext
        if is_verbose:
            print("Prefix added: " + filename + " -> " + files[filename])

    if suffix:
        files[filename] = main_name + "_" + suffix + "." + ext
        if is_verbose:
            print("Suffix added: " + filename + " -> " + files[filename])

# look for duplicate
nb_duplicates, files = find_duplicates(files)

for old_name, new_name in files.items():
    print("{} -> {}".format(old_name, new_name))

# wait for approval
print("Would you like to continue the renaming "
      "(There are {} duplicate(s) over {} files)? [Y/N]".format(nb_duplicates,
                                                                len(files)))
x = input()

#rename or exit
if x in ('Y', 'y'):
    for old_name, new_name in files.items():
        os.rename(dir + "/" + old_name, dir + "/" + new_name)
    print("{} files renamed!".format(len(files)))
else:
    sys.exit()
