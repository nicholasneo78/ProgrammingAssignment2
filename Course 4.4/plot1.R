# Get Data from the web
UrlFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename <- "exdata_data_NEI_data.zip"

library(dplyr)

if (!file.exists(filename)) {
  download.file(UrlFile, filename, method = "curl")
}

dataset.name <- "NEI_data"
if (!file.exists(dataset.name)) {
  unzip(filename)
}

# Read the PM2.5 Emissions Data
PM25Data <- readRDS("summarySCC_PM25.rds")
# Read the Source Classification Code Table
SCCData <- readRDS("Source_Classification_Code.rds") 

# Merge datasets based on SCC & retrieve only the relevant columns
dataMerged <- merge(PM25Data, SCCData, by = "SCC")
dataMerged <- subset(dataMerged[ ,1:8])

# Sum PM2.5 emissions for each year
totalemissions <- PM25Data %>% 
  group_by(year) %>%
  summarize(sum(Emissions))
colnames(totalemissions) = c("year", "emissions")
format(totalemissions$emissions, scientific = FALSE)

# Plot1 deliverables
png("plot1.png")
barplot(height = totalemissions$emissions, 
        names.arg = totalemissions$year, 
        xlab = "Year",
        ylab = expression('Total PM'[2.5]*' emission (tons)'),
        main = expression('Total PM'[2.5]*' emission by year'),
        ylim = range(pretty(c(0, totalemissions$emissions)))
) 
dev.off()

# QUESTION 1
#'Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#'Using the base plotting system, make a plot showing the total PM2.5 
#'emission from all sources for each of the years 1999, 2002, 2005, and 2008.