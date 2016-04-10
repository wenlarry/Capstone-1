library(data.table)
library(dplyr)
library(quanteda)
library(stringr)


# Get text files into corpus
corp <- textfile(c('sample/twitter_sample.txt',
                   'sample/blog_sample.txt',
                   'sample/news_sample.txt')) %>%
    corpus()

# set up all the ngram counts
unigrams <- dfm(corp, removeTwitter = TRUE) %>% 
    colSums()

bigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 2 ) %>% 
    colSums()

trigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 3) %>% 
    colSums()

quadgrams <- dfm(corp, removeTwitter = TRUE, ngrams = 4) %>% 
    colSums()

#
uni_DT <- data.table(ngram = names(unigrams), count = unigrams)
uni_DT$Pkn <- uni_DT$count/(sum(uni_DT$count)-3)
setkey(uni_DT)


bi_DT <- data.table(ngram = names(bigrams), count = bigrams)
bi_DT[,c("start", "end") := tstrsplit(ngram, "_(?!.*_)", perl = TRUE)]
setkey(bi_DT)
A <- bi_DT$count
#should remove encoded things (thought I already did??)
B <- uni_DT[bi_DT$start,]$count
N <- tabulate(bi_DT$count)
D <- N[1] / (N[1] + 2 * N[2])
N1plus <- table(bi_DT$start)[bi_DT$start]
N1plus2 <- table(bi_DT$end)[bi_DT$end]
N1plus3 <- nrow(bi_DT)
bi_DT$Pkn <- sapply((A-D),max, 0)/ B + D/B * N1plus * N1plus2/N1plus3


tri_DT <- data.table(ngram = names(trigrams), count = trigrams)
tri_DT[,c("start", "end") := tstrsplit(ngram, "_(?!.*_)", perl = TRUE)]
setkey(tri_DT)
A <- tri_DT$count
B <- bi_DT[tri_DT$start,]$count
N <- tabulate(tri_DT$count)
D <- N[1] / (N[1] + 2 * N[2])
N1plus <- table(tri_DT$start)[tri_DT$start]
bi_pkn <- bi_DT[tri_DT$start,]$Pkn
tri_DT$Pkn <- sapply((A-D),max, 0)/ B + D/B * N1plus * bi_pkn

