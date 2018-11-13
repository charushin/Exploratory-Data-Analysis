library(ggplot2)
df = read.table("ILINet.csv",header=TRUE,sep=",")
df = read.table("/Users/kaushik/Desktop/MS CS/Spring 2018/DIC/Lab 1/Lab1EDA/ILINet.csv",header=TRUE,sep=",")
df_reduced = df[(df$YEAR == 2009 & df$WEEK>=40) | df$YEAR > 2009,]

df_reduced$SEASON = ifelse(df_reduced$WEEK<40,paste(df_reduced$YEAR-1,df_reduced$YEAR,sep="-"),paste(df_reduced$YEAR,df_reduced$YEAR+1,sep="-"))

y=append(40:53,1:39)
df_copy = df_reduced
df_copy$WEEK = as.character(df_copy$WEEK)
df_copy$WEEK <- factor(df_copy$WEEK, levels = y)
ggplot(df_copy, aes(x=WEEK,y=X..WEIGHTED.ILI,group=SEASON))+geom_line(aes(color=SEASON))+
  geom_point(aes(color=SEASON))+
  geom_hline(aes(yintercept=2.2, linetype="National Baseline"))+
  scale_linetype_manual(name = "Baseline", values = c(1, 1))+
  ggtitle("Percentage of Visits for Influenza-like-Illness (ILI) Reported by\nthe U.S Outpatient Influenza-like Illness Surveillance Network (ILINET)\nWeekly National Summary, 2017-2018 and selected previous seasons")+
  xlab("Week")+ylab("% of Visits for ILI")

#ggplot(df_reduced, aes(x=WEEK,y=ILITOTAL,group=SEASON))+
#  geom_line(aes(color=SEASON))+geom_point(aes(color=SEASON))

