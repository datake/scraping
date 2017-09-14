import re
import math
import pprint
import operator
# https://ja.wikipedia.org/wiki/Tf-idf


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
df_tmp = {}
idf_tmp = {}
idf = {}
tfidf_tmp = {}
tfidf = {}
sum = 0
num = len(wordList)

# print(wordList)
# wordCountInDoc[i][word]は文書iにおけるwordの出現回数
for i in range(num):
    wordCountInDoc_tmp = {}
    for word in wordList[i]:
        wordCountInDoc[i] = wordCountInDoc_tmp.setdefault(word,0)
        wordCountInDoc_tmp[word]+=1
    wordCountInDoc[i] = wordCountInDoc_tmp

# freq[i]は文書i中の全ての単語数？
# 他に一般的な定義の仕方があるかも？
for i in range(num):
    for word in wordCountInDoc[i]:
        sum = sum + wordCountInDoc[i][word]
    freq[i] = sum
    sum = 0

# freqの正規化(=tf[i][word])
for i in range(num):
    tf_tmp = {}
    for word in wordCountInDoc[i]:
        tf_tmp[word] = wordCountInDoc[i][word]*1.0/freq[i]
    tf[i] = tf_tmp
# pprint.pprint(tf)

# df[word]はwordが出現する文書数
for i in range(num):
    for word in wordList[i]:
        df_tmp.setdefault(word,0)
    for word in wordCountInDoc[i]:
        df_tmp[word] += 1
    df = df_tmp

# idf[i][word]はdf[word]の正規化
for i in range(num):
    idf_tmp = {}
    for word in wordCountInDoc[i]:
        idf_tmp[word] = math.log(1.0*math.fabs(num)/math.fabs(df[word]))
    idf[i] = idf_tmp

# pprint.pprint(idf)

for i in range(num):
    tfidf_tmp = {}
    for word in wordCountInDoc[i]:
        tfidf_tmp[word] = tf[i][word]*idf[i][word]
    tfidf[i] = tfidf_tmp

# pprint.pprint(tfidf)

#tf-idfファイル出力
with open("tfidf_result/tfidf_result_all.csv", "wt") as out_all:
    with open("tfidf_result/tfidf_result_high.csv", "wt") as out_high:
        for i in range(num):
            for word,score in sorted(tfidf[i].items(),key = lambda x:x[1],reverse = True):
                # print("document{0}:{1}:{2:f}".format(i+1,word,score))
                out_all.write("{0},{1},{2:f}\n".format(i+1,word,score))
                if score > 0.3:
                    out_high.write("{0},{1},{2:f}\n".format(i+1,word,score))


# df出力
with open("tfidf_result/df_result_all.csv", "wt") as out_all:
    with open("tfidf_result/df_result_high.csv", "wt") as out_high:
        for word, count in sorted(df.items(),key = lambda x:x[1],reverse = True):
            out_all.write("{0},{1},{2}\n".format(i+1,word,count))
            if count > 5:
                out_high.write("{0},{1},{2}\n".format(i+1,word,count))

# tf出力
with open("tfidf_result/tf_result_all.csv", "wt") as out_all:
    with open("tfidf_result/tf_result_high.csv", "wt") as out_high:
        for i in range(num):
            for word, count in sorted(tf[i].items(),key = lambda x:x[1],reverse = True):
                # print(count)
                out_all.write("{0},{1},{2}\n".format(i+1,word,count))
                if count > 0.1:
                    out_high.write("{0},{1},{2}\n".format(i+1,word,count))
