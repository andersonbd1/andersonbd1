#!/usr/bin/python
import sys
import demjson

#print sys.argv[1]
s = sys.stdin.read()

jsonObj = demjson.decode(s)
jsonStr = demjson.encode(jsonObj, compactly=False)


print jsonStr

#print $0
