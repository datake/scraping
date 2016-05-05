import re

f = open('profiles_all/profiles_2323.txt', 'r')
document = []
for line in f:

    # 記号除去
    line = re.sub(re.compile("[!-/:-@[-`{-~]"), '', line)
    # 小文字
    line = line.lower()
    # スペース、タブ、改行文字列で分割
    list = line.split()
    flag = 0
    for idx, word in enumerate(list):
        matchNWC = re.search("[^a-z0-9]", word) #"\W"やisalpha()だと排除できない文字があった
        if matchNWC: # 英語でない文字が含まれる(TODO:短縮語も入る)
            flag = 1
            # print(word)
    if flag == 0 and len(list) > 1:
        document.append(list)

f.close()
print(document)
