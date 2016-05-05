import re
import math
import pprint


f = open('profiles_all/profiles_2323.txt', 'r')
wordList = []
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
        wordList.append(list)

f.close()
# print(wordList)


wordCount = {}
wordCountInDoc = {}
freq = {}
tf_tmp = {}
tf = {}
df = {}
idf_tmp = {}
idf = {}
tfidf_tmp = {}
tfidf = {}
sum = 0
num = len(wordList)

# print(wordList)
# wordCountInDoc[i][word]は文書iにおけるwordの出現回数
for i in range(num):
    for word in wordList[i]:
        wordCountInDoc[i] = wordCount.setdefault(word,0)
        wordCount[word]+=1
    wordCountInDoc[i] = wordCount       #単語出現回数を文章ごとに格納。
    wordCount = {}

# freq[i]は文書i中の全ての単語数？
# 他に一般的な定義の仕方があるかも？
for i in range(num):
    for word in wordCountInDoc[i]:
        sum = sum + wordCountInDoc[i][word]
    freq[i] = sum
    sum = 0

# freqの正規化(=tf)
for i in range(num):
    for word in wordCountInDoc[i]:
        tf_tmp[word] = wordCountInDoc[i][word]*1.0/freq[i]
    tf[i] = tf_tmp
    tf_tmp = {}
# pprint.pprint(tf)

# df[word]はwordが出現する文書数
for i in range(num):
    for word in wordList[i]:
        wordCount.setdefault(word,0)
    for word in wordCountInDoc[i]:
        wordCount[word] += 1
    df = wordCount

# idf[i][word]はdf[word]の正規化
for i in range(num):
    for word in wordCountInDoc[i]:
        idf_tmp[word] = math.log(1.0*math.fabs(num)/math.fabs(df[word]))
    idf[i] = idf_tmp
    idf_tmp = {}

# pprint.pprint(df)

for i in range(num):
    for word in wordCountInDoc[i]:
        tfidf_tmp[word] = tf[i][word]*idf[i][word]
    tfidf[i] = tfidf_tmp
    tfidf_tmp = {}

# pprint.pprint(tfidf)
for i in range(num):          #降順に出力する
    for word,count in sorted(tfidf[i].items(),key = lambda x:x[1],reverse = True):
        print("document{0}:{1}:{2:f}".format(i+1,word,count))
