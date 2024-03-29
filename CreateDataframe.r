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


ATRdf <- ATR(as.matrix(df[,c("High","Low","Close")]), n=14)
ATRdf <- data.frame(ATRdf)
ATRdf <- data.frame(ATRdf$atr)
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

anglesClose <- Slopecalc(df, dfClose, n)
anglesMACD <- Slopecalc(df, dfMACD, n)

df <- tail(df, -(n-1))
df$slopeClose <- anglesClose
df$slopeMACD <- anglesMACD

ADXdf <- data.frame(ADX(as.matrix(df[,c("High","Low","Close")]), n=14))
df$ADX <- ADXdf$ADX
df <- na.omit(df)

RSIdf <- data.frame(RSI(df$Close,14))
df$RSI <- RSIdf$RSI.df.Close..14.
df <- na.omit(df)


WPRdf <- data.frame(WPR(as.matrix(df[,c("High","Low","Close")]), 14))
df$WPR <- WPRdf$x
df <- na.omit(df)

a <- df$Close - df$Low
b <- df$High - df$Low
ab <- data.frame(a/b)
colnames(ab) <- "Stoch"
df$Stoch <- ab$Stoch

bin <- c()

for(i in c(1:nrow(df))){
  if(df$Rets[i] > 0){
    bval <- 1
  }else{
    bval <- 0
  }
  bin <- c(bin, bval)
}

df$BinaryRets <- bin

dfbin_1 <- head(df$BinaryRets,-1)
dfbin_1 <- c(NA, dfbin_1)
df$BinaryRets_1 <- dfbin_1
#df <- na.omit(df)

dfbin_2 <- head(df$BinaryRets,-2)
dfbin_2 <- c(NA,NA, dfbin_2)
df$BinaryRets_2 <- dfbin_2
df <- na.omit(df)

shift <- function(x, n){
  c(x[-(seq(n))], rep(NA, n))
}

df$label <- shift(df$BinaryRets, 1)

write.csv(df, "DataframeEUR_USD.csv")
