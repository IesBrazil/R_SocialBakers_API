# R Connector to Social Bakers API
# Function to fetch some post's informations like reactions, likes, comments, etc.
# You must pass date1, date2, network and profile ID as parameters.
# Made by Rodrigo Eiras - rsveiras@gmail.com
# 05/09/2017 - Rio de Janeiro / RJ

library(httr)
library(RCurl)
library(jsonlite)
library(data.table)

date1 <- as.Date(date1, "%Y-%m-%d")
date2 <- as.Date(date2, "%Y-%m-%d")

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

parsedToJSON <- toJSON(jsonData)
parsedToR <- fromJSON(parsedToJSON,simplifyVector = TRUE)

postFieldsTable <- as.data.frame(parsedToR, cut.names = TRUE, col.names = names(parsedToJSON))

id <- do.call(rbind, parsedToR$data$posts$id)
created <- do.call(rbind, parsedToR$data$posts$created)
message <- do.call(rbind, parsedToR$data$posts$message)
commentsCount <- do.call(rbind, parsedToR$data$posts$comments_count)
sharesCount <- do.call(rbind, parsedToR$data$posts$shares_count)
reactionsCount <- do.call(rbind, parsedToR$data$posts$reactions_count)
interactionsCount <- do.call(rbind, parsedToR$data$posts$interactions_count)
url <- do.call(rbind, parsedToR$data$posts$url)
authorId <- do.call(rbind, parsedToR$data$posts$author_id)
pageId <- do.call(rbind, parsedToR$data$posts$page_id)
type <- do.call(rbind, parsedToR$data$posts$type)
reactionsLike <- do.call(rbind, parsedToR$data$posts$reactions$like)
reactionsLove <- do.call(rbind, parsedToR$data$posts$reactions$love)
reactionsWow <- do.call(rbind, parsedToR$data$posts$reactions$wow)
reactionsHaha <- do.call(rbind, parsedToR$data$posts$reactions$haha)
reactionsSorry <- do.call(rbind, parsedToR$data$posts$reactions$sorry)
reactionsAnger <- do.call(rbind, parsedToR$data$posts$reactions$anger)
insightsImpressions <- do.call(rbind, parsedToR$data$posts$insights_impressions)
insightsImpressionsPaid <- do.call(rbind, parsedToR$data$posts$insights_impressions_paid)
insightsImpressionsOrganic <- do.call(rbind, parsedToR$data$posts$insights_impressions_organic)
insightsEngagedUsers <- do.call(rbind, parsedToR$data$posts$insights_engaged_users)
insightsVideoAvgTimeWatched <- do.call(rbind, parsedToR$data$posts$insights_video_avg_time_watched)
insightsFanReach <- do.call(rbind, parsedToR$data$posts$insights_fan_reach)
insightsReactionsByTypeTotalLike <- do.call(rbind, parsedToR$data$posts$insights_reactions_by_type_total$like)
insightsReactionsByTypeTotalLove <- do.call(rbind, parsedToR$data$posts$insights_reactions_by_type_total$love)
insightsReactionsByTypeTotalWow <- do.call(rbind, parsedToR$data$posts$insights_reactions_by_type_total$wow)
insightsReactionsByTypeTotalHaha <- do.call(rbind, parsedToR$data$posts$insights_reactions_by_type_total$haha)
insightsReactionsByTypeTotalSorry <- do.call(rbind, parsedToR$data$posts$insights_reactions_by_type_total$sorry)
insightsReactionsByTypeTotalAnger <- do.call(rbind, parsedToR$data$posts$insights_reactions_by_type_total$anger)
insightsVideoCompleteViewsOrganic <- do.call(rbind, parsedToR$data$posts$insights_video_complete_views_organic)
insightsVideoCompleteViewsPaid <- do.call(rbind, parsedToR$data$posts$insights_video_complete_views_paid)
insightsVideoCompleteViews30s <- do.call(rbind, parsedToR$data$posts$insights_video_complete_views_30s)


postsFieldsTable <- data.frame(id,created,message,commentsCount,sharesCount,reactionsCount,interactionsCount,
                               url,authorId,pageId,type,reactionsLike,reactionsLove,reactionsWow,reactionsHaha,reactionsSorry,
                               reactionsAnger,insightsImpressions,insightsImpressionsPaid,insightsImpressionsOrganic,
                               insightsEngagedUsers,insightsVideoAvgTimeWatched,insightsFanReach,insightsReactionsByTypeTotalLike,
                               insightsReactionsByTypeTotalLove,insightsReactionsByTypeTotalWow,insightsReactionsByTypeTotalHaha,
                               insightsReactionsByTypeTotalSorry, insightsReactionsByTypeTotalAnger, insightsVideoCompleteViewsOrganic,
                               insightsVideoCompleteViewsPaid,insightsVideoCompleteViews30s)

