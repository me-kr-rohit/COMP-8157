# installing packages
install.packages("ggplot2")
install.packages("reshape2")
install.packages("dbscan")

#import libraries
library(ggplot2)
library(reshape2)
library(dbscan)


# Part 1: Data Exploration

# 1. import the Vehicle data set
data <- read.csv("D:/MAC/Term-2/COMP-8157/current/Lab 1/Vehicle.csv")
data


# 2. Summary of Vehicle data set
summary(data)


# 3. structure and dimension of data set
str(data)

dim(data)


# 4. Display first 3 rows
head(data, 3)


# 5. Display last 6 rows
tail(data,6)


# 6. Average km driven for each car type
avg_kms <- aggregate(data$Kms_Driven, by = list(data$Car_Name), FUN = mean)
colnames(avg_kms) <- c("Car Name", "Average KM driven by Car")
print(avg_kms)


# 7. Average selling price of the cars in each year
avg_selling_price <- aggregate(data$Selling_Price, by = list(Year = data$Year), FUN = mean)
colnames(avg_selling_price) <- c("Year", "Average Selling price")
print(avg_selling_price)


# Part 2: Data Pre-processing


# 8. Display the unique combination of columns
unique_combination <- unique(subset(data, select = c("Car_Name", "Fuel_Type", "Seller_Type", "Transmission")))
print(unique_combination)


# 9. Display the different combination of columns and times does it occurs 
combine_data <- table(paste(data$Car_Name, data$Fuel_Type, data$Seller_Type, data$Transmission))
sort_combine_data_asc <- sort(combine_data)
print(sort_combine_data_asc)
sort_combine_data_desc <- sort(combine_data, decreasing = TRUE)
print(sort_combine_data_desc)


# 10. Display missing values in data set
missing_value <- anyNA(data)
print(missing_value)


# 11. Display columns with missing values
missing_column_value <- colSums(is.na(data))
print(missing_column_value)
missed_columns <- names(missing_column_value)[missing_column_value]
print(missed_columns)


# 12. Replaced missing values with most repeated
for (column in names(data)) 
{
  most_repeated_value <- names(which.max(table(data[[column]])))
  data[[column]][is.na(data[[column]])] <- most_repeated_value
}

data_missing_values <- sapply(data, function(x) sum(is.na(x)))
print(data_missing_values)


# 13. Find and remove duplicate rows if exit
duplicate_rows <- data[duplicated(data),]
if (nrow(duplicate_rows) > 0) 
{
  cat("Duplicate rows has been removed successfully\n")
  remove_duplicate_rows <- data[!duplicated(data), ]
  data <- remove_duplicate_rows
  print(data)
} else
{
  cat("No duplicate rows found\n")
}


# 14. Replace the attribute values

#problem: a Fuel_Type: "Petrol": 0, "Diesel": 1, "CNG": 2
data$Fuel_Type <- ifelse(data$Fuel_Type == "Petrol", 0, ifelse(data$Fuel_Type == "Diesel", 1, 2))
data$Fuel_Type

#problem: b Seller_Type: "Dealer": 0, "Individual": 1
data$Seller_Type <- ifelse(data$Seller_Type == "Dealer", 0, 1)
data$Seller_Type

#problem: c #Transmission: "Manual": 0, "Automatic": 1
data$Transmission <- ifelse(data$Transmission == "Manual", 0, 1)
data$Transmission

# 15. Adding a new field
data$Year <- as.numeric(data$Year)
current_car_age <- as.integer(format(Sys.Date(), "%Y"))
data$Age <- current_car_age - data$Year
data


# Part 3: Data visualization


# 16. Create a new data set
new_dataset <- subset(data, select = c("Car_Name", "Selling_Price", "Present_Price", "Kms_Driven"))
new_dataset


# 17. Shuffling the rows randomly
data_shuffle <- data[sample(nrow(data)), ]
data_shuffle

# 18. Create a scatter plot
#a. Red for Transmission type '0' and Blue for '1'.
transmission_type <- c("0" = "red", "1" = "blue")
# Scatter plot
plot(data$Present_Price, data$Selling_Price, col = transmission_type[as.character(data$Transmission)],
     xlab = "Present_Price", ylab = "Selling_Price", main = "Selling_Price vs Present_Price", pch = 16)

legend("topright", legend = c("Manual", "Automatic"), col = c("red", "blue"), pch = 16, title = "Transmission")

#b Adding open triangles to the plot
plot(data$Present_Price, data$Selling_Price, col = transmission_type[as.character(data$Transmission)],
     xlab = "Present_Price", ylab = "Selling_Price", main = "Selling_Price vs Present_Price",
     pch = ifelse(data$Transmission == 0, 2, 3))

# 19. Creating a box plot

data$Selling_Price <- as.numeric(data$Selling_Price)
data$Transmission <- as.numeric(data$Transmission)
data$Fuel_Type <- as.numeric(data$Fuel_Type)

boxplot(Selling_Price ~ Transmission + Fuel_Type, data = data, main = "Selling_Price vs. Transmission & Fuel_Type",
        xlab = "Transmission & Fuel_Type", ylab = "Selling_Price", col = c("blue", "red", "green"),
        names = c("Manual-Petrol", "Automatic-Petrol", "Manual-Diesel", "Automatic-Diesel", "Manual-CNG", "Automatic-CNG"),
        outline = FALSE)

legend("topright", legend = c("Petrol", "Diesel", "CNG"),
       fill = c("blue", "red", "green"), title = "Fuel_Type")



# 20.  Scatter plot using k-means 
data$Selling_Price <- as.numeric(data$Selling_Price)
data$Kms_Driven <- as.numeric(data$Kms_Driven)

plot(data$Kms_Driven, data$Selling_Price, xlab = "Kms_Driven", ylab = "Selling_Price", main = "Selling_Price vs Kms_Driven")

#using k-means
k <- 4  
set.seed(123)  
cluster <- kmeans(data[, c("Kms_Driven", "Selling_Price")], centers = k)

colors <- c("red", "orange", "blue", "green")
points(data$Kms_Driven, data$Selling_Price, col = colors[cluster$cluster], pch = 16)

points(cluster$centers[, "Kms_Driven"], cluster$centers[, "Selling_Price"], col = "black", pch = 4, cex = 2)

legend("topright", legend = paste("Cluster", 1:k), col = colors, pch = 16)


# 21. Scatter plot using hierarchical clustering

data_frame_price <- data[, c("Selling_Price", "Present_Price")]

hierarchical_cluster <- hclust(dist(data_frame_price))

clusterPoint <- cutree(hierarchical_cluster, k = 3)

data_frame_price$Clusters <- factor(clusterPoint)

ggplot(data_frame_price, aes(x = Present_Price, y = Selling_Price, color = Clusters)) +
  geom_point(size = 3) +
  labs(x = "Present_Price", y = "Selling_Price", title = "Selling_Price vs Present_Price") +
  scale_color_manual(values = c("red", "blue", "green"))  


# 22. Creating a bar plot
data$Age <- as.numeric(format(Sys.Date(), "%Y")) - data$Year
new_data_frame <- subset(data, select = c("Age", "Year", "Transmission", "Seller_Type", "Fuel_Type", "Owner"))
print(new_data_frame)

barFields <- c("Age", "Year", "Transmission", "Seller_Type", "Fuel_Type", "Owner")

par(mfrow = c(3, 2)) 
for (field in barFields) 
{
  counts <- table(data[[field]])
  barplot(counts, main = field, xlab = field, ylab = "Count", col = rainbow(length(counts)))
}


# 23. Creating a correlation plot

data <- data[, !(names(data) %in% c("Car_Name"))]
data <- data[, !(names(data) %in% c("Combine"))]

data$Present_Price <- as.numeric(data$Present_Price)
data$Kms_Driven <- as.numeric(data$Kms_Driven)
data$Fuel_Type <- as.numeric(data$Fuel_Type)
data$Seller_Type <- as.numeric(data$Seller_Type)
data$Transmission <- as.numeric(data$Transmission)
data$Owner <- as.numeric(data$Owner)
data$Age <- as.numeric(data$Age)
data$Year <- as.numeric(data$Year)

correlation_dataset <- cor(data)
ggplot(data = reshape2::melt(correlation_dataset), aes(x = Var1, y = Var2, fill = value)) + geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  labs(title = "Correlation Plot", x = "", y = "") + theme_minimal()


# 24. Scatter plot using DBSCAN clustering
dbscan_data_frame <- data.frame(Selling_Price = data$Selling_Price, Kms_Driven = data$Kms_Driven)

dbscan_data <- dbscan(dbscan_data_frame, eps = 1, MinPts = 3)

ggplot(dbscan_data_frame, aes(x = Selling_Price, y = Kms_Driven, color = factor(dbscan_data$cluster))) +
  geom_point() +
  labs(x = "Selling Price", y = "Kms Driven", title = "Selling Price vs Kms Driven with DBSCAN Clustering") +
  scale_color_discrete(name = "Clusters") +
  theme_minimal()


