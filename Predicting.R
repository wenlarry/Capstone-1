library(quanteda)
library(stringr)
library(dplyr)

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

train_corp <- textfile(c('sample/twitter_sample.txt',
                   'sample/blog_sample.txt',
                   'sample/news_sample.txt')) %>%
    corpus()

test_corp <- textfile(c('sample/twitter_sample.txt',
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


unigrams_SWR <- dfm(corp, removeTwitter = TRUE,
                ignoredFeatures = stopwords("english")) %>% 
    colSums()

bigrams_SWR <- dfm(corp, removeTwitter = TRUE, ngrams = 2,
               ignoredFeatures = stopwords("english")) %>% 
    colSums()

trigrams_SWR <- dfm(corp, removeTwitter = TRUE, ngrams = 3,
                    ignoredFeatures = stopwords("english")) %>% 
    colSums()

quadgrams_SWR <- dfm(corp, removeTwitter = TRUE, ngrams = 4,
                     ignoredFeatures = stopwords("english")) %>% 
    colSums()


ngram_prob <- function(ngram){
    # Take only those greater than 1
    ngram = ngram[ngram > 1]
    # Check if unigram or ngram (could probably be done better)
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

# Need to remove punctuation
src_prep <- function(word_list, num_words){
    len = length(word_list)
    word_list[(len-(num_words-1)):len] %>%
        paste(collapse = "_")
}

sw_regex = paste(stopwords(),collapse =  '\\b|\\b')

sw_src_prep <- function(word_list, num_words){
    word_list = gsub(sw_regex,'', word_list)
    word_list = word_list[!word_list == ""]
    print(word_list)
    len = length(word_list)
    word_list[(len-(num_words-1)):len] %>%
        paste(collapse = "_")
}

predictor <- function(input_text){
    input_text = tolower(input_text)
    words = unlist(str_split(input_text, ' '))
    bi = bi_probs[bi_probs$start == src_prep(words, 1),]
    tri = tri_probs[tri_probs$start == src_prep(words, 2),]
    quad = quad_probs[quad_probs$start == src_prep(words, 3),]
    bi$prob = bi$prob * .16
    tri$prob = tri$prob * .4
    quad$prob = quad$prob
    rbind(bi,tri,quad) %>%
        group_by(end) %>%
        summarise('weight_prob' =sum(prob)) %>%
        arrange(desc(weight_prob))
}

# Quize 2
predictor("The guy in front of me just bought a pound of bacon, a bouquet, and a case of")
predictor("You're the reason why I smile everyday. Can you follow me please? It would mean the")
predictor("Hey sunshine, can you follow me and make me the")
predictor("Very early observations on the Bills game: Offense still struggling but the")
predictor("Go on a romantic date at the")
predictor("Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my")
predictor("Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some")
predictor("After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little")
predictor("Be grateful for the good times and keep the faith during the")
predictor("If this isn't the cutest thing you've ever seen, then you must be")

# Quize 3
predictor("When you breathe, I want to be the air for you. I'll be there for you, I'd live and I'd")
predictor("Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his")
View(kn_predictor("I'd give anything to see arctic monkeys this")) #morning was higher :/
View(predictor("Talking to your mom has the same effect as a hug and helps reduce your")) #nailed it
View(predictor("When you were in Holland you were like 1 inch away from me but you hadn't time to take a")) #picture was second
View(predictor("I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the")) #matter was second of options
View(predictor("I can't deal with unsymetrical things. I can't even hold an uneven number of bags of groceries in each")) # hand is second of options
View(predictor("Every inch of you is perfect from the bottom to the"))
View(predictor("I'm thankful my childhood was filled with imagination and bruises from playing"))
View(predictor("I like how the same people are in almost all of Adam Sandler")) # no result :/


foo <- dfm(corp, removeTwitter = TRUE, ngrams = 4)
