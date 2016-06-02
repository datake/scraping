import re
import math
import pprint
import operator


f = open('profiles_all/profiles_2323.txt', 'r')
wordList = []
for line in f:

    # 記号除去(/は残す)
    # line = re.sub(re.compile("[!-:-@[-`{-~<>=:;]"), '', line)
    line = line.replace("/", "thisisslash")
    line = re.sub(re.compile("[!-/:-@≠\[-`{-~]"), '', line)
    # 小文字
    line = line.lower()

    matchNWC = re.search("[^a-z0-9\s]", line) #"\W"やisalpha()だと排除できない文字があった
    if matchNWC: # 英語じゃない文字とマッチ
        continue

    line = line.replace("thisisslash", "/")

    out_pairs =  open("pairs/pairs.csv", "w")
    matchedList = re.findall('\s(\w+)/(\w+)\s', line)
    if matchedList:
        # print(line)
        # print (matchedList)
        for m in matchedList:
            out_pairs.write("{0}/{1}".format(m[0],m[1]))
            print("{0}/{1}".format(m[0],m[1])) #?


    matchedList = re.findall('\s(\w+?)(\s+)/(\s+)(\w+?)\s', line)
    # print(line)
    if matchedList:
        for m in matchedList:
            out_pairs.write("{0}/{1}\n".format(m[0],m[3]))
            print("{0}/{1}\n".format(m[0],m[3])) #?

    out_pairs.write("HOGEHOGE\n")
f.close()
