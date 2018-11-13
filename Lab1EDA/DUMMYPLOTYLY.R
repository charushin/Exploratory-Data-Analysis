library(plotly)
packageVersion('plotly')

df = read.table("ILINet.csv",header=TRUE,sep=",")
#df = read.table("/Users/kaushik/Desktop/MS CS/Spring 2018/DIC/Lab 1/Lab1EDA/ILINet.csv",header=TRUE,sep=",")
df_reduced = df[(df$YEAR == 2009 & df$WEEK>=40) | df$YEAR > 2009,]

d = data.frame(1:5,2*(5:1),20*(1:5))
ay <- list(
  tickfont = list(color = "red"),
  overlaying = "y",
  side = "right",
  title = "second y axis"
)


plot_ly(df, x=~YEAR) %>%
  add_lines(y = ~TOTAL.PATIENTS, name = "TOTAL.PATIENTS") %>%
  add_lines(y = ~NUM..OF.PROVIDERS, name = "NUM..OF.PROVIDERS",yaxis=ay) %>%
  layout(
    title = "Double Y Axis", yaxis2 = ay,
    xaxis = list(title="x")
  )


