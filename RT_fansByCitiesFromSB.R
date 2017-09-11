library(httr)
library(RCurl)
library(jsonlite)
library(data.table)

j <- k <- 1

ids <- insights_reach_engagement <- insights_fans_city <- insights_fans_gender_age_lifetime <- NULL

myIDs <- myDatas <- myinsights_reach_engagement <- myinsights_fans_city <-
  insights_fans_gender_age_lifetime <- NULL

List <- strsplit("setIDhere",",")


date1 <- "2017-01-01"
date2 <- "2017-01-15" 
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
              metrics = c("insights_fans_city"))
            , encode = "json")

stop_for_status(doc)
jsonData <- content(doc, as = "parsed")

list(jsonData)

length(unlist(List))

profilesCount <- as.numeric(length(jsonData$profiles))

dfs <- lapply(jsonData$profiles, data.frame, stringsAsFactors = FALSE)
test5 <- rbindlist(dfs, fill=TRUE)


while (j <= profilesCount) {
  
  for (k in 1:daysCount){
    
    ids[k] <- toString(unlist(jsonData$profiles[j][[1]]$id))
    
    
  }
  
  myIDs <- append(myIDs,ids)
  
  j = j + 1
}



