library(readr)

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

# If using interactively, uncomment below to drop the big files from env:
# rm(en_blog)
# rm(en_news)
# rm(en_twit)