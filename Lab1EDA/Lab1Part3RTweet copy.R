#Referrences: https://cran.r-project.org/web/packages/rtweet/rtweet.pdf
# https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html

install.packages("rtweet")
install.packages("httpuv")
library(rtweet)
library(httpuv)
app_name <- "Lab1_DIC_0223"
consumer_key <- "CtljJh4AnNSgX2SMEmeAT5zi4"
consumer_secret <- "N13VIcErsmNWuU4FwWRBsM1EtZg1NAnXKUOSPJINIhFQqUkKpO"
access_token <- "75787947-ah5VJZAazd3pnzjeTubrKA8vhiucmtLEGq6QArpcz"
access_secret <- "a5SuYFhw8Ok6tTtDGGk9808yAJ6qKRd9M0rNRcR3m9pa0"

twitter_token <- create_token(
    app = app_name,
    consumer_key = consumer_key,
    consumer_secret = consumer_secret)



## path of home directory
home_directory <- path.expand("~/MS/DIC/tweet_files/")

## combine with name for token
file_name <- file.path(home_directory, "twitter_token.rds")

## save token to home directory
saveRDS(twitter_token, file = file_name)


## Collecting tweets with keywords flu or influenza
flu_tweets <- search_tweets("flu OR influenza", n = 1000, token = twitter_token, lang = "en", geocode = lookup_coords("usa"), retryonratelimit = TRUE)
save_as_csv(flu_tweets, "flu_influenza_tweets_csv.csv", prepend_ids = TRUE, na = "",
            fileEncoding = "UTF-8")

#flu_tweets_df1 <-as.data.frame(flu_tweets)


flu_tweets_df <-read.csv("flu_influenza_tweets_csv.tweets.csv",header = T)

## Collecting user information
#sers_df <- lookup_users(flu_tweets_df$screen_name, parse = TRUE, token = twitter_token)
##           OR
users_df1 <- read.csv("flu_influenza_tweets_csv.users.csv",header = T)

library(ggmap)

## Collecting geocodes for all the users based on the loation
#rtweet_locations1 <- geocode(users_df1$location[1:2500])
rtweet_locations1 <- geocode(users_df1$location[1:100])
#rtweet_locations2 <- geocode(users_df1$location[2501:4900])
rtweet_locations2 <- geocode(users_df1$location[101:200])

## Ignoring all the records with "NA" values
rtweet_locatedUsers1 <- !is.na(rtweet_locations1$lat)
rtweet_loc1 <- as.data.frame(cbind(rtweet_locations1$lon[rtweet_locatedUsers1],rtweet_locations1$lat[rtweet_locatedUsers1]))
rtweet_locatedUsers2 <- !is.na(rtweet_locations2$lat)
rtweet_loc2 <- as.data.frame(cbind(rtweet_locations2$lon[rtweet_locatedUsers2],rtweet_locations2$lat[rtweet_locatedUsers2]))

write.csv(rbind(rtweet_loc1,rtweet_loc2),file="rtweet_loc_df.csv")

rtweet_loc_data_final <- read.csv("rtweet_loc_df.csv",header = T)


rtweet_loc_data2 <- as.data.frame(cbind(rtweet_loc_data_final$V1, rtweet_loc_data_final$V2))
library(sp)
library(maps)
library(maptools)

#to convert from lat-lng pairs to state names
#Referred from "https://stackoverflow.com/questions/8751497/latitude-longitude-coordinates-to-state-code-in-r"
latlong2state <- function(new_df) {
  # Prepare SpatialPolygons object with one SpatialPolygon
  # per state (plus DC, minus HI & AK)
  states <- map('state', fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(states$names, ":"), function(x) x[1])
  states_sp <- map2SpatialPolygons(states, IDs=IDs,
                                   proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Convert pointsDF to a SpatialPoints object 
  pointsSP <- SpatialPoints(new_df, 
                            proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Use 'over' to get _indices_ of the Polygons object containing each point 
  indices <- over(pointsSP, states_sp)
  
  # Return the state names of the Polygons object containing each point
  stateNames <- sapply(states_sp@polygons, function(x) x@ID)
  return(stateNames[indices]) 
}

stNames <- latlong2state(rtweet_loc_data2)

stNames1 <- !is.na(stNames)

state_names <- stNames[stNames1]
new_freq1<-data.frame(table(state_names))
new_freq1

write.csv(new_freq1,file=paste("state_tweet_counts1",Sys.time(),".csv"))

library(ggplot2)
library(fiftystater)

data("fifty_states")
tweetDF <- data.frame(region = tolower(new_freq1$state_names), new_freq1)
p <- ggplot(tweetDF, aes(map_id = region)) + 
  ggtitle("Tweet Count HeatMap for flu, influenza") +
  theme(plot.title = element_text(hjust = 0.5)) +
  # map points to the fifty_states shape data
  geom_map(aes(fill = Freq), map = fifty_states, colour = "white") + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "", fill = "Tweet Counts Grouped by States") +
  theme(legend.position = "right", 
        panel.background = element_blank())

p

