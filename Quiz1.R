#setwd('Box Sync/datasciencecoursera/Capstone/')

library(readr)
library(stringr)
file.size('final/en_US/en_US.blogs.txt')


en_twit <- read_table('final/en_US/en_US.twitter.txt', col_names = FALSE)
en_blog <- read_table('final/en_US/en_US.blogs.txt', col_names = FALSE)
en_news <- read_table('final/en_US/en_US.news.txt', col_names = FALSE)

max(sapply(en_blog, nchar))
max(sapply(en_news, nchar))

en_news[apply(as.matrix(en_news), 1, function(x){ sum(grepl("0080", x, perl=T)) > 0 })]

dim(en_twit)
l<- sum(str_count(en_twit, 'love'))

love_matches <- apply(as.matrix(en_twit), 1,
                      function(x){ sum(grepl("love", x, perl=T)) > 0 })
hate_matches <- apply(as.matrix(en_twit), 1,
                      function(x){ sum(grepl("hate", x, perl=T)) > 0 })
bio_tweet <- en_twit[apply(as.matrix(en_twit), 1,
                           function(x){ sum(grepl("biostats", x, perl=T)) > 0 }),]


kickbox <- apply(as.matrix(en_twit), 1, 
                 function(x){ sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", x, perl=T)) > 0 })

love <- grepl('love', en_twit)
hate <- grepl('hate', en_twit)



