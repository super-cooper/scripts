#!/bin/env python3
import itertools
import os
import sys

if len(sys.argv) != 3:
    print("USAGE: python3 <dictionary file> 'string to analyze'")
    sys.exit(1)

dict_path = sys.argv[1]
chars = ''.join(sorted(sys.argv[2].replace(' ', '').lower()))
max_spaces = len(chars) // 3 
chars += " " * max_spaces

if not os.path.exists(dict_path):
    print(f"File not found: {dict_path}")
    sys.exit(2)

with open(dict_path, 'r') as f:
    words = set(line.strip().lower() for line in f.readlines())

print(f"Loaded dictionary with {len(words)} unique words.")

scrambles = set()

i = 0
for perm in itertools.permutations(chars[:40]):
    s = ''.join(perm)
    if all(word in words for word in s.split()):
        scrambles.add(s.strip())
    if i % 1000000 == 0:
        print(f"Tried {i} permutations so far, found {len(scrambles)} valid phrases")
    i += 1

print(f"Tried {i} permutations, found a total of {len(scrambles)} valid phrases")
print("\n".join(list(scrambles)))
