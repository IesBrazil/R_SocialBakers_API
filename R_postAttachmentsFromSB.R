# R Connector to Social Bakers API
# Function to fetch some post attachments informations like URL, images, etc.
# You must pass date1, date2, network and profile ID as parameters.
# Made by Rodrigo Eiras - rsveiras@gmail.com
# 05/09/2017 - Rio de Janeiro / RJ


library(httr)
library(RCurl)
library(jsonlite)
library(data.table)

title <- image_url <- myimage_url <- myIDs <- mytitle <- NULL

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
              fields = c("attachments",
                         "created"))
            , encode = "json")

stop_for_status(doc)
jsonData <- content(doc, as = "parsed")

parsedToJSON <- toJSON(jsonData)
parsedToR <- fromJSON(parsedToJSON,simplifyVector = TRUE)


myAttachments <- data.table(t(sapply(parsedToR$data$posts$attachments, `[`)))

url <- unlist(myAttachments$url)
image_url <- unlist(myAttachments$image_url)
id <- unlist(parsedToR$data$posts$id)

tabelaAnexos <- data.frame(id,url,image_url)

