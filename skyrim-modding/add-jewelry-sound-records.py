#!/bin/env python3

"""
Adds Immersive Sounds records to modded jewelry
"""

import csv
import os
import sys

kwd_ring = "ClothingRing [KYWD:0010CD09]"
kwd_necklace = "ClothingNecklace [KYWD:0010CD0A]"
sound_ring_up = "ITMRingUp [SNDR:0C08AB14]"
sound_neck_up = "ITMNeckUp [SNDR:0C08AB15]"
sound_neck_down = "ITMNeckDown [SNDR:0C08AB16]"

prefix_map = {
    "15": "2A", 
    "21": "45", 
    "24": "4F",
}

if len(sys.argv) < 2:
    print("Usage: add-jewelry-sound-records.py <path-to-info-dir>")
    sys.exit(1)
else:
    info_dir = sys.argv[1]

record_list = []

with open(os.path.join(info_dir, "Exported.csv")) as f:
    reader = csv.reader(f, delimiter=",")
    record_list = [list(row) for row in reader]
    record_list.pop(0)

with open("Output.csv", 'a') as outfile:
    writer = csv.writer(outfile, delimiter=',')
    writer.writerow(["Record", "YNAM", "ZNAM"])

    for record in record_list:
        form_id = int(record[0])
        form_id_hex = hex(form_id)[2:].upper().zfill(8)
        sound_up = record[2]
        sound_down = record[3]

        with open(os.path.join(info_dir, form_id_hex + ".txt")) as f:
            kwds = [line.strip() for line in f.readlines()]
            if form_id_hex[0:2] in prefix_map:
                form_id_hex = prefix_map[form_id_hex[0:2]] + form_id_hex[2:]
            if any(line == kwd_ring for line in kwds):
                print(f"Detected record {form_id_hex} as Ring")
                sound_up = sound_ring_up
                sound_down = ''
            elif any(line == kwd_necklace for line in kwds):
                print(f"Detected record {form_id_hex} as Necklace")
                sound_up = sound_neck_up
                sound_down = sound_neck_down

        row = [str(int(form_id_hex, 16)), sound_up, sound_down]
        print(f"Writing row: {row}")
        writer.writerow(row)

