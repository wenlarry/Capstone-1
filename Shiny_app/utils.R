library(stringr)

uni_DT <- readRDS("tables/uni_DT.rds")
bi_DT <- readRDS("tables/bi_DT.rds")
tri_DT <- readRDS("tables/tri_DT.rds")


# Need to remove punctuation
src_prep <- function(word_list, num_words){
    word_list = word_list[!word_list == ""]
    len = length(word_list)
    word_list[(len-(num_words-1)):len] %>%
        paste(collapse = "_")
}

kn_predictor <- function(input_text){
    input_text = tolower(input_text)
    words = unlist(str_split(input_text, ' '))
    uni = uni_DT[uni_DT$ngram == src_prep(words, 1)]
    bi = bi_DT[bi_DT$start == src_prep(words, 1),]
    tri = tri_DT[tri_DT$start == src_prep(words, 2),]
    #quad = quad_probs[quad_probs$start == src_prep(words, 3),]
    uni$Pkn = uni$Pkn * .16
    bi$Pkn = bi$Pkn * .4
    tri$Pkn = tri$Pkn
    #quad$prob = quad$prob
    pred = rbind(uni,bi,tri, fill=TRUE) %>%
        group_by(end) %>%
        summarise('weight_prob' = sum(Pkn)) %>%
        arrange(desc(weight_prob))
    pred
}


