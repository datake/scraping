import re
import math
import pprint
import operator


f = open('profiles_all/profiles_2323.txt', 'r')
wordList = []
for line in f:

    # 小文字
    line = line.lower()

    out_pairs =  open("pairs/number.csv", "w")
    matchedList = re.findall('\s(\w+?)(\s+)(\w+?)(\s+)(\d+)(\s+)(\w+?)(\s+)(\w+?)\s', line)
    if matchedList:
        for m in matchedList:
            out_pairs.write("{0}{1}".format(m[0],m[4]))
            print("{0} {1} {2} {3} {4}".format(m[0],m[2],m[4],m[6],m[8])) #?

f.close()
