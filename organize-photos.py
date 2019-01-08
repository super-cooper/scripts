# /bin/env python3

# This is a script that takes all photos in one directory and organizes them into
# subdirectories by their resolutions

import os
import cv2
import sys


def print_help():
    print("Usage: organize-photos.py <path/to/photos/dir>")
    sys.exit(1)


if len(sys.argv) < 2:
    print_help()

path = sys.argv[1]

if not os.path.isdir(path):
    print(f"No such directory: {path}")
    print_help()

pics = [os.path.join(path, node) for node in os.listdir(path) if cv2.imread(os.path.join(path, node)) is not None]
for pic in pics:
    height, width, _ = cv2.imread(pic).shape
    dim_str = f'{width}x{height}'
    if not os.path.isdir(os.path.join(path, dim_str)):
        os.mkdir(os.path.join(path, dim_str))
    os.rename(pic, os.path.join(os.path.join(path, dim_str), os.path.basename(pic)))
