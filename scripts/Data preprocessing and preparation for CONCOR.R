install.packages("tidyverse")
install.packages("qdapRegex")
install.packages("quanteda")

library(tidyverse)
library(qdapRegex)
library(quanteda)
library(stopwords)


# Comments preprocessing video 1 --------------------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments1.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video10.csv", row.names = TRUE)


# Comments preprocessing video 2 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments2.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video2.csv", row.names = TRUE)

# Comments preprocessing video 3 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments3.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video3.csv", row.names = TRUE)

# Comments preprocessing video 4 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments4.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video4.csv", row.names = TRUE)

# Comments preprocessing video 5 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments5.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video5.csv", row.names = TRUE)

# Comments preprocessing video 6 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments6.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video6.csv", row.names = TRUE)

# Comments preprocessing video 7 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments7.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video7.csv", row.names = TRUE)

# Comments preprocessing video 8 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments8.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video8.csv", row.names = TRUE)

# Comments preprocessing video 9 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments9.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video9.csv", row.names = TRUE)

# Comments preprocessing video 10 ------------------------------------------


# Load the comment data
comments <- read.csv("/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments10.csv")

#DATA CLEANING STAGE 1
tidy_comments <- comments %>% 
  # remove unnecessary whitespaces and create the new column "text_clean" that is used once and then dragged along
  mutate(text_clean = str_trim(comment_text, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # all text to lower case
  mutate(text_clean = str_to_lower(text_clean, locale = "en")) %>% 
  # remove URLs
  mutate(text_clean = rm_url(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # replace apostrophes
  mutate(text_clean = str_replace_all(text_clean, "'", replacement = "")) %>% 
  # replace answers to user indicated by @
  mutate(text_clean = str_replace_all(text_clean, pattern = "@\\S+", replacement = "username")) %>% 
  # remove emojis and other special characters through removing everything non-word
  mutate(text_clean = qdapRegex::rm_non_words(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove non-ascii letters like Chinese signs etc. 
  mutate(text_clean = qdapRegex::rm_non_ascii(text_clean, trim = TRUE, clean = TRUE)) %>% 
  # remove single letters that now might have emerged
  mutate(text_clean = str_remove_all(text_clean, pattern = "\\b(\\w)\\b")) %>% 
  # remove unnecessary whitespaces again
  mutate(text_clean = str_trim(text_clean, side = "both")) %>% 
  mutate(text_clean = str_squish(text_clean)) %>% 
  # bring the new text_clean column to the front
  relocate(text_clean, .after = comment_text) %>% 
  # remove texts that are now empty because they were e.g. only emojis
  mutate(text_clean = na_if(text_clean, "")) %>% 
  drop_na(text_clean)


#DATA CLEANING STAGE 2
custom_stopwords <- 
  tibble(word = c(
    # English
    data_stopwords_marimo$en[["pronoun"]][["basic"]], 
    data_stopwords_marimo$en[["pronoun"]][["possessive"]], 
    data_stopwords_marimo$en[["pronoun"]][["interrogative"]],
    data_stopwords_marimo$en[["verb"]][["basic"]], 
    data_stopwords_marimo$en[["verb"]][["modal"]], 
    data_stopwords_marimo$en[["verb"]][["contraction"]], 
    data_stopwords_marimo$en[["article"]], 
    data_stopwords_marimo$en[["conjunction"]], 
    data_stopwords_marimo$en[["adverb"]], 
    data_stopwords_marimo$en[["preposition"]], 
    data_stopwords_nltk$en,
    data_stopwords_snowball$en,
    data_stopwords_stopwordsiso$en,
    data_stopwords_smart$en, 
    # Custom words
    c("username"))) %>% 
  distinct()

# Creation of the tokenized data without stop words
tidy_comments_clean <- tidy_comments %>% 
  select(comment_author, comment_date, text_clean) %>% 
  unnest_tokens(input = text_clean, output = word, token = "words") %>% 
  anti_join(custom_stopwords, by = "word")


#DATA PREPARATION FOR CONCOR ANALYSIS

# Get the top 50 words from the text_clean$word column
top_words <- tidy_comments_clean$word %>%
  tokens() %>%
  dfm() %>%
  dfm_weight() %>% 
  topfeatures(50) %>%
  names

# Create DTM, prune vocabulary and set binary values for presence/absence of the top words
binDTM <- tidy_comments$text_clean %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 5) %>% 
  dfm_select(top_words, selection = "keep") %>%
  dfm_weight("boolean")

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

#Save co-occurence matrix for CONCOR analysis
write.csv(as.matrix(coocCounts), file = "video10.csv", row.names = TRUE)