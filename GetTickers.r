library(quantmod)


GetTS <- function(TKS, start){
  
  FirstS <-as.data.frame(lapply(TKs[1], function(x) {getSymbols(x,
                                                                from = start, 
                                                                periodicity = "daily",
                                                                auto.assign=FALSE)} ))
  
  df <- data.frame(FirstS[4])
  
  if( length(TKS) > 1){
    
    for(i in TKs[2:length(TKs)]){
      
      myStocks2 <-as.data.frame(lapply(i, function(x) {getSymbols(x, 
                                                                  from = start, 
                                                                  periodicity = "daily",
                                                                  auto.assign=FALSE)} ))
      
      df <- cbind(df, myStocks2[4])
    
  }
  
    
    
  }
  
  df
  
}
