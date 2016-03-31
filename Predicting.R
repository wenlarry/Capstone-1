library(quanteda)
library(stringr)
library(dplyr)

# Get text files into corpus
corp <- textfile(c('sample/twitter_sample.txt',
                   'sample/blog_sample.txt',
                   'sample/news_sample.txt')) %>%
    corpus()

# set up all the ngram counts
unigrams <- dfm(corp, removeTwitter = TRUE) %>% 
    colSums()

bigrams2 <- dfm(corp, removeTwitter = TRUE, ngrams = 2 ) %>% 
    colSums()

trigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 3) %>% 
    colSums()

quadgrams <- dfm(corp, removeTwitter = TRUE, ngrams = 4) %>% 
    colSums()

ngram_prob <- function(ngram){
    # Possibly take only those greater than 1
    if(grepl('_', names(ngram[1]))){
        df = data.frame(str_split_fixed(names(ngram), '_(?!.*_)', 2),
                   as.numeric(ngram),
                   stringsAsFactors = FALSE)
        names(df) = c('start', 'end', 'count')
        df = group_by(df, start) %>%
            mutate('prob' = count/sum(count))
    }else{
        # room for improvement with unigrams
        df = data.frame('end' = names(ngram),
                        'count' = as.numeric(ngram),
                        stringsAsFactors = FALSE) %>%
            mutate('prob' = count/sum(count)) 
    }
    df
}

uni_probs <- ngram_prob(unigrams)
bi_probs <- ngram_prob(bigrams)
tri_probs <- ngram_prob(trigrams)
quad_probs <- ngram_prob(quadgrams)



