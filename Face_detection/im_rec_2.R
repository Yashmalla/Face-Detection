# Clean environment and load required packages
#rm(list=ls())
require(EBImage)

# Set wd where resized greyscale images are located
setwd("../face_resized")

# Out file
out_file <- "../csv/face.csv"

# List images in path
images <- list.files()

# Set up df
df <- data.frame()

# Set image size. In this case 28x28
img_size <- 50*50

# Set label
label <- 1

# Main loop. Loop over each image
for(i in 1:length(images))
{
  # Read image
  img <- readImage(images[i])
  # Get the image as a matrix
  img_matrix <- img@.Data
  # Coerce to a vector
  img_vector <- as.vector(t(img_matrix))
  # Add label
  vec <- c(label, img_vector)
  # Bind rows
  df <- rbind(df,vec)
  # Print status info
  print(paste("Done ", i, sep = ""))
}

# Set names
#names(df) <- c("label", paste("pixel", c(1:img_size)))

# Write out dataset
write.csv(df, out_file, row.names = FALSE)