source("GetTickers.r")
source("rets.r")
library(dplyr)
library(pracma)

TKs <- c("GBPUSD=x")

start <- c("2014-01-01")

df <- GetTS(TKs, start)

df <- na.omit(df)
sum(is.na(df))
nrow(df)

sum(is.na(df[1]))

df <- Calc_rets(df)

colnames(df) <- c("Close, Rets")

df$EWM_FAST <- movavg(df$Close , n=12, type='e')
df$EWM_SLOW <- movavg(df$Close , n=26, type='e')
df$MACD <- df$EWM_FAST - df$EWM_SLOW
df$signal <- movavg(df$MACD , n=9, type='e')
df$diffMACD <- df$MACD - df$signal
