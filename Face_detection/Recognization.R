require(mxnet)


face <- read.csv("csv/face.csv")
face_x <- t(face[, -1])
face_y <- face[, 1]
print(face_x)
face_array <- face_x
dim(face_array) <- c(50, 50 , 1, ncol(face_x))


mx.ctx.internal.default.value = list(device="cpu",device_id=0,device_typeid=1)
mx.ctx.internal.default.value
class(mx.ctx.internal.default.value) = "MXContext"


#____________ real face detection____________________


# Predict labels
predicted1 <- predict(model, face_array)

#####---------- print the probability of matching the fed pic with the training pics-##
print(predicted1)

dim(predicted1)

max.idx1 <-( order((predicted1[,1]), decreasing = TRUE)[1:5] )

###--------------Print out the top 5 label with highest probablhy of matching with the fed pic--------------#####
print(max.idx1)
