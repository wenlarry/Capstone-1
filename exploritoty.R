setwd('Box Sync/datasciencecoursera/Capstone/')

library('tm')
library('readr')
library('SnowballC')

directory <- DirSource('test/')
sample.corp <- Corpus(directory, readerControl = list(language="en"))

summary(sample.corp)  
sample.corp <- tm_map(sample.corp, removeNumbers)
sample.corp <- tm_map(sample.corp, removePunctuation)
sample.corp <- tm_map(sample.corp, stripWhitespace)
sample.corp <- tm_map(sample.corp, tolower)
sample.corp <- tm_map(sample.corp, removeWords, stopwords("english"))
sample.corp <- tm_map(sample.corp, stemDocument, language = "english")
sample.corp <- tm_map(sample.corp, PlainTextDocument)
sample.dtm <- DocumentTermMatrix(sample.corp) 

inspect(sample.dtm)

freq <- colSums(as.matrix(sample.dtm)) 

length(freq)

ord <- order(freq)

dtms <- removeSparseTerms(sample.dtm, 0.10)
View(inspect(dtms))

freq[tail(ord,100)]

findFreqTerms(sample.dtm, lowfreq=500)


