#!/bin/bash
source /home/adam/mongodb/mongo/python3-venv/bin/activate
"$HOME"/mongodb/mongo/buildscripts/clang_format.py format $@
