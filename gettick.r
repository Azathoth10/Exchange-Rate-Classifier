library(quantmod)


GetT <- function(TK, start){
  
  df <-as.data.frame(lapply(TK, function(x) {getSymbols(x,
                                                                from = start, 
                                                                periodicity = "daily",
                                                                auto.assign=FALSE)} ))
}

