from sklearn.feature_extraction.text import TfidfVectorizer
# http://qiita.com/ynakayama/items/234ad00ae520030217ab
# http://qiita.com/ynakayama/items/05ab9ab9b7c579894bd7
class Tfidf:
    def token_dict(self):
        dic = {}
        # ディレクトリを辿って、テキストファイル中の語彙を辞書にまとめる
        for subdir, dirs, files in os.walk(self.target_dir):
            for file in files:
                file_path = os.path.join(subdir, file)
                shakes = open(file_path, 'r') # ファイルを開いて
                text = shakes.read() # テキストを読み込んで
                lowers = text.lower() # 小文字化して
                dic[file] = lowers # 辞書に格納し
                shakes.close() # ファイルを閉じる
        # 辞書を返却する
        return dic

    # TF-IDF ベクタライザーで読み込む関数
    # 文章をどう「ぶつ切りにする」かを定義しておく
    def tokenize(self, text):
        words = text.rstrip().split("\n")
        return list(set(words))

    # メインとなる解析関数
    def analyze(self):
        dic = {}
        # まずはファイルから語彙群を辞書として読み込んでくる
        print("analyze")

        token_dic = self.token_dict()
        # scikit-learn の TF-IDF ベクタライザーを利用する
        tfidf = TfidfVectorizer(tokenizer=self.tokenize,
                                max_df=30)

        # 語彙群に対するフィッティングをおこなう
        tfs = tfidf.fit_transform(token_dic.values())

        # 語彙群そのものを格納しておく
        feature_names = tfidf.get_feature_names()

        # ここから情報の整理
        i = 0
        for k, v in token_dic.items():
            # 文書名、 TF-IDF スコアのペアを辞書にする
            d = dict(zip(feature_names, tfs[i].toarray()[0]))
            # TF-IDF の高い順にソートする
            score = [(x, d[x]) for x in sorted(d, key=lambda x:-d[x])]
            # 実験なのでとりあえずスコアの高い順、トップ 100 を抽出してみる
            dic[k] = score[:100]
            i += 1

        # 最終的に生成した辞書を返却
        return dic
    def test(self):
        print("ggg")

print("aaa")
tfidf = Tfidf()
print(tfidf.test)
