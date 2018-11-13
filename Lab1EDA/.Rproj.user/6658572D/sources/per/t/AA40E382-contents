library(plotly)
df = read.table("PedFluDeath_WeeklyData.csv",header=TRUE,sep=",")
m = list(line = list(color = 'rgb(8,48,107)',
                          width = 0.5))
plot_ly(df, x = ~WEEK.NUMBER, y = ~CURRENT.WEEK.DEATHS, type = 'bar', name = 'Current Week',marker=m) %>%
  add_trace( y = ~PREVIOUS.WEEKS.DEATHS, name = "Previous Week",type="bar") %>%
  layout(
    title = "Number of Influenza affected pediatric deaths by Week of Death",
    xaxis = list(title="Week of Death"),
    yaxis = list(title="Number of Deaths"),
    barmode = 'stack'
  )