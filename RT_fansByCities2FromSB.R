library(httr)
library(RCurl)
library(jsonlite)
#library(data.table)
#library(plyr)
#library(stringi)

j <- k <- 1

ids <- datas <- insights_fans_city <- cities <- NULL

myIDs <- myDatas <- myCities <- myinsights_fans_city <- NULL

List <- strsplit("setID1here,setID2here",",")


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
              metrics = c("insights_fans_city","insights_reach_engagement"))
            , encode = "json")

stop_for_status(doc)
jsonData <- content(doc, as = "parsed")


profilesCount <- as.numeric(length(jsonData$profiles))

parsedToJSON <- toJSON(jsonData)
parsedToR <- fromJSON(parsedToJSON,simplifyVector = TRUE)

for(j in 1:profilesCount) {
  
  for(k in 1:daysCount){
    ids <- unlist(parsedToR$profiles$id[[j]])
    datas <- unlist(parsedToR$profiles$data[[j]]$date[[k]])
    insights_fans_city <- unlist(parsedToR$profiles$data[[j]]$insights_fans_city)
    cities <- names(unlist(parsedToR$profiles$data[[j]]$insights_fans_city))
    
    myIDs <- append(myIDs,ids)
    myDatas <- append(myDatas,datas)
    myinsights_fans_city <- append(myinsights_fans_city,insights_fans_city)
    myCities <- append(myCities,cities)
    
    
  }
}

Encoding(myCities) <- "ISO-8859-1"
insights_fans_cityDT <- data.frame(myIDs,myCities,myDatas,myinsights_fans_city)


