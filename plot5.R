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
##Library loading
library(ggplot2)

##Question 5: How have emissions from motor vehicle sources changed from 
##1999–2008 in Baltimore City?

vehi<-grepl("vehicle",SCC$SCC.Level.Two,ignore.case = TRUE)
vehiSCC<-SCC[vehi,]$SCC
vehiNEI<-NEI[NEI$SCC %in% vehiSCC,]
vehiNIEbal <- vehiNEI[vehiNEI$fips==24510,]
ggplot(vehiNIEbal,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))