library(data.table)

# Prep the data

twit_test <- readLines("sample/test_twit.txt") %>%
    .[1:1000] %>%
    data.table(ngram = .)

news_test <- readLines("sample/test_news.txt") %>%
    .[1:1000] %>%
    data.table(ngram = .)

# blog_test <- readLines("sample/test_blog.txt") %>%
#     data.table(ngram = .)

# drop emojis too?
twit_test$ngram <- gsub("[[:punct:]]|\\d",'' , twit_test$ngram) %>%
    gsub(" *$",'',.)
news_test$ngram <- gsub("[[:punct:]]|\\d| *$",'' , news_test$ngram) %>%
    gsub(" *$",'',.)
# blog_test$ngram <- gsub("[[:punct:]]",'' , blog_test$ngram)


twit_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]
news_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]
#blog_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]


test_pred <- function(text_input){
    pred <- kn_predictor(text_input)
    if(is.na(pred)){
            ans = NA
        }else{
            ans = pred[1]$end
        }
    ans
}


twit_test$pred <- sapply(twit_test$start, test_pred, USE.NAMES = F)
news_test$pred <- sapply(news_test$start, test_pred, USE.NAMES = F)


twit_test$end <- gsub("[[:punct:]]", '', twit_test$end) %>%
    tolower()
news_test$end <- gsub("[[:punct:]]", '', news_test$end) %>%
    tolower()


table(twit_test$end == twit_test$pred)
table(news_test$end == news_test$pred)
#View(twit_test)
#View(news_test)

# No stop words removed
# 1% got 13/1000
# make sure to remove punctuation from end

# 10% sample size is getting 120/1000

# Fixed weighting unigram for same word 
# twit 121
# news 143
# Without fix SAME???? sigh oh well.

# Using unigrams more acurately...
# annndddd predictions got slightly worse :(
# Twit 120
# News 140

# first try at dealing with NA predictions
# Annnndddd basically same results
# Twit 120
# News 141


 

