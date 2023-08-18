#Install pre-prequisite packagaes
install.packages("stats")
install.packages("dplyr", dependencies = TRUE)
install.packages("ggplot2")
install.packages("ggfortify")

#import the file
dataset <- read.csv("/Users/abhirup/Desktop/RLanguage/Vehicle.csv")

#head
head(dataset)

#display the summary
summary(dataset)

#structure of the dataset provided
str(dataset)

#Print the first 3 entry from the csv file
head(dataset, n = 3)

#Print the last 6 entry from the csv file
tail(dataset,n=6)


# Using the 'aggregate' function to calculate the average for Kms_Driven for each Car_Name
average_kms <- aggregate(dataset$Kms_Driven, by = list(dataset$Car_Name), FUN = mean)
# Rename the columns in the result
colnames(average_kms) <- c("Car_Name", "Average_Kms_Driven")
# Print the result
print(average_kms)


# Using the 'aggregate' function to calculate the average for Selling_Price for each Car_Name
average_sp <- aggregate(dataset$Selling_Price, by = list(dataset$Car_Name), FUN = mean)
# Rename the columns in the result
colnames(average_sp) <- c("Car_Name", "Average_Selling_Price")
# Print the result
print(average_sp)
