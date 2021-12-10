##Download the zip file. The file has been downloaded and unzipped though.
zipFile<-"exdata_data_NEI_data.zip"
if(!file.exist(zipFile)){
  fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL,destfile=zipFile,method="curl")
}
if(!(file.exists("summarySCC_PM25.rds") && 
     file.exists("Source_Classification_Code.rds"))) { unzip(zipFile) }

##Data loading
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Question 1: Have total emissions from PM2.5 decreased in the United States 
##from 1999 to 2008? Using the base plotting system, make a plot showing the 
##total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, 
##and 2008.

pmemsttl<-aggregate(Emissions ~ year,NEI, sum)
barplot(pmemsttl$Emissions,
        names.arg = pmemsttl$year,
        xlab = "Year",
        ylab="PM2.5 Emissions",
        main="Total PM2.5 Emissions From All US Sources")