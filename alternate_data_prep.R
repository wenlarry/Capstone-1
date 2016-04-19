library(data.table)
library(dplyr)
library(quanteda)
library(stringr)
library(readr)

# Goodness this script is a sin
# Run it from the base directory
sorry_future_me <- function(handle){
    canidates <- read_csv(paste0("alternate_text_sources/tweets/", handle, ".csv"))
    canidates$text <- gsub('(@\\S*)', '', canidates$text)
    canidates$text <- gsub('(#\\S*)', '', canidates$text)
    canidates$text <- gsub('\\bRT\\b', '', canidates$text)
    canidates$text <- gsub('(http\\S*)', '', canidates$text)
    canidates$text <- gsub(' {2,}', '', canidates$text)
    canidates$text <- gsub('^ | $', '', canidates$text)
    
    # Get text files into corpus
    raw_corp <- corpus(canidates$text)
    
    # set up all the ngram counts
    make_ngrams <- function(corp){
        unigrams <<- dfm(corp, removeTwitter = TRUE) %>% 
            colSums()
        
        bigrams <<- dfm(corp, removeTwitter = TRUE, ngrams = 2 ) %>% 
            colSums()
        
        trigrams <<- dfm(corp, removeTwitter = TRUE, ngrams = 3) %>% 
            colSums()
    }
    make_ngrams(raw_corp)
    
    uni_DT <- data.table(end = names(unigrams), count = unigrams)
    uni_DT <- uni_DT[!grepl("_",uni_DT$end)]
    uni_DT <- uni_DT[count > 1]
    uni_DT$Pkn <- uni_DT$count/sum(uni_DT$count)
    setkey(uni_DT)
    
    
    bi_DT <- data.table(ngram = names(bigrams), count = bigrams)
    bi_DT <- bi_DT[!grepl("__",bi_DT$ngram)]
    bi_DT <- bi_DT[count > 1]
    bi_DT[,c("start", "end") := tstrsplit(ngram, "_(?!.*_)", perl = TRUE)]
    setkey(bi_DT)
    A <- bi_DT$count
    B <- uni_DT[bi_DT$start,]$count
    N <- tabulate(bi_DT$count)
    D <- N[1] / (N[1] + 2 * N[2])
    N1plus <- table(bi_DT$start)[bi_DT$start]
    N1plus2 <- table(bi_DT$end)[bi_DT$end]
    N1plus3 <- nrow(bi_DT)
    bi_DT$Pkn <- sapply((A-D),max, 0)/ B + D/B * N1plus * N1plus2/N1plus3
    
    
    tri_DT <- data.table(ngram = names(trigrams), count = trigrams)
    tri_DT <- tri_DT[!grepl("__",tri_DT$ngram)]
    tri_DT <- tri_DT[count > 1]
    tri_DT[,c("start", "end") := tstrsplit(ngram, "_(?!.*_)", perl = TRUE)]
    setkey(tri_DT)
    A <- tri_DT$count
    B <- bi_DT[tri_DT$start,]$count
    N <- tabulate(tri_DT$count)
    D <- N[1] / (N[1] + 2 * N[2])
    N1plus <- table(tri_DT$start)[tri_DT$start]
    bi_pkn <- bi_DT[tri_DT$start,]$Pkn
    tri_DT$Pkn <- sapply((A-D),max, 0)/ B + D/B * N1plus * bi_pkn
    
    save_path <- paste0("Shiny_app/alt_tables/",handle)
    if(!dir.exists("Shiny_app/alt_tables")){
        dir.create("Shiny_app/alt_tables")
    }
    if(!dir.exists(save_path)){
        dir.create(save_path)
    }
    
    saveRDS(uni_DT, paste0(save_path, "/uni_DT.rds"))
    saveRDS(bi_DT, paste0(save_path, "/bi_DT.rds"))
    saveRDS(tri_DT, paste0(save_path, "/tri_DT.rds"))
}

all_tweeters <- c('HillaryClinton',
                'BernieSanders',
                'realDonaldTrump',
                'tedcruz',
                'JohnKasich',
                'rdpeng',
                'jtleek',
                'bcaffo',
                'hspter',
                'hadleywickham',
                'kanyewest',
                'kendricklamar',
                'djkhaled')

for(twit_handle in all_tweeters){
    sorry_future_me(twit_handle)
}
