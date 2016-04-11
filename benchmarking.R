

twit_test <- readLines("sample/test_twit.txt") %>%
    .[1:1000] %>%
    data.table(ngram = .)

blog_test <- readLines("sample/test_blog.txt") %>%
    data.table(ngram = .)
news_test <- readLines("sample/test_news.txt") %>%
    data.table(ngram = .)

twit_test$ngram <- gsub("[[:punct:]]|\\d| *$",'' , twit_test$ngram)
blog_test$ngram <- gsub("[[:punct:]]",'' , blog_test$ngram)
news_test$ngram <- gsub("[[:punct:]]",'' , news_test$ngram)

# drop emojis too?
twit_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]
blog_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]
news_test[,c("start", "end") := tstrsplit(ngram, " (?!.* )", perl = TRUE)]

test_pred <- function(text_input){
    ans = kn_predictor(text_input)[1]$end
}
kn_predictor(twit_test$start)

results <- sapply(twit_test$start, test_pred, USE.NAMES = F)

twit_test[,"pred":= test_pred(start)]
twit_test$pred <- results


clean_end <- gsub("[[:punct:]]", '', twit_test$end) %>%
    toLower()

table(clean_end == results)
# No stop words removed
# 1% got 13/1000
# make sure to remove punctuation from end
# 10% got 120/1000

twit_test$pred <- results

