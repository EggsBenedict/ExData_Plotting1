library(sqldf)

setwd("~/RStudioDirectory/Plots")
zipFile <- "exdata-data-household_power_consumption.zip"
fileName <- "household_power_consumption.txt"

# Download the .zip file with project data if it doesn't already exist
if (!file.exists(zipFile)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, zipFile, method="curl")
}
# Unzip the file if directory not present
if (!file.exists(fileName)) { 
    unzip(zipFile) 
}

# Select Statement to Limit Results
selectStatment <- "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"

# Read the file in Select Statement Above
powerData <- read.csv.sql(fileName, sql=selectStatment, sep=";")

# Convert date / times
powerData$DateTime <- as.POSIXct(strptime(paste(powerData$Date,powerData$Time),
                      "%d/%m/%Y %H:%M:%S"))

# Open png graphics device
png(filename = "plot2.png",
    width = 480, height = 480, units = "px", 
    bg = "transparent")

# Make the plot
plot(powerData$DateTime,powerData$Global_active_power,type="l",
     xlab="",ylab="Global Active Power (kilowatts)")

dev.off()