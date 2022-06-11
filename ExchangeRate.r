source("GetTickers.r")
source("gettick.r")
source("rets.r")
source('slope.r')
library(dplyr)
library(pracma)

TK <- c("GBPUSD=x")

start <- c("2000-01-01")

df <- GetT(TK, start)

df[]

df <- na.omit(df)
sum(is.na(df))
nrow(df)

sum(is.na(df[1]))

df <- Calc_rets(df)

colnames(df) <- c("Close", "Rets")

df$EWM_FAST <- movavg(df$Close , n<-12, type='e')
df <- tail(df, -n)
df$EWM_SLOW <- movavg(df$Close , n<-26, type='e')
df <- tail(df, -n)
df$MACD <- df$EWM_FAST - df$EWM_SLOW
df$signal <- movavg(df$MACD , n<-9, type='e')
df <- tail(df, -n)
df$diffMACD <- df$MACD - df$signal

df$EMA_10 <- movavg(df$MACD , n<-10, type='e')
df <- tail(df, -n)
df$EMA_20 <- movavg(df$MACD , n<-20, type='e')
df <- tail(df, -n)
df$EMA_50 <- movavg(df$MACD , n<-50, type='e')
df <- tail(df, -n)

df$SMA_10 <- movavg(df$MACD , n<-10, type='s')
df <- tail(df, -n)
df$SMA_20 <- movavg(df$MACD , n<-20, type='s')
df <- tail(df, -n)
df$SMA_50 <- movavg(df$MACD , n<-50, type='s')
df <- tail(df, -n)


n = 5

dfClose <- data.frame(df$Close)
dfMACD <- data.frame(df$diffMACD)

df <- Slopecalc(df, dfClose, n)
df <- Slopecalc(df, dfMACD, n)



