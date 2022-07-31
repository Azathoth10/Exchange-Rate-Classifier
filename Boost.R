#install.packages('xgboost')
#install.packages('xgboost')     # for fitting the xgboost model
#install.packages('caret')       # for general data preparation and model fitting
##install.packages('e1071')
#install.packages("recipes")
#install.packages("Rcpp")
library(xgboost)
library(e1071) 
library(pROC)
#library(caret)

df <- read.csv("DataframeEUR_USD.csv")

split1<- sample(c(rep(0, 0.7 * nrow(df)), rep(1, 0.3 * nrow(df))))
train <- df[split1 == 0, ]   
test <- df[split1== 1, ] 

X_train = data.matrix(train[,-25])                  # independent variables for train
y_train = train[,25]                                # dependent variables for train

X_test = data.matrix(test[,-25])                    # independent variables for test
y_test = test[,25]                                   # dependent variables for test

# convert the train and test data into xgboost matrix type.
xgboost_train = xgb.DMatrix(data=X_train, label=y_train)
xgboost_test = xgb.DMatrix(data=X_test, label=y_test)

model <- xgboost(data = xgboost_train,                    # the data   
                 max.depth=3,                           # max depth 
                 nrounds=50)                             # max number of boosting iterations

summary(model)
pred_test = predict(model, xgboost_test)
pred_test[(pred_test>3)] = 3
pred_y = as.factor((levels(y_test))[round(pred_test)])
print(pred_y)

pROC_obj <- roc(y_test,pred_test,
                smoothed = TRUE,
                # arguments for ci
                ci=TRUE, ci.alpha=0.9, stratified=FALSE,
                # arguments for plot
                plot=TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
                print.auc=TRUE, show.thres=TRUE)


sens.ci <- ci.se(pROC_obj)
plot(sens.ci, type="shape", col="lightblue")
## Warning in plot.ci.se(sens.ci, type = "shape", col = "lightblue"): Low
## definition shape.
plot(sens.ci, type="bars")
library(data.table)
df<- data.table(data.frame(pred_test, y_test))
dfsel <- df[pred_test>0.80,]
dfsel1 <- dfsel[y_test==1,]
dfsel0 <- dfsel[y_test==0,]

nrow(dfsel1)/nrow(dfsel)
nrow(dfsel0)/nrow(dfsel)

saveRDS(model, file = "xgboost_3_50")
