# install the tuber package
install.packages('tuber')

# load the tuber package
library(tuber)

# store the name of your Client ID in app_name variable 
app_id <- "INSERT YOUR APP ID"
# store the Client secret in the app_secret variable 
app_secret <- "INSERT YOUR APP SECRET"

# authorize your app
yt_oauth(app_id, app_secret)



# Parsing comments video 1 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "LxgMdjyw8uw")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments1.csv", row.names = FALSE)

# Parsing comments video 2 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "y564PsKvNZs")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments2.csv", row.names = FALSE)


# Parsing comments video 3 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "ldLBoErAhz4")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments3.csv", row.names = FALSE)


# Parsing comments video 4 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "OWXoRSIxyIU")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments4.csv", row.names = FALSE)


# Parsing comments video 5 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "vpTHi7O66pI")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments5.csv", row.names = FALSE)


# Parsing comments video 6 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "G4H1N_yXBiA")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments6.csv", row.names = FALSE)


# Parsing comments video 7 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "uynhvHZUOOo")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments7.csv", row.names = FALSE)


# Parsing comments video 8 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "NjlC02NsIt0")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments8.csv", row.names = FALSE)


# Parsing comments video 9 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "TbW_1MtC2So")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments9.csv", row.names = FALSE)


# Parsing comments video 10 ------------------------------------------------


# get the comments for the certain video by its video ID using the tuber package
comments <- get_all_comments(video_id = "m3hHi4sylxE")

# Create a data frame with the comments and their parameters
comments_df <- data.frame(comment_author = comments$authorDisplayName,
                          comment_date = comments$publishedAt,
                          comment_text = comments$textOriginal,
                          stringsAsFactors = FALSE)

# Export the data frame to a CSV file
write.csv(comments_df, "/Users/egorpovarnicyn/Desktop/Диплом - Master/1. Datasets_comments_full/masteR/comments10.csv", row.names = FALSE)
