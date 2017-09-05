# R Connector to Social Bakers API
# Function to fetch all registered profiles
# In this function you set variable to fetch a different network from Social Bakers.
## in my case, i only need facebook.
# Made by Rodrigo Eiras - rsveiras@gmail.com
# 05/09/2017 - Rio de Janeiro / RJ

library(httr)
library(RCurl)
library(jsonlite)

j <- NULL
ids <- NULL
name <- NULL
profileName <- NULL
timezone <- NULL

req <- GET("https://api.socialbakers.com/0/facebook/profiles", 
           authenticate("login",
                        "passwd",
                        type = "basic"),
           encode = "json")

stop_for_status(req)
data <- content(req, as = "parsed")


for(j in 1:length(data$profiles)){
  
  ids[j] <- toString(unlist(data$profiles[j][[1]]$id))
  name[j] <- toString(unlist(data$profiles[j][[1]]$name))
  profileName[j] <- toString(unlist(data$profiles[j][[1]]$profileName))
  timezone[j] <- toString(unlist(data$profiles[j][[1]]$timezone))
}

profilesTable <- data.frame(id = ids, name, profileName, timezone)
