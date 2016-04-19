library(data.table)
library(dplyr)
library(stringr)

uni_DT <- readRDS("tables/uni_DT.rds")
bi_DT <- readRDS("tables/bi_DT.rds")
tri_DT <- readRDS("tables/tri_DT.rds")
dirty.words <- readRDS("tables/dirty_words.rds")


# Need to remove punctuation
src_prep <- function(word_list, num_words){
    word_list = word_list[!word_list == ""]
    len = length(word_list)
    word_list[(len-(num_words-1)):len] %>%
        paste(collapse = "_")
}

no_result <- function(word_list){
    if(length(word_list)>2){
        word_list[1:(length(word_list)-1)] %>%
            kn_predictor()
    }else{
        uni_DT[order(-Pkn)][1:20]
    }
}

kn_predictor <- function(input_text, profanity_filter = TRUE){
    input_text = tolower(input_text)
    input_text = gsub("[[:punct:]]",'' , input_text)
    words = unlist(str_split(input_text, ' '))
    # so much faster as data.frame!!
    #uni = uni_DT[ngram == src_prep(words, 1)]
    bi = bi_DT[start == src_prep(words, 1)]
    tri = tri_DT[start == src_prep(words, 2)]
    uni = uni_DT[end %in% c(bi$end,tri$end)]
    uni$Pkn = uni$Pkn * .16
    bi$Pkn = bi$Pkn * .4
    tri$Pkn = tri$Pkn
    pred = rbind(uni,bi,tri, fill=TRUE) %>%
        group_by(end) %>%
        summarise('weight_prob' = sum(Pkn)) %>%
        arrange(desc(weight_prob))
    if(profanity_filter){
        pred = pred[!pred$end %in% dirty.words]
    }
    if(is.na(pred[1]$end)){
        no_result(words)
    }else{
        return(pred)
    }
}


