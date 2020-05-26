import sys

if len(sys.argv) < 2:
    print("Need file path")
    sys.exit(1)

with open(sys.argv[1]) as f:
    s = f.read().strip()

raw_bytes = [int(s[i:i+2], 16) for i in range(0, len(s), 2)]
print([chr(i) for i in raw_bytes])

