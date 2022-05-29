source("GetTickers.r")
source("rets.r")
library(dplyr)
library(pracma)

TKs <- c("GBPUSD=x")
start <- c("2020-01-01")

df <- GetTS(TKs, start)

df <- Calc_rets(df)

colnames(df) <- c("Close, Rets")

df$EWM_4day <- movavg(df$Close , n=12, type='e')
