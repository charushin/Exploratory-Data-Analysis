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

rt <- search_tweets(
  "lang:en", geocode = lookup_coords("usa"), n = 1000, token = twitter_token
)

flu_tweets <- search_tweets("influenza", n = 2500, token = twitter_token, lang = "en", geocode = lookup_coords("usa"), retryonratelimit = TRUE)


#lat_lng_df<- lat_lng(tweets)
flu_tweets_df <-as.data.frame(flu_tweets)
file_append = Sys.time()
flu_file_name = paste("~/Desktop/MS CS/Spring 2018/DIC/Lab 1/tweet_filess/flu_tweets_df",file_append,".csv")
flu_tweets_df1 <- unlist(flu_tweets_df)
write.csv(flu_tweets_df1,file=flu_file_name)
users_df <- lookup_users(flu_tweets_df$screen_name, parse = TRUE, token = twitter_token)
users_df1 <- unlist(users_df)
write.csv(users_df1,file=paste("~/Desktop/MS CS/Spring 2018/DIC/Lab 1/tweet_files/users_df",Sys.time(),".csv"))
library(ggmap)
rtweet_locations <- geocode(users_df$location)
#latlng_df <-lat_lng(users_df)

rtweet_locatedUsers <- !is.na(rtweet_locations$lat)
rtweet_loc <- as.data.frame(cbind(rtweet_locations$lon[rtweet_locatedUsers],rtweet_locations$lat[rtweet_locatedUsers]))
rtweet_loc1 <- unlist(rtweet_loc)
write.csv(rtweet_loc1,file=paste("~/Desktop/MS CS/Spring 2018/DIC/Lab 1/tweet_files/rtweet_loc_df",Sys.time(),".csv"))

#copy the latlong2state
library(sp)
library(maps)
library(maptools)
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

stNames <- latlong2state(rtweet_loc)

stNames1 <- !is.na(stNames)

state_names <- stNames[stNames1]
new_freq1<-data.frame(table(state_names))
new_freq1

write.csv(new_freq1,file=paste("~/Desktop/MS CS/Spring 2018/DIC/Lab 1/tweet_files/state_tweet_counts",Sys.time(),".csv"))

library(ggplot2)
library(fiftystater)

data("fifty_states")
tweetDF <- data.frame(region = tolower(new_freq1$state_names), new_freq1)
p <- ggplot(tweetDF, aes(map_id = region)) + 
  # map points to the fifty_states shape data
  geom_map(aes(fill = Freq), map = fifty_states, colour = "white") + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "") +
  theme(legend.position = "right", 
        panel.background = element_blank())

p


