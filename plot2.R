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

##Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, 
##Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to 
##make a plot answering this question.

pmemsbal <- NEI[NEI$fips=="24510",]
pmemsbalttl<-aggregate(Emissions ~ year,pmemsbal, sum)
barplot(pmemsbalttl$Emissions,
        names.arg = pmemsbalttl$year,
        xlab = "Year",
        ylab="PM2.5 Emissions",
        main="Total PM2.5 Emissions From All Baltimore City Sources")