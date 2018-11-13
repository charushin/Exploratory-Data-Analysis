library(plotly)
df = read.table("National_Custom_Data.csv",header=TRUE,sep=",")
df$SEASONWEEK = paste(df$SEASON,'Week',df$WEEK,sep=" ")
f1 <- list(
  family = "Arial, sans-serif",
  size = 10,
  color = "lightgrey"
)
f2 <- list(
  family = "Old Standard TT, serif",
  size = 10,
  color = "black"
)
a <- list(
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 60,
  tickfont = f2
)
m <- list(l=30, r=20, b=50, t=50)
y=append(40:53,1:39)
df$WEEK <- as.character(df$WEEK)
df$WEEK <- factor(df$WEEK, levels = y)
df$seq_no <- seq(1,nrow(df))
df$seq_no <- factor(df$seq_no,seq(1,nrow(df)))

p=plot_ly(df,x = ~SEASONWEEK, y = ~PERCENT.P.I, name = "Percent PI",type="scatter", mode="lines") %>%
  add_trace(y = ~THRESHOLD, name = "Threshold",type="scatter", mode="lines") %>%
  add_trace(y = ~BASELINE, name = "Baseline",type="scatter", mode="lines") %>%
  layout(title="Pneumonia and Influenza Mortality from\nthe National Center for Health Statistics Mortality Surveillance System\nData",
         yaxis=list(title="% of Deaths due to P&I"),xaxis=list(title="MMWR Week",type="category",categoryorder = "array",categoryarray=df$seq_no,autorange="reversed"),
         legend = list(x = 1.0, y = 0.9),margin=m)
p
