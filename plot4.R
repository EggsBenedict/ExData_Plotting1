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
png(filename = "plot4.png",
    width = 480, height = 480, units = "px", 
    bg = "transparent")
par(mfrow=c(2,2))

# Plot 1
plot(powerData$DateTime,powerData$Global_active_power,type="l",
     xlab="",ylab="Global Active Power")

# Plot 2
plot(powerData$DateTime,powerData$Voltage,type="l",
     xlab="datetime",ylab="Voltage")


# Plot 3 
plot(powerData$DateTime,y=powerData$Sub_metering_1,type="l",
     xlab="",ylab="Energy sub metering")
lines(powerData$DateTime,y=powerData$Sub_metering_2, type="l",col="red")
lines(powerData$DateTime,y=powerData$Sub_metering_3, type="l",col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lty=c(1,1,1),lwd=c(2.5,2.5,2.5),col=c("black","blue","red"), bty="n")

# Plot 4
plot(powerData$DateTime,powerData$Global_reactive_power,type="l",
     xlab="datetime",ylab="Global_reactive_power")

dev.off()
