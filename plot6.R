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

##Question 6: Compare emissions from motor vehicle sources in Baltimore City 
##with emissions from motor vehicle sources in Los Angeles County, California 
##(fips == "06037"). Which city has seen greater changes over time in motor 
##vehicle emissions?

vehi<-grepl("vehicle",SCC$SCC.Level.Two,ignore.case = TRUE)
vehiSCC<-SCC[vehi,]$SCC
vehiNEI<-NEI[NEI$SCC %in% vehiSCC,]
vehiNIEbal <- vehiNEI[vehiNEI$fips==24510,]
vehiNIEbal$city<-"Baltimore City"
vehiNIElos<-vehiNEI[vehiNEI$fips=="06037",]
vehiNIElos$city<-"Los Angeles County"
comparNEI<-rbind(vehiNIEbal,vehiNIElos)

ggplot(comparNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))