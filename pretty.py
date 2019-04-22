#!/usr/bin/env python
#
# pretty.py
#
# Adapted from http://stackoverflow.com/a/1206856
#
# Pretty-print an XML file. Works with Python >= 2.7
#
# Sytax:
#
#    ./pretty.py filename.xml
#
#    or
#
#    ./pretty.py < filename.xml
#
#    or
#    some-xml-generator |  ./pretty.py
#
#
# Be sure to run this with the tip from here:
#  http://stackoverflow.com/a/6361471
#     export PYTHONIOENCODING=utf-8
#

import sys
import xml.dom.minidom as minidom

if len(sys.argv) > 1:
    dom = minidom.parse(sys.argv[1])
else:
    # Thanks Stack Overflow https://stackoverflow.com/a/24619034
    dom = minidom.parseString(sys.stdin.read())

pretty_xml_as_string = dom.toprettyxml()
print(pretty_xml_as_string)
