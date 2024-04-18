
sample1 <- read.csv("sample1.csv", header=TRUE, sep=",")
sample2 <- read.csv("sample2.csv", header=TRUE, sep=",")

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


table[is.na(table)] <- 0     # replace nulls with 0's'

table$year<-substring(table$date,nchar(table$date)-3)
table$month<-substring(table$date,first=4,last=7)
table$key<-paste(table$year,"-", table$month)
table$key<-gsub(" ", "", table$key)
table$month<-NULL
table$year<-NULL
#table$date<-table$key

#table<-aggregate(table[1:6], by=list(date=table$key), FUN=sum)
#table[1:6]/length(table)

#rownames(table) <- table[,1] # set rownames to col1 (dates)
#table[,1]<-NULL              # remove col1 (dates)

write.csv(table,file="splunkcloudingest.csv", row.names = TRUE, quote=FALSE)

# table<-t(table)             # transpose table
# 
# index<-names(table)         # set vector of index names 
# values<-table               # set data values 
# dates<-rownames(table)      # set vector of dates
# 
# barplot(as.matrix(values), names.arg = index, xlab= "Date", ylab= "GB Ingest", 
#         legend.text = dates,
#         beside = FALSE) 


