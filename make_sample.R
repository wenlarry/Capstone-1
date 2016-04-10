library(dplyr)
library(readr)

### Write stoped working so I broke something somehow? Possible update
### all to write.table as seen in training/test set.

# Read everything in from the file provided on Coursera
en_twit <- read_table('final/en_US/en_US.twitter.txt', col_names = FALSE)
en_blog <- read_table('final/en_US/en_US.blogs.txt', col_names = FALSE)
en_news <- read_table('final/en_US/en_US.news.txt', col_names = FALSE)

# Sample each of them
twit_sample <- en_twit[sample(nrow(en_twit), round(nrow(en_twit)*.01)),]
blog_sample <- en_blog[sample(nrow(en_blog), round(nrow(en_blog)*.01)),]
news_sample <- en_news[sample(nrow(en_news), round(nrow(en_news)*.01)),]

# Write test files to test dir so easy to build Corpus
write(twit_sample,'sample/twitter_sample.txt')
write(blog_sample, 'sample/blog_sample.txt')
write(news_sample, 'sample/news_sample.txt')

# Sample each of them at 10% now
twit_sample <- en_twit[sample(nrow(en_twit), round(nrow(en_twit)*.1)),]
blog_sample <- en_blog[sample(nrow(en_blog), round(nrow(en_blog)*.1)),]
news_sample <- en_news[sample(nrow(en_news), round(nrow(en_news)*.1)),]

# Write test files to test dir so easy to build Corpus
write(twit_sample,'sample/twitter_sample10.txt')
write(blog_sample, 'sample/blog_sample10.txt')
write(news_sample, 'sample/news_sample10.txt')

# Set up training and test set 
twit_sample <- en_twit[sample(nrow(en_twit), round(nrow(en_twit)*.2)),]
blog_sample <- en_blog[sample(nrow(en_blog), round(nrow(en_blog)*.2)),]
news_sample <- en_news[sample(nrow(en_news), round(nrow(en_news)*.2)),]

train_twit <- sample_frac(twit_sample, 0.7)
twit_sid <- as.numeric(rownames(train_twit))
test_twit <- twit_sample[-twit_sid,]

train_blog <- sample_frac(blog_sample, 0.7)
blog_sid <- as.numeric(rownames(train_blog))
test_blog <- blog_sample[-blog_sid,]

train_news <- sample_frac(news_sample, 0.7)
news_sid <- as.numeric(rownames(train_news))
test_news <- news_sample[-news_sid,]

write.table(train_twit, 'sample/train_twit.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)
write.table(train_blog, 'sample/train_blog.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)
write.table(train_news, 'sample/train_news.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

write.table(test_twit, 'sample/test_twit.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)
write.table(test_blog, 'sample/test_blog.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)
write.table(test_news, 'sample/test_news.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

# If using interactively, uncomment below to drop the big files from env:
# rm(en_blog)
# rm(en_news)
# rm(en_twit)