import nltk
import string
import os
from pprint import pprint

from sklearn.feature_extraction.text import TfidfVectorizer
from nltk.stem.porter import PorterStemmer

path = './profiles'
token_dict = {}


# def tokenize(text):
#     tokens = nltk.word_tokenize(text)
#     stems = []
#     for item in tokens:
#         stems.append(PorterStemmer().stem(item))
#     return stems

for dirpath, dirs, files in os.walk(path):
    for f in files:
        fname = os.path.join(dirpath, f)
        # print "fname=", fname
        print(fname)
        with open(fname) as pearl:
            text = pearl.read()

            token_dict[f] = text.lower() #.translate(string.punctuation)# .translate(None, string.punctuation)
            # token_dict[f] = text.lower()
            # print(token_dict[f])
            # pprint(token_dict)
            tfidf = TfidfVectorizer(tokenizer=text)
            pprint(tfidf)
            # tfs = tfidf.fit_transform(token_dict.values())
            # pprint(tfidf.get_feature_names())
            # pprint(token_dict)
            # pprint(tfs.toarray())
            # pprint(tfidf)



# tfidf = TfidfVectorizer(tokenizer=tokenize, stop_words='english')
# tfs = tfidf.fit_transform(token_dict.values())
#
# pprint(token_dict)
# pprint(tfs.toarray())

# str = 'all great and precious things are lonely.'
# response = tfidf.t([str])
# print(response)
#
# feature_names = tfidf.get_feature_names()
# for col in response.nonzero()[1]:
#     print(feature_names[col])
#     print(response[0, col])
