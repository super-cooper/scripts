#!/bin/env python3

import re
import sys

if len(sys.argv) != 2:
    print("Usage: python3 openssl_version_translator.py <OPENSSL_VERSION_TEXT>")
    sys.exit(1)

version_text = sys.argv[1].strip().lower()

if not re.match(r'[0-9]\.[0-9]{1,2}\.[0-9]{1,2}([a-z])?( (dev|beta [0-9]{1,2}|release))?', version_text):
    print(f"Invalid version text: {version_text}")
    sys.exit(2)

data = list(re.split(r'\.|\W', version_text))
while len(data) < 5:
    data.append(None)

fixed_data = data[0:3] + ([None] * 3)
if re.match(r'[0-9]+[a-z]', data[2]):
    fixed_data[2] = data[2][:-1]
    fixed_data[3] = data[2][-1]
fixed_data[4] = data[3]
fixed_data[5] = data[4]
print(fixed_data)


major, minor, fix, patch, status, number = fixed_data
hexfmt = '0>2x'
if status is None:
    status = "release"
version_number = [format(int(major), 'x'), format(int(minor), hexfmt), format(int(fix), hexfmt)]
if patch is not None:
    version_number.append(format(ord(patch) - ord('a') + 1, hexfmt))
else:
    version_number.append(format(0, hexfmt))
if status == 'dev':
    version_number.append('0')
elif status == 'beta':
    version_number.append(format(int(number), 'x'))
elif status == 'release':
    version_number.append('f')

print(f"0x{''.join(version_number).upper()}")

