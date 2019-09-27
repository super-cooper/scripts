#!/usr/local/bin/python2

import os

print "---------- Close tab to right in Vivaldi for Mac OS - OUBRECHT.com ----------"
print "This script is only for your risk!!!"

vivaldifolder="/Applications/Vivaldi.app/Contents/Frameworks/Vivaldi Framework.framework/Versions/Current/Resources/vivaldi"

print "Generate CSS data"
cssdata="""
.tab-header .favicon, .tab-header .close {
    display: block !important;
}

.tab-header .close {
    order: 1 !important;
    margin-right: 5px;
}
"""

print "Write CSS data: style/custom.css"
file_name = vivaldifolder+'/style/custom.css'
f = open(file_name, 'w+')  # open file in write mode
f.write(cssdata)
f.close()


print "Load original browser.html"
with open(vivaldifolder+'/browser.html', 'r') as browserfile:
    browserdata=browserfile.read().replace('<link rel="stylesheet" href="style/custom.css" />\n', '')
    browserdata=browserdata.replace('</head>', '<link rel="stylesheet" href="style/custom.css" />\n</head>')
    browserfile.close()
#print browserdata

print "Write change to browser.html"
file_name = vivaldifolder+'/browser.html'
f = open(file_name, 'w+')  # open file in write mode
f.write(browserdata)
f.close()


print "Changes are created"
print "OUBRECHT.com"
#print "url: " + vivaldifolder

print "---------- Close tab to right in Vivaldi for Mac OS - OUBRECHT.com ----------"
