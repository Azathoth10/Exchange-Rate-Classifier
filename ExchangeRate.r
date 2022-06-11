source("GetTickers.r")
source("gettick.r")
source("rets.r")
source('slope.r')
library(dplyr)
library(pracma)

TK <- c("GBPUSD=x")

start <- c("2000-01-01")

colsIlike <- c("GBPUSD.X.High","GBPUSD.X.Low", "GBPUSD.X.Close")

df <- GetT(TK, start)
df <- df[, colsIlike]

df <- na.omit(df)
sum(is.na(df))
nrow(df)

dfClose <- data.frame(df$GBPUSD.X.Close)
df <- tail(df, -1)

sum(is.na(df[1]))

dfr <- Calc_rets(dfClose)
df$Rets <- dfr$df.GBPUSD.X.Close

colnames(df) <- c("High", "Low", "Close","Rets")
head(df)


ATRdf <- ATR(df[,c("High","Low","Close")], n=14)
ATRdf <- data.frame(ATRdf)
ATRdf <- ATRdf$atr
naatr <- sum(is.na(ATRdf[1]))
ATRdf <- na.omit(ATRdf)
ATRdf <- data.frame(ATRdf)

df <- tail(df, -naatr)

df$ATR <- ATRdf$ATRdf


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

dfMACD <- data.frame(df$diffMACD)

df <- Slopecalc(df, dfClose, n)
df <- Slopecalc(df, dfMACD, n)



