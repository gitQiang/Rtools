GroupSummary <- function(data,name,fun="sum",Years=c(2012:2014),ord="Month"){
  if(fun=="sum") tmp <- as.data.frame(aggregate(data, list(name), sum))
  if(fun=="mean") tmp <- as.data.frame(aggregate(data, list(name), mean))
  colnames(tmp) <- c("Time",fun)
  
  
  if(ord=="Month") indM <- sortInMonths(tmp[,1]) 
  if(ord=="Season"){
    indM <- c()
    for(i in 1:length(Years)){
      indM <- c(indM,paste(Years[i],c('Spring', 'Summer', 'Autumn', 'Winter'),sep="-"))
    }
  }
  if(ord=="Year") indM <- sort(as.numeric(Years))
  
  tmp <- tmp[match(indM,tmp[,1]), ]
  
  tmp
  
}

corrLen <- function(data,len=6,labs){
  n <- dim(data)[1]
  
  Vcor <- 1:(n-len+1)
  for(i in 1:(n-len+1)){
    Vcor[i] <- cor(data[i:(i+len-1),1],data[i:(i+len-1),2])
  }
  
  plot(1:length(Vcor),Vcor,type='b',xaxt='n',xlab="",ylab="Pearson Correlations",main=paste("Income and expense correlations in ",len," months",sep=""))
  axis(1,at=1:length(Vcor),labels =FALSE)  
  text(1:length(Vcor), par("usr")[3]-0.15, labels = labs, srt = 90, pos = 1, xpd = TRUE)
  
  Vcor
  
}

sortInMonths <- function(inMonths){
  n <- length(inMonths)
  tmp <- matrix(unlist(strsplit(inMonths,"-")),ncol=2,byrow = TRUE)
  tmp <- tmp[order(as.numeric(tmp[,1]),as.numeric(tmp[,2])), ] 
  paste(tmp[,1],tmp[,2],sep="-")
}

ccf_HQ <- function(ts1,ts2,lag=FALSE){
  
  if(lag==FALSE){
    tmp <- sapply((-round(length(ts1)/2)):(round(length(ts1)/2)), function(i) ccf_n(ts1,ts2,i))
  }else{
    tmp <= ccf_n(ts1,ts2,lag)
  }
  tmp
}

ccf_n <- function(ts1,ts2,n=0){
  if(n >= length(ts2)) n <- length(ts2)-1
  if(n <= -length(ts2)) n <- 1-length(ts2)
  if(n>=0) m <- 1:(length(ts2)-n)
  if(n< 0) m <- (-n+1):length(ts2)
  #cor(ts1[m],ts2[m+n],method = "pearson")
  cor_HQ(ts1[m],ts2[m+n])
}

cor_HQ <- function(X,Y){
  N <- length(X)
  a1 <- sum(X*Y)
  a2 <- sum(X)*sum(Y)/N
  
  a3 <- sum(X*X)-sum(X)^2/N
  a4 <- sum(Y*Y)-sum(Y)^2/N
  
  (a1-a2)/sqrt(a3*a4)
}
