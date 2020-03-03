#!/bin/env python3

"""
This script chooses a random movie from a letterboxd watchlist CSV file.
The path to the file either has to be passed to this script as an argument, 
or the script has to be run from inside the same directory as watchlist.csv.
"""

import csv
import os
import random
import sys

watchlist_path = "watchlist.csv"

if len(sys.argv) < 2:
    # choose ./watchlist.csv by default
    if not os.path.exists(watchlist_path):
        print("Usage: ./.random-movie.py [name of watchlist]")
        sys.exit(1)
else:
    watchlist_path = sys.argv[1]

film_list = []
# read in the whole list
with open(watchlist_path) as f:
    reader = csv.reader(f, delimiter=',')
    for row in reader:
        film_list.append(list(row))

# remove the header (DATE|NAME|YEAR|URI)
film_list.pop(0)

film = random.choice(film_list)
date = film[0]
name = film[1]
year = film[2]
uri = film[3]

print(f"{name} ({year})\nAdded {date}\nLink: {uri}")
