library(quanteda)
library(stringi)
library(magrittr)

# Get text files into corpus
corp <- textfile(c('sample/twitter_sample.txt',
                      'sample/blog_sample.txt',
                      'sample/news_sample.txt')) %>%
    corpus()
# Bump up sample size
# corp <- textfile(c('sample/twitter_sample10.txt',
#                    'sample/blog_sample10.txt',
#                    'sample/news_sample10.txt')) %>%
#     corpus()

# set up all the ngram counts
unigrams <- dfm(corp, removeTwitter = TRUE) %>% 
    colSums()

bigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 2 ) %>% 
    colSums()

trigrams <- dfm(corp, removeTwitter = TRUE, ngrams = 3) %>% 
    colSums()

quadgrams <- dfm(corp, removeTwitter = TRUE, ngrams = 4) %>% 
    colSums()

pentagrams <- dfm(corp, removeTwitter = TRUE, ngrams = 5) %>% 
    colSums()

# Function to return the three most common ngrams
predictor <- function(input_text){
    len = stri_count_words(input_text)
    word = gsub(' ', '_', input_text)
    pattern = paste0('^(', word, ')_.*')
    if(len == 4){
        res = head(sort(pentagrams[grepl(pattern, names(pentagrams))],
                        decreasing = TRUE), 3)
    }else if (len == 3){
        res = head(sort(quadgrams[grepl(pattern, names(quadgrams))],
                        decreasing = TRUE), 3)
    }else if (len == 2){
        res = head(sort(trigrams[grepl(pattern, names(trigrams))],
                        decreasing = TRUE), 3)
    }else if (len == 1){
        res = head(sort(bigrams[grepl(pattern, names(bigrams))],
                        decreasing = TRUE), 3)
    }
    names(res) = gsub('_', ' ',names(res))
    res
}

shortener <- function(input_text, new_length){
    words = unlist(strsplit(input_text, ' '))
    words[(length(words) - (new_length-1)):length(words)] %>%
        paste(collapse = " ")
}


# Possibly convert to a non-recursive version and if fast vote in final?
backoff <- function(input_text){
    len = stri_count_words(input_text)
    if (len > 3){
        input_text = shortener(input_text, 3)
        len = stri_count_words(input_text)
    }
    prediction = predictor(input_text)
    if(length(prediction) == 0 & len > 1){
        shortener(input_text, len - 1) %>%
            backoff()
    }else if(length(prediction) == 0 & len <= 1){
        'ummm smoothing, I should read about smoothing'
    }else{
        return(prediction)
    }
}


backoff("The guy in front of me just bought a pound of bacon, a bouquet, and a case of")
backoff("You're the reason why I smile everyday. Can you follow me please? It would mean the")
backoff("Hey sunshine, can you follow me and make me the")
backoff("Very early observations on the Bills game: Offense still struggling but the")
backoff("Go on a romantic date at the")
backoff("Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my")
backoff("Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some")
backoff("After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little")
backoff("Be grateful for the good times and keep the faith during the")
backoff("If this isn't the cutest thing you've ever seen, then you must be")

