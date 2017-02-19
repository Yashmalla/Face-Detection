#!/usr/bin/env Rscript
args = commandArgs(TRUE)
n <- args[1]
# Load MXNet
suppressMessages(require(mxnet))

if(FALSE){
  # Clean workspace
  rm(list=ls())

  # Loading data and set up
  #-------------------------------------------------------------------------------
  
  # Load train and test datasets
  train <- read.csv("./csv/train.csv")
  
  # Set up train and test datasets
  train <- data.matrix(train)
  print(train)
  train_x <- t(train[, -1])
  train_y <- train[, 1]

  train_array <- train_x
  # dim(train_array) <- c(50, 50, 1, ncol(train_x))
  
  # Set up the symbolic model
  #-------------------------------------------------------------------------------
  
  data <- mx.symbol.Variable('data')
  # 1st convolutional layer
  conv_1 <- mx.symbol.Convolution(data = data, kernel = c(5, 5), num_filter = 20)
  tanh_1 <- mx.symbol.Activation(data = conv_1, act_type = "tanh")
  pool_1 <- mx.symbol.Pooling(data = tanh_1, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
  # 2nd convolutional layer
  conv_2 <- mx.symbol.Convolution(data = pool_1, kernel = c(5, 5), num_filter = 50)
  tanh_2 <- mx.symbol.Activation(data = conv_2, act_type = "tanh")
  pool_2 <- mx.symbol.Pooling(data=tanh_2, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
  # # 3rd convolutional layer
  # conv_3 <- mx.symbol.Convolution(data = pool_2, kernel = c(5, 5), num_filter = 100)
  # tanh_3 <- mx.symbol.Activation(data = conv_3, act_type = "tanh")
  # pool_3 <- mx.symbol.Pooling(data=tanh_3, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
  
  # 1st fully connected layer
  flatten <- mx.symbol.Flatten(data = pool_2)
  fc_1 <- mx.symbol.FullyConnected(data = flatten, num_hidden = 500)
  tanh_4 <- mx.symbol.Activation(data = fc_1, act_type = "tanh")
  # 2nd fully connected layer
  fc_2 <- mx.symbol.FullyConnected(data = tanh_4, num_hidden = 40)
  # Output. Softmax output since we'd like to get some probabilities.
  NN_model <- mx.symbol.SoftmaxOutput(data = fc_2)
  # Pre-training set up
  #-------------------------------------------------------------------------------
  
  # Set seed for reproducibility
  mx.set.seed(100)
  
  # Device used. CPU in my case.
  devices <- mx.cpu()
  
  # Training
  #-------------------------------------------------------------------------------
  # Train the model
  model <- mx.model.FeedForward.create(NN_model,
                                       X = train_array,
                                       y = train_y,
                                       ctx = devices,
                                       num.round = 500,
                                       array.batch.size = 40,
                                       learning.rate = 0.01,
                                       momentum = 0.9,
                                       eval.metric = mx.metric.accuracy,
                                       epoch.end.callback = mx.callback.log.train.metric(100))
  
  save(list = ls(all = TRUE), file= "all.RData")
  mx.model.save(model,"model",500)
}

suppressMessages(model <- mx.model.load("model", 500))

# Testing
#-------------------------------------------------------------------------------
if(n == 1){
  face <- read.csv("./csv/predict.csv")
}else if (n == 7){
  face <- read.csv("./csv/predict7.csv")
}else if (n == 13){
  face <- read.csv("./csv/predict13.csv")
}
# print(face)
face_x <- t(face[, -1])
face_y <- face[, 1]
face_array <- face_x
dim(face_array) <- c(50, 50 , 1, ncol(face_x))


mx.ctx.internal.default.value = list(device="cpu",device_id=0,device_typeid=1)
#mx.ctx.internal.default.value
class(mx.ctx.internal.default.value) = "MXContext"

# Predict labels
predicted1 <- predict(model, face_array)

#####---------- print the probability of matching the fed pic with the training pics-##
# print(predicted1)

# dim(predicted1)

max.idx1 <-( order((predicted1[,1]), decreasing = TRUE)[1:5] )-1

###--------------Print out the top 5 label with highest probablhy of matching with the fed pic--------------#####
result <- max.idx1[1]
print(result)



