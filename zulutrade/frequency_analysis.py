nltk.download()
# http://d.hatena.ne.jp/mickey24/20110212/nlp_with_the_social_network
raw = open('output/profiles_2323.txt').read()
tokens = nltk.word_tokenize(raw)
text = nltk.Text(tokens)


fdist = nltk.FreqDist(w.lower() for w in text)
vocab1 = list(fdist.keys())
vocab[:200]


stopwords = nltk.corpus.stopwords.words('english')
symbols = ["'", '"', '`', '.', ',', '-', '!', '?', ':', ';', '(', ')']
fdist_stopword = nltk.FreqDist(w.lower() for w in text if w.lower() not in stopwords + symbols)
vocab_stopword = list(fdist_stopword.keys())
vocab_stopword[:200]
