Calc_rets <- function(df){
  
  data <- data.frame(c(2:nrow(df)-1))
  colnames(data) <- "To_remove"
  for(i in colnames(df)[1:length(colnames(df))]){
    v = as.vector(unlist(df[i]))
    vr = diff(v)/(v[-length(v)])
    data[i] <- vr
  }
  data$To_remove <- NULL
  df2 <- df[-1, ]
  dataEX <- cbind(df2, data)
  
  dataEX
  
}