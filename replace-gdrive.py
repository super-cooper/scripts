#!/bin/env python3
# Replaces gddoc, gdsheet, gdform, and gdslides files with the google takeout replacement
import os
from pathlib import Path
import shutil
import sys

extension_map = {
    "gddoc": "docx",
    "gdform": "xlsx", 
    "gdslides": "pptx", 
    "gdsheets": "xlsx"
}

if len(sys.argv) != 3:
    print("Usage: ./replace-gdrive.py <Path-to-drive-backup> <path-to-replacement>")
    sys.exit(1)

drive_path = sys.argv[1]
replacement_path = sys.argv[2]
if not all(os.path.exists(d) for d in (drive_path, replacement_path)):
    print("Invalid path provided!")
    sys.exit(2)

found = 0
replaced = 0
could_not_replace = []
# find all gdrive files
for extension in extension_map.keys():
    for gdfile in Path(drive_path).rglob(f"*.{extension}"):
        found += 1
        gdfile_dir = os.path.dirname(gdfile)
        replacement_dir = os.path.join(replacement_path, os.path.relpath(gdfile_dir, drive_path))
        replacement_file = os.path.join(replacement_dir, os.path.splitext(os.path.basename(gdfile))[0]) + f'.{extension_map[extension]}'
        print(f"Found Google Drive File {gdfile}, replacing with {replacement_file}!")
        if not os.path.exists(replacement_file):
            print(f"WARNING: Could not find replacement file {replacement_file}")
            could_not_replace.append(gdfile)
        else:
            replaced += 1
            new_file = shutil.copyfile(replacement_file, os.path.join(gdfile_dir, os.path.basename(replacement_file)))
            if os.path.exists(new_file):
                os.remove(gdfile)

print(f"Found {found} Google Drive files, replaced {replaced}.")
with open('could_not_replace.txt', 'w') as f:
    f.writelines(could_not_replace)
