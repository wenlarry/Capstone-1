library(data.table)
library(dplyr)
library(quanteda)
library(stringr)


# Get text files into corpus
corp <- textfile(c('sample/train_twit.txt',
                   'sample/train_news.txt',
                   'sample/train_blog.txt')) %>%
    corpus()


# set up all the ngram counts
unigrams <- dfm(corp, removeTwitter = TRUE) %>% 
    colSums()

bigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 2 ) %>% 
    colSums()

trigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 3) %>% 
    colSums()

uni_DT <- data.table(end = names(unigrams), count = unigrams)
uni_DT <- uni_DT[!grepl("_",uni_DT$end)]
uni_DT <- uni_DT[count > 1]
uni_DT$Pkn <- uni_DT$count/sum(uni_DT$count)
setkey(uni_DT)


bi_DT <- data.table(ngram = names(bigrams), count = bigrams)
bi_DT <- bi_DT[!grepl("__",bi_DT$ngram)]
bi_DT <- bi_DT[count > 1]
bi_DT[,c("start", "end") := tstrsplit(ngram, "_(?!.*_)", perl = TRUE)]
setkey(bi_DT)
A <- bi_DT$count
#should remove encoded things?
B <- uni_DT[bi_DT$start,]$count
N <- tabulate(bi_DT$count)
D <- N[1] / (N[1] + 2 * N[2])
N1plus <- table(bi_DT$start)[bi_DT$start]
N1plus2 <- table(bi_DT$end)[bi_DT$end]
N1plus3 <- nrow(bi_DT)
bi_DT$Pkn <- sapply((A-D),max, 0)/ B + D/B * N1plus * N1plus2/N1plus3


tri_DT <- data.table(ngram = names(trigrams), count = trigrams)
tri_DT <- tri_DT[!grepl("__",tri_DT$ngram)]
tri_DT <- tri_DT[count > 1]
tri_DT[,c("start", "end") := tstrsplit(ngram, "_(?!.*_)", perl = TRUE)]
setkey(tri_DT)
A <- tri_DT$count
B <- bi_DT[tri_DT$start,]$count
N <- tabulate(tri_DT$count)
D <- N[1] / (N[1] + 2 * N[2])
N1plus <- table(tri_DT$start)[tri_DT$start]
bi_pkn <- bi_DT[tri_DT$start,]$Pkn
tri_DT$Pkn <- sapply((A-D),max, 0)/ B + D/B * N1plus * bi_pkn


saveRDS(uni_DT, "Shiny_app/tables/uni_DT.rds")
saveRDS(bi_DT, "Shiny_app/tables/bi_DT.rds")
saveRDS(tri_DT, "Shiny_app/tables/tri_DT.rds")

dirty.words.link <- 'https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en'
dirty.words <- readLines(dirty.words.link)
dirty.words <- c(dirty.words, "hell")
saveRDS(dirty.words, "Shiny_app/tables/dirty_words.rds")
