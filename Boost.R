#install.packages('xgboost')
install.packages('xgboost')     # for fitting the xgboost model
install.packages('caret')       # for general data preparation and model fitting
install.packages('e1071')


install.packages("recipes")
library(xgboost)
library(caret)  
library(e1071) 
require(caret)

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

