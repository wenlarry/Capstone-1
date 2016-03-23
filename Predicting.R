library(quanteda)
library(magrittr)

# Get text files into corpus
corp <- textfile(c('sample/twitter_sample.txt',
                      'sample/blog_sample.txt',
                      'sample/news_sample.txt')) %>%
    corpus()


ungrams <- dfm(corp, removeTwitter = TRUE) %>% 
    colSums(text.dfm)

bigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 2 ) %>% 
    colSums(text.dfm)

trigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 3) %>% 
    colSums(text.dfm)

quadgrams <- dfm(corp, removeTwitter = TRUE, ngrams = 4) %>% 
    colSums(text.dfm)

head(sort(ungrams[grepl('^(liv).*', names(ungrams))], decreasing = TRUE), 3)
head(sort(bigrams[grepl('^(we).*', names(bigrams))], decreasing = TRUE), 3)
head(sort(trigrams[grepl('^(we_are).*', names(trigrams))], decreasing = TRUE), 3)
head(sort(quadgrams[grepl('^(we_are_looking).*', names(quadgrams))], decreasing = TRUE), 3)
