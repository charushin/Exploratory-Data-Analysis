install.packages("twitteR")
install.packages("RCurl")
install.packages("httr")
require(twitteR)
require(RCurl)

consumer_key <- "CtljJh4AnNSgX2SMEmeAT5zi4"
consumer_secret <- "N13VIcErsmNWuU4FwWRBsM1EtZg1NAnXKUOSPJINIhFQqUkKpO"
access_token <- "75787947-ah5VJZAazd3pnzjeTubrKA8vhiucmtLEGq6QArpcz"
access_secret <- "a5SuYFhw8Ok6tTtDGGk9808yAJ6qKRd9M0rNRcR3m9pa0"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

tw_temp = twitteR::searchTwitter('flu', n = 500, since = '2018-02-01', until = '2018-02-20',lang = 'en',retryOnRateLimit = 1e3)
#tw3 = twitteR::searchTwitter('#flu', n = 2000, since = '2018-02-01', until = '2018-02-20',lang = 'en',retryOnRateLimit = 1e3)
d_temp = twitteR::twListToDF(tw_temp)
#d1 = twitteR::twListToDF(tw)
#d3= twitteR::twListToDF(tw3)
#tw = twitteR::searchTwitter('flu', n = 5000, since = '2018-02-01', retryOnRateLimit = 1e3)

userInfo <- lookupUsers(d_temp$screenName)  # Batch lookup of user info
userFrame <- twListToDF(userInfo)  # Convert to a nice dF

locatedUsers <- !is.na(userFrame$location)  # Keep only users with location info
require(ggplot2)
require(maps)
require(ggmap)
userFrame$location<-iconv(userFrame$location, "ASCII", "UTF-8", sub="")
locations <- geocode(userFrame$location[locatedUsers])


#geocode(userFrame$location[locatedUsers], output = "more", messaging = FALSE,override_limit = TRUE, client = "", signature = "", nameType = c("long", "short"))

#geocodeQueryCheck(userType = "business")

with(locations, plot(lon, lat))

worldMap <- map_data("world")  # Easiest way to grab a world map shapefile

zp1 <- ggplot(worldMap)
zp1 <- zp1 + geom_path(aes(x = long, y = lat, group = group),  # Draw map
                       colour = gray(2/3), lwd = 1/3)
zp1 <- zp1 + geom_point(data = locations,  # Add points indicating users
                        aes(x = locations$lon, y = locations$lat),
                        colour = "RED", alpha = 1/2, size = 1)
zp1 <- zp1 + coord_equal()  # Better projections are left for a future post
zp1 <- zp1 + theme_minimal()  # Drop background annotations
print(zp1)
