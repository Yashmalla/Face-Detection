
# This script is used to resize images from 64x64 to 28x28 pixels

# Clear workspace
#rm(list=ls())

# Load EBImage library
require(EBImage)

# Load data
X <- read.csv(file ="csv/olivetti_X.csv", header = F)
labels <- read.csv(file ="csv/olivetti_y.csv", header = F)

# Dataframe of resized images
rs_df <- data.frame()

# Main loop: for each image, resize and set it to greyscale
for(i in 1:nrow(X))
{
  # Try-catch
  result <- tryCatch({
    # Image (as 1d vector)
    img <- as.numeric(X[i,])
    # Reshape as a 64x64 image (EBImage object)
    img <- Image(img, dim=c(64, 64), colormode = "Grayscale")
    # Resize image to 28x28 pixels
    img_resized <- resize(img, w = 50, h = 50)
    # Get image matrix (there should be another function to do this faster and more neatly!)
    img_matrix <- img_resized@.Data
    # Coerce to a vector
    img_vector <- as.vector(t(img_matrix))
    # Add label
    label <- (labels[i,])
    print(label)
    vec <- c(label, img_vector)
    # Stack in rs_df using rbind
    rs_df <- rbind(rs_df, vec)
    # Print status
    print(paste("Done",i,sep = " "))},
    # Error function (just prints the error). Btw you should get no errors!
    error = function(e){print(e)})
}


# Set names. The first columns are the labels, the other columns are the pixels.
names(rs_df) <- c("label", paste("pixel", c(1:2500)))

# Train-test split
#-------------------------------------------------------------------------------
# Simple train-test split. No crossvalidation is done in this tutorial.

# Set seed for reproducibility purposes
set.seed(100)

# Shuffled df
train_50 <- rs_df[1:390,]

# Save train-test datasets
write.csv(train_50, "csv/train_50.csv", row.names = FALSE)

# Done!
print("Done!")

