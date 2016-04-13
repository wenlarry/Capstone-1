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
twit_test$ngram <- gsub("[[:punct:]]|\\d| *$",'' , twit_test$ngram)
news_test$ngram <- gsub("[[:punct:]]|\\d| *$",'' , news_test$ngram)
# blog_test$ngram <- gsub("[[:punct:]]",'' , blog_test$ngram)


twit_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]
news_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]
#blog_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]


test_pred <- function(text_input){
    ans = kn_predictor(text_input)[1]$end
}


twit_test$pred <- sapply(twit_test$start, test_pred, USE.NAMES = F)
news_test$pred <- sapply(news_test$start, test_pred, USE.NAMES = F)


twit_test$end <- gsub("[[:punct:]]", '', twit_test$end) %>%
    tolower()
news_test$end <- gsub("[[:punct:]]", '', news_test$end) %>%
    tolower()

View(twit_test)
table(twit_test$end == twit_test$pred)
table(news_test$end == news_test$pred)

# No stop words removed
# 1% got 13/1000
# make sure to remove punctuation from end

# 10% sample size is getting 120/1000

