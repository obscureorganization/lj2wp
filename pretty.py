#!/usr/bin/env python
#
# pretty.py
#
# Thanks Stack Overflow https://stackoverflow.com/a/1206856

import sys
import xml.dom.minidom as minidom

if len(sys.argv) > 1:
    dom = minidom.parse(sys.argv[1])
else:
    # Thanks Stack Overflow https://stackoverflow.com/a/24619034
    dom = minidom.parseString(sys.stdin.read())

pretty_xml_as_string = dom.toprettyxml()
print(pretty_xml_as_string)
