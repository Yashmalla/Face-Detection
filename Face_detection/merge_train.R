# Load datasets
olivetti <- read.csv("./csv/train_50.csv")
burris <- read.csv("./csv/Burris.csv")

# Bind rows in a single dataset
new <- rbind(olivetti, burris)

# Shuffle new dataset
shuffled <- new[sample(1:400),]
write.csv(shuffled, "./csv/train.csv",row.names = FALSE)
print("Done")