library(plotly)
ay <- list(
  tickfont = list(color = "black"),
  overlaying = "y",
  side = "right",
  title = "Percent Positive"
)
m <- list(l=50, r=50, b=80, t=30)
df = read.table("Influenza_Positive _Tests.csv",header=TRUE,sep=",")

df$Week = as.character(df$Week)
plot_ly(df, x = ~Week, y = ~Total.A, type = 'bar', name = 'A') %>%
  add_trace( y = ~Total.B, name = "B",type="bar") %>%
  add_trace( y = ~X..Positive, name = "Percent Positive", yaxis = "y2",type="scatter",mode="lines") %>%
  add_trace( y = ~Percent.Positive.A, name = "% Positive Flu A", yaxis = "y2",type="scatter",mode="lines") %>%
  add_trace( y = ~Percent.Positive.B, name = "% Positive Flu B", yaxis = "y2",type="scatter",mode="lines") %>%
  
  layout(
        title = "Influenza Postive Tests reported to CDC", yaxis2 = ay,
        xaxis = list(title="Week"),
        yaxis = list(title="Number of Positive Specimen"),
        barmode = 'stack',
        legend = list(x = 0.1, y = 0.9),
        margin=m
      )



