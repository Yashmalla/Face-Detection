# Resize images and convert to grayscale

#rm(list=ls())
require(EBImage)

# Set wd where images are located
setwd("faces")
# Set d where to save images
save_in <- "../face_resized/"
# Load images names
images <- list.files()
# Set width
w <- 50
# Set height
h <- 50

# Main loop resize images and set them to greyscale
for(i in 1:length(images))
{
  # Try-catch is necessary since some images
  # may not work.
  result <- tryCatch({
    # Image name
    
    imgname <- images[i]
    # Read image
    img <- readImage(imgname)
    print(imgname)
    # Resize image 28x28
    img_resized <- resize(img, w = w, h = h)
    # Set to grayscale
    grayimg <- channel(img_resized,"gray")
    # Path to file
    path <- paste(save_in, imgname, sep = "")
    # Save image
    writeImage(grayimg, path, quality = 70)
    # Print status
    print(paste("Done",i,sep = " "))},
    # Error function
    error = function(e){print(e)})
}

