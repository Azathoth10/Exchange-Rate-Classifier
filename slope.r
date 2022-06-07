Slopecalc <- function(df, tser, n){
  
  coeffic <- c()
  dff <- data.frame(tser)
  x <- c(1:n)
  for(i in c((n+1):(nrow(dff)+1))){
    
    y <- as.numeric(dff[(i-n):(i-1),])
    cff <- as.numeric(as.matrix(summary(lm(y~x))$coefficients)[2,1])
    coeffic <- c(coeffic, cff)
    
    print(cff)
    
    
  df <- tail(df, -(n-1))
  angles <- atan(coeffic)
  df$slopes <- coeffic
  
  return(df)

    
  }
  
}

