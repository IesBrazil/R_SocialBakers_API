# R Connector to Social Bakers API
# Function to fetch some profile metrics like commentsCount, sharesCount, reacheEngagement, etc.
# You must pass date1, date2, network and profile ID as parameters.
# Made by Rodrigo Eiras - rsveiras@gmail.com
# 05/09/2017 - Rio de Janeiro / RJ

library(httr)
library(RCurl)
library(jsonlite)

j <- 1
k <- 1

ids <- datas <- fans_count_lifetime <- comments_count <- interactions_count <- 
  page_posts_count <- reactions_count <- shares_count <- insights_video_views <- insights_impressions_paid_unique <-
  insights_reach_engagement <- insights_fans_lifetime <- insights_video_views_paid <- insights_impressions_organic_unique <-
  insights_impressions <- insights_impressions_unique <- insights_video_complete_views_30s <- insights_impressions_organic <- insights_impressions_paid <- insights_reactions_count <- NULL

myIDs <- myDatas <- myfans_count_lifetime <- mycomments_count <- myinteractions_count <- myinsights_impressions_organic_unique <-
  mypage_posts_count <- myreactions_count <- myshares_count <- myinsights_video_views_paid <-
  myinsights_reach_engagement <- myinsights_fans_lifetime <- myinsights_video_views <- myinsights_impressions_paid_unique <-
  myinsights_impressions <- myinsights_impressions_unique <- myinsights_video_complete_views_30s <- myinsights_impressions_organic <- myinsights_impressions_paid <- myinsights_reactions_count <- NULL

List <- strsplit("setID1here,setID2here",",")


date1 <- as.Date(date1, "%Y-%m-%d")
date2 <- as.Date(date2, "%Y-%m-%d")
daysCount <- as.numeric(difftime(date2,date1,units = "days")) + 1

login <- "login"
secret <- "passwd"
baseURL <- paste0("https://api.socialbakers.com/0/",network,"/metrics")

doc <- POST(baseURL,
            authenticate(login,
                         secret,
                         type = "basic"), 
            body = list(
              date_start = date1,
              date_end = date2,
              profiles = if (length(unlist(List)) > 1) {
                unlist(List)
              } else {
                List
              },
              metrics = c("fans_count_lifetime", "insights_video_views_paid", "insights_impressions_organic_unique","insights_video_views", "insights_video_complete_views_30s",
                          "insights_impressions_paid", "insights_impressions_paid_unique",
                          "insights_impressions_unique", "insights_impressions_organic", "insights_impressions",
                          "comments_count", "interactions_count", "page_posts_count", "reactions_count", "shares_count",
                          "insights_reach_engagement", "insights_fans_lifetime" , "insights_reactions_count"))
            , encode = "json")

stop_for_status(doc)
jsonData <- content(doc, as = "parsed")

print(jsonData)

length(unlist(List))

profilesCount <- as.numeric(length(jsonData$profiles))

while (j <= profilesCount) {
  
  for (k in 1:daysCount){
    
    ids[k] <- toString(unlist(jsonData$profiles[j][[1]]$id))
    datas[k] <- unlist(jsonData$profiles[[j]]$data[[k]]$date)
    fans_count_lifetime[k] <- as.numeric(unlist(jsonData$profiles[j][[1]]$data[[k]]$fans_count_lifetime))
    comments_count[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$comments_count))
    interactions_count[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$interactions_count))
    page_posts_count[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$page_posts_count))
    reactions_count[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$reactions_count))
    shares_count[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$shares_count))
    insights_reach_engagement[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_reach_engagement))
    insights_fans_lifetime[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_fans_lifetime))
    insights_impressions[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_impressions))
    insights_impressions_unique[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_impressions_unique))
    insights_impressions_organic[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_impressions_organic))
    insights_impressions_paid[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_impressions_paid))
    insights_reactions_count[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_reactions_count))
    insights_video_complete_views_30s[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_video_complete_views_30s))
    insights_video_views[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_video_views))
    insights_video_views_paid[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_video_views_paid))
    insights_impressions_organic_unique[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_impressions_organic_unique))
    insights_impressions_paid_unique[k] <- toString(unlist(jsonData$profiles[j][[1]]$data[[k]]$insights_impressions_paid_unique))
  }
  
  myIDs <- append(myIDs,ids)
  myDatas <- append(myDatas,datas)
  myfans_count_lifetime <- as.integer(append(myfans_count_lifetime,fans_count_lifetime))
  mycomments_count <- as.integer(append(mycomments_count,comments_count))
  myinteractions_count <- as.integer(append(myinteractions_count,interactions_count))
  mypage_posts_count <- as.integer(append(mypage_posts_count,page_posts_count))
  myreactions_count <- as.integer(append(myreactions_count,reactions_count))
  myshares_count <- as.integer(append(myshares_count,shares_count))
  myinsights_reach_engagement <- as.numeric(append(myinsights_reach_engagement,insights_reach_engagement))
  myinsights_fans_lifetime <- as.integer(append(myinsights_fans_lifetime,insights_fans_lifetime))
  myinsights_impressions <- as.integer(append(myinsights_impressions,insights_impressions))
  myinsights_impressions_unique <- as.integer(append(myinsights_impressions_unique,insights_impressions_unique))
  myinsights_impressions_organic <- as.integer(append(myinsights_impressions_organic,insights_impressions_organic))
  myinsights_impressions_paid <- as.integer(append(myinsights_impressions_paid,insights_impressions_paid))
  myinsights_reactions_count <- as.integer(append(myinsights_reactions_count,insights_reactions_count))
  myinsights_video_complete_views_30s <- as.integer(append(myinsights_video_complete_views_30s,insights_video_complete_views_30s))
  myinsights_video_views <- as.integer(append(myinsights_video_views,insights_video_views))
  myinsights_video_views_paid <- as.integer(append(myinsights_video_views_paid,insights_video_views_paid))
  myinsights_impressions_organic_unique <- as.integer(append(myinsights_impressions_organic_unique,insights_impressions_organic_unique))
  myinsights_impressions_paid_unique <- as.integer(append(myinsights_impressions_paid_unique,insights_impressions_paid_unique))
  
  j = j + 1
  
}


metricsTable <- data.frame(id = myIDs, Data = myDatas, fans_count_lifetime = myfans_count_lifetime,  comments_count = mycomments_count, 
                           interactions_count = myinteractions_count, page_posts_count= mypage_posts_count, reactions_count = myreactions_count, 
                           shares_count = myshares_count, insights_reach_engagement = myinsights_reach_engagement, 
                           insights_fans_lifetime = myinsights_fans_lifetime, insights_impressions = myinsights_impressions, 
                           insights_impressions_unique = myinsights_impressions_unique, insights_video_complete_views_30s = myinsights_video_complete_views_30s, insights_impressions_paid_unique = myinsights_impressions_paid_unique,
                           insights_impressions_organic = myinsights_impressions_organic, insights_impressions_paid = myinsights_impressions_paid, insights_reactions_count = myinsights_reactions_count,
                           insights_video_views = myinsights_video_views,insights_video_views_paid = myinsights_video_views_paid, insights_impressions_organic_unique = myinsights_impressions_organic_unique)


