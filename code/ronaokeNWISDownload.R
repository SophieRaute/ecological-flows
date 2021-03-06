library(dataRetrieval)
library(EGRET)
library(plyr)

siteNo <- '02080500'
# Discharge cfs
pcode <-  '00060'
# Suspended sediment, DO, Nitrate, TN, and Phosphorus mg/L
wqpcode <-  c('80154','00300','00620','00600','00665')
wqLabels <- c('SuspendedSediment','DissolvedOxygen','Nitrate','TotalNitrogen','Phosphorus')
scode <-  '00003' #mean
start.date <-  '1950-01-01'
end.date <-  '2018-01-01'
serv <- "dv" # Daily measurements

for (i in length(pcode)) {
  roanokeData <- readNWISdata(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate = start.date, endDate = end.date, service = serv)
  summary(roanokeData); dim(roanokeData)
  
  # Rename column names
  roanokeData <- renameNWISColumns(roanokeData); colnames(roanokeData)
  
  # See attributes
  names(attributes(roanokeData))
  
  parameterInfo = attr(roanokeData, "variableInfo")
  parameterLabel <- strsplit(parameterInfo$variableName,",")
  siteInfo <- attr(roanokeData, "siteInfo")
  
  roanokeData <- roanokeData %>% 
    select(agency_cd,site_no,dateTime,Flow)
  
  write.csv(roanokeData,file = paste(siteInfo$site_no,parameterLabel[[1]][1],".csv",sep = ""))
}

j = 1
for (code in wqpcode) {
  roanokeWQData <- readNWISSample(siteNo,code,"","")
  summary(roanokeWQData); dim(roanokeWQData)
  
  # Rename column names
  roanokeWQData <- renameNWISColumns(roanokeWQData); colnames(roanokeWQData)
  
  # See attributes
  names(attributes(roanokeWQData))
  roanokeWQData <- rename(roanokeWQData,c("Date"="dateTime","ConcAve" = paste(wqLabels[j],"ConcAve",sep="")))
  roanokeWQData <- roanokeWQData %>% 
    select(dateTime,paste(wqLabels[j],"ConcAve",sep=""))
  fileName <- paste(siteNo,wqLabels[j],sep = "")
  assign(fileName,roanokeWQData)
  write.csv(roanokeWQData,file = paste(siteNo,wqLabels[j],".csv",sep = ""))
  j = j+1
}


# Join data by common date
allNWISData <- join_all(list(roanokeData,`02080500DissolvedOxygen`,`02080500Phosphorus`,`02080500SuspendedSediment`,`02080500TotalNitrogen`), by="dateTime", type='inner')
# Write the final dataframe to a csv file
write.csv(allNWISData,file ="RoanokeNWISData.csv")

