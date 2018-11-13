library(plotly)

df = read.table("Influenza Positive Tests Reported to CDC.csv",header=TRUE,sep=",")
m <- list(l=50, r=20, b=80, t=50)
df$Week = as.character(df$Week)
plot_ly(df, x = ~Week, y = ~A.Subtyping.not.performed., type = 'bar', name = 'A(Subtyping not performed)') %>%
  add_trace( y = ~A..H1N1.pdm09, name = "A(H1N1)pdm09",type="bar") %>%
  add_trace( y = ~A.H3N2v., name = "H3N2V",type="bar") %>%
  add_trace( y = ~B, name = "B(Lineage not performed)",type="bar") %>%
  add_trace( y = ~BVIC, name = "B(Victoria Lineage)",type="bar") %>%
  add_trace( y = ~BYAM, name = "B(Yamagata Lineage)",type="bar") %>%
  
  layout(
    title = "Influenza Postive Tests reported to CDC",
    xaxis = list(title="Week"),
    yaxis = list(title="Number of Positive Specimen"),
    barmode = 'stack',
    margin=m
  )



