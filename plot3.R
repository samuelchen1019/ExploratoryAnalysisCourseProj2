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

pmemsbal <- NEI[NEI$fips=="24510",]
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