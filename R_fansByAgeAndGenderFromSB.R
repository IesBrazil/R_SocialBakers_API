# R Connector to Social Bakers API
# Function to fetch gender and age from fans who like the page. Must have insights connected at SocialBakers platform.
# In this function you can set variable to fetch a different network from Social Bakers.
## in my case, i only need facebook.
# Made by Rodrigo Eiras - rsveiras@gmail.com
# 05/09/2017 - Rio de Janeiro / RJ

library(httr)
library(RCurl)
library(jsonlite)

j <- k <- 1

ids <- datas <- insights_fans_gender_age_lifetime <- gender_age <- NULL

myIDs <- myDatas <- mygender_age <- myinsights_fans_gender_age_lifetime <- NULL

List <- strsplit("setIDhere",",")



date1 <- as.Date(date1, "%Y-%m-%d")
date2 <- as.Date(date2, "%Y-%m-%d")
daysCount <- as.numeric(difftime(date2,date1,units = "days")) + 1


doc <- POST("https://api.socialbakers.com/0/facebook/metrics",
            authenticate("login",
                         "passwd",
                         type = "basic"), 
            body = list(
              date_start = date1,
              date_end = date2,
              profiles = if (length(unlist(List)) > 1) {
                unlist(List)
              } else {
                List
              },
              metrics = c("insights_fans_gender_age_lifetime","insights_reach_engagement"))
            , encode = "json")

stop_for_status(doc)
jsonData <- content(doc, as = "parsed")


profilesCount <- as.numeric(length(jsonData$profiles))

parsedToJSON <- toJSON(jsonData)
parsedToR <- fromJSON(parsedToJSON,simplifyVector = TRUE)

for(j in 1:profilesCount) {
  
  for(k in 1:daysCount){
    ids <- unlist(parsedToR$profiles$id[[j]])
    datas[k] <- unlist(parsedToR$profiles$data[[j]]$date[[k]])
    insights_fans_gender_age_lifetime <- unlist(parsedToR$profiles$data[[j]]$insights_fans_gender_age_lifetime)
    gender_age <- names(unlist(parsedToR$profiles$data[[j]]$insights_fans_gender_age_lifetime))
    
  }
  
  myIDs <- append(myIDs,ids)
  myDatas <- append(myDatas,datas)
  myinsights_fans_gender_age_lifetime <- append(myinsights_fans_gender_age_lifetime,insights_fans_gender_age_lifetime)
  mygender_age <- append(mygender_age,gender_age)
  
}

Encoding(mygender_age) <- "ISO-8859-1"
insights_fans_gender_age_lifetimeDT <- data.frame(myIDs,mygender_age,myDatas,myinsights_fans_gender_age_lifetime)


