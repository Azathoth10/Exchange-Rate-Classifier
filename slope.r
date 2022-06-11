Slopecalc <- function(df, tser, n){
  
  if(is.data.frame(tser) == "FALSE"){
    
    print("No good, Your time series should be a dataframe. Transform it!")
  
  }
  
  coeffic <- c()
  x <- c(1:n)
  
  for(i in c((n+1):(nrow(df)+1))){
    
    y <- tser[((i-n):(i-1)),]
    summ <- summary(lm(y~x))
    coeff <- summ$coefficients
    m <- coeff[2,1]
    
    coeffic <- c(coeffic, m)
    
  }
  
  angles <- atan(coeffic)
  df <- tail(df, -(n-1))
  df$slopes <- angles
  
  return(df)
    
  }


