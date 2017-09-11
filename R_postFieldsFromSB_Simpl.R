# R Connector to Social Bakers API
# Function to fetch some post's informations like reactions, likes, comments, etc.
## Simplified version, but may not work in Spotfire and Statistics Service. Good enough for RStudio.
# You must pass date1, date2, network and profile ID as parameters.
# Made by Rodrigo Eiras - rsveiras@gmail.com
# 05/09/2017 - Rio de Janeiro / RJ

library(httr)
library(RCurl)
library(jsonlite)

date1 <- as.Date(date1, "%Y-%m-%d")
date2 <- as.Date(date2, "%Y-%m-%d")
daysCount <- as.numeric(difftime(date2,date1,units = "days")) + 1
network <- "facebook"

login <- "login"
secret <- "passwd"
baseURL <- paste0("https://api.socialbakers.com/0/",network,"/page/posts")

doc <- POST(baseURL,
            authenticate(login,
                         secret,
                         type = "basic"), 
            body = list(
              date_start = date1,
              date_end = date2,
              profile = profile,
              fields = c("id",
                         "created",
                         "message",
                         "comments_count",
                         "shares_count",
                         "reactions_count",
                         "interactions_count",
                         "url",
                         "author_id",
                         "page_id",
                         "type",
                         "reactions",
                         "story",
                         "insights_impressions",
                         "insights_impressions_paid",
                         "insights_engaged_users",
                         "insights_video_avg_time_watched",
                         "insights_fan_reach",
                         "insights_impressions_organic",
                         "insights_reactions_by_type_total",
                         "insights_video_complete_views_30s",
                         "insights_video_complete_views_organic",
                         "insights_video_complete_views_paid"))
            , encode = "json")

stop_for_status(doc)
jsonData <- content(doc, as = "parsed")

print(jsonData)

postsCount <- as.numeric(length(jsonData$data$posts))

parsedToJSON <- toJSON(jsonData)
parsedToR <- fromJSON(parsedToJSON,simplifyVector = TRUE)



postFieldsTable <- as.data.frame(parsedToR)
