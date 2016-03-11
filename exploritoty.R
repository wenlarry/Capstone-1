#setwd('Box Sync/datasciencecoursera/Capstone/')

library('tm')
library('readr')
library('SnowballC')

directory <- DirSource('final/en_US/')
testCorp <- Corpus(directory, readerControl = list(language="en"))

testCorp$en_US.twitter.txt

testnumrem<- tm_map(testCorp, removeNumbers)
testMatrix <- DocumentTermMatrix(testnumrem)

directory2 <- DirSource('final/en_US/en_US.news.txt')
testCorp2 <- Corpus(directory2, readerControl = list(language="en"))