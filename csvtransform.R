
files <- list.files(path = "data/")
f <- list()

sample1 <- read.csv(paste0("data/",files[1]), header=TRUE, sep=",")
sample2 <- read.csv(paste0("data/",files[2]), header=TRUE, sep=",")

fastmerge <- function(d1, d2) {
  d1.names <- names(d1)
  d2.names <- names(d2)
  
  # columns in d1 but not in d2
  d2.add <- setdiff(d1.names, d2.names)
  
  # columns in d2 but not in d1
  d1.add <- setdiff(d2.names, d1.names)
  
  # add blank columns to d2
  if(length(d2.add) > 0) {
    for(i in 1:length(d2.add)) {
      d2[d2.add[i]] <- NA
    }
  }
  
  # add blank columns to d1
  if(length(d1.add) > 0) {
    for(i in 1:length(d1.add)) {
      d1[d1.add[i]] <- NA
    }
  }
  
  return(rbind(d1, d2))
}

table<- fastmerge(sample1, sample2)
for (i in 3:length(files)) {
  print(paste0("loading..",files[i]))
  sample2 <- read.csv(paste0("data/",files[i]), header=TRUE, sep=",")
  table<- fastmerge(table, sample2)
}

table[is.na(table)] <- 0     # replace nulls with 0's'

table$year<-substring(table$X_time,nchar(table$X_time)-3)
table$month<-substring(table$X_time,first=4,last=7)
table$key<-paste(table$year,"-", table$month)
table$key<-gsub("00:00:00", "", table$key)
table$month<-NULL
table$year<-NULL
table$X_time<-table$key
table$key<-NULL
table$limit<-NULL

ncols<-length(table)
table<-aggregate(table[2:ncols], by=list(date=table$X_time), FUN=mean)

#rownames(table) <- table[,1] # set rownames to col1 (dates)
#table[,1]<-NULL              # remove col1 (dates)

write.csv(table,file="transformed.csv", row.names = FALSE, quote=FALSE)

# table<-t(table)             # transpose table
# 
# index<-names(table)         # set vector of index names 
# values<-table               # set data values 
# dates<-rownames(table)      # set vector of dates
# 
# barplot(as.matrix(values), names.arg = index, xlab= "Date", ylab= "GB Ingest", 
#         legend.text = dates,
#         beside = FALSE) 


