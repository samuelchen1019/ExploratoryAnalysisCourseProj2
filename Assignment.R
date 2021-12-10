##Download the zip file. The file has been downloaded and unzipped though.
zipFile<-"exdata_data_NEI_data.zip"
if(!file.exist(zipFile)){
  fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL,destfile=zipFile,method="curl")
}
if(!(file.exists("summarySCC_PM25.rds") && 
     file.exists("Source_Classification_Code.rds"))) { unzip(zipFile) }
##Library loading
library(ggplot2)

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

##Question 3: Of the four types of sources indicated by the type (point, 
##nonpoint, onroad, nonroad) variable, which of these four sources have seen 
##decreases in emissions from 1999–2008 for Baltimore City? Which have seen 
##increases in emissions from 1999–2008? Use the ggplot2 plotting system to make
##a plot answer this question.

ggplot(pmemsbal,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

##Question 4: Across the United States, how have emissions from coal combustion
##-related sources changed from 1999–2008?

comb <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalComb <- (comb & coal)
combustionSCC <- SCC[coalComb,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

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

##Question 6: Compare emissions from motor vehicle sources in Baltimore City 
##with emissions from motor vehicle sources in Los Angeles County, California 
##(fips == "06037"). Which city has seen greater changes over time in motor 
##vehicle emissions?

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