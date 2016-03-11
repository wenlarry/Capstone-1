import textmining

test = open('test/en_US.news.txt')
news = test.read()


tdm = textmining.TermDocumentMatrix()
tdm.add_doc(news)

tdm.write_csv('matrix.csv', cutoff=1)
