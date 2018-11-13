
cdc_data = read.csv(file.choose(), header = T)
library(ggplot2)
library(fiftystater)

data("fifty_states")
cdc_df <- data.frame(state = tolower(cdc_data$STATENAME), cdc_data)
p <- ggplot(cdc_df, aes(map_id = state)) + 
  # map points to the fifty_states shape data
  geom_map(aes(fill = ACTIVITY.LEVEL), map = fifty_states) + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "") +
  theme(legend.position = "right", 
        panel.background = element_blank())

p
# add border boxes to AK/HI
p + fifty_states_inset_boxes() 

#install.packages("colorplaner")
#library(colorplaner)
#p + aes(fill2 = UrbanPop) + scale_fill_colorplane() +
 # theme(legend.position = "right")


library(ggplot2)
library(maps)
#states <- map_data("state")
fifty_data <- data("fifty_states")
map.df <- merge(fifty_states,cdc_data, x.by = id, y.by = state)
map.df <- map.df[order(map.df$order),]
ggplot(map.df, aes(x=long,y=lat,group=group))+
  geom_polygon(aes(fill=ACTIVITY.LEVEL))+
  geom_path()+ 
  scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey90")+
  coord_map()
