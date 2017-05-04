#===============================================================
### exercise data test code, Qiang Huang, 2016/4/27
#===============================================================
# set work directory and outside functions
setwd("D:/code/exercise")
source("misc_HQ.R")

# load packages
#install.packages("RMySQL")
library(RMySQL)
# install.packages("ineq")
library(ineq)

# connect to database
con <- dbConnect(dbDriver("MySQL"),) ## without host information !!!!!!!
# get list of all tables
Tnames <- dbListTables(con)

if(any(Tnames=="test_bankaccount")){
  # read test_bankaccount table as data frame format
  test_bank <- as.data.frame(dbReadTable(con,"test_bankaccount"))
  
  # job 1: compute income and expense summarized in month, season, and year
  #收入与支出的月合计、季度合计、年合计；以及余额的月均余额。R的输出结果为frame�?
  
  # Time definition based on trading date
  dates <- test_bank[,"tradingDate"] 
  # note: here we define 1-3 as Spring
  inSeasons <- paste(1900+as.POSIXlt(dates)$year+1*(as.POSIXlt(dates)$year==12),  
                     c('Spring', 'Summer', 'Autumn', 'Winter')[1+(as.POSIXlt(dates)$mon %/% 3)%%4], sep="-")
  inMonths <- paste(1900+as.POSIXlt(dates)$year+1*(as.POSIXlt(dates)$year==12),  as.POSIXlt(dates)$mon+1, sep="-")
  inYears <- 1900+as.POSIXlt(dates)$year+1*(as.POSIXlt(dates)$year==12)
  Years <- sort(as.numeric(unique(inYears)))
  
  # 收入合计
  IncomeMonth <- GroupSummary(test_bank[,'income'], inMonths,"sum",Years,"Month")
  IncomeSeason <- GroupSummary(test_bank[,'income'], inSeasons,"sum",Years,"Season")
  IncomeYear <- GroupSummary(test_bank[,'income'], inYears,"sum",Years,"Year")
  
  # 支出合计
  ExpenseMonth <- GroupSummary(test_bank[,'expense'], inMonths,"sum",Years,"Month")
  ExpenseSeason <- GroupSummary(test_bank[,'expense'], inSeasons,"sum",Years,"Season")
  ExpenseYear <- GroupSummary(test_bank[,'expense'], inYears,"sum",Years,"Year")
  
  # 余额的月均余�?
  BalanceMonth <- GroupSummary(test_bank[,'balance'], inMonths,"mean",Years,"Month")
  
  
  # job 2: compute increasing rates
  # 利用收入与支出的月合计数分别用R和MySQL求出计算出其普通同比、环比月增长率，以及对数同比、环比月增长率�?
  
  # 收入的月同比增长率，对数增长�?
  tmp <- c()
  for(j in 1:(length(Years)-1)){
    secY <- IncomeMonth[match(paste(Years[j+1],1:12,sep='-'),IncomeMonth[,1]),2]
    firY <- IncomeMonth[match(paste(Years[j],1:12,sep='-'),IncomeMonth[,1]),2]
    rates <- (secY/firY - 1) * 100
    logrates <- log(rates)
    logrates[is.na(logrates)] <- -1
    rates[is.na(rates)] <- "missing"
    tmp1 <- cbind(paste(Years[j],Years[j+1],1:12,sep="-"), rates, logrates)
    tmp <- rbind(tmp,tmp1)
  }
  tmp[tmp[,3]=="-1",3] <- ""
  tmp <- tmp[tmp[,2]!="missing", ]
  incomeRate1 <- data.frame(tmp)
  colnames(incomeRate1)[1] <- "Time"
  incomeRate1
  
  # 收入的月环比增长率， 对数增长�?
  incomeRate2 <- c()
  for(j in 1:length(Years)){
    oneY <- IncomeMonth[match(paste(Years[j],1:12,sep='-'),IncomeMonth[,1]),2]
    oneY <- oneY[!is.na(oneY)]
    n <- length(oneY)
    rates <- (oneY[2:n]/oneY[1:(n-1)] - 1) * 100
    logrates <- log(rates)
    logrates[is.na(logrates)] <- -1
    rates[is.na(rates)] <- "missing"
    tmp <- cbind( paste(Years[j],1:(n-1),2:n,sep="-"),  rates, logrates )
    incomeRate2 <- rbind(incomeRate2,tmp)
  }
  incomeRate2[incomeRate2[,3]=="-1",3] <- ""
  incomeRate2 <- incomeRate2[incomeRate2[,2]!="missing", ]
  incomeRate2 <- data.frame(incomeRate2)
  colnames(incomeRate2)[1] <- "Time"
  incomeRate2
  
  # 支出的月同比增长率，对数增长�?
  tmp <- c()
  for(j in 1:(length(Years)-1)){
    secY <- ExpenseMonth[match(paste(Years[j+1],1:12,sep='-'),ExpenseMonth[,1]),2]
    firY <- ExpenseMonth[match(paste(Years[j],1:12,sep='-'),ExpenseMonth[,1]),2]
    rates <- (secY/firY - 1) * 100
    logrates <- log(rates)
    logrates[is.na(logrates)] <- -1
    rates[is.na(rates)] <- "missing"
    tmp1 <- cbind(paste(Years[j],Years[j+1],1:12,sep="-"), rates, logrates)
    tmp <- rbind(tmp,tmp1)
  }
  tmp[tmp[,3]=="-1",3] <- ""
  tmp <- tmp[tmp[,2]!="missing", ]
  expenseRate1 <- data.frame(tmp)
  colnames(expenseRate1)[1] <- "Time"
  expenseRate1
  
  # 支出的月环比增长率， 对数增长�?
  expenseRate2 <- c()
  for(j in 1:length(Years)){
    oneY <- ExpenseMonth[match(paste(Years[j],1:12,sep='-'),ExpenseMonth[,1]),2]
    oneY <- oneY[!is.na(oneY)]
    n <- length(oneY)
    rates <- (oneY[2:n]/oneY[1:(n-1)] - 1) * 100
    logrates <- log(rates)
    logrates[is.na(logrates)] <- -1
    rates[is.na(rates)] <- "missing"
    tmp <- cbind( paste(Years[j],1:(n-1),2:n,sep="-"),  rates, logrates )
    expenseRate2 <- rbind(expenseRate2,tmp)
  }
  expenseRate2[expenseRate2[,3]=="-1",3] <- ""
  expenseRate2 <- expenseRate2[expenseRate2[,2]!="missing", ]
  expenseRate2 <- data.frame(expenseRate2)
  colnames(expenseRate2)[1] <- "Time"
  expenseRate2
  
  
  # job 3: correlations
  # 利用收入与支出的月合计数，用R计算出收入与支出的近6月相关性（移动），以及�?12月相关性（移动）；并画出相关系数的曲线�?
  n <- dim(IncomeMonth)[1]
  len=6
  Vcor <- corrLen(cbind(IncomeMonth[,2],ExpenseMonth[,2]),len=len, IncomeMonth[1:(n-len+1),1])
  
  len=12
  Vcor <- corrLen(cbind(IncomeMonth[,2],ExpenseMonth[,2]),len=len, IncomeMonth[1:(n-len+1),1])
 
  
  # job 4: compute HHI
  # 用R计算出各月占比的时间集中度（HHI�?
  IncomeHHI <- IncomeMonth
  ExpenseHHI <- ExpenseMonth
  k <- 1
  HHIIncome <- 1:length(Years)
  HHIExpense <- 1:length(Years)
  for(i in Years){
    IncomeHHI[which(grepl(i,IncomeHHI[,1])),2] <-  IncomeMonth[which(grepl(i,IncomeMonth[,1])),2]/IncomeYear[IncomeYear[,1]==i,2]
    ExpenseHHI[which(grepl(i,ExpenseHHI[,1])),2] <-  ExpenseMonth[which(grepl(i,ExpenseMonth[,1])),2]/ExpenseYear[ExpenseYear[,1]==i,2]
    HHIIncome[k] <- sum(IncomeHHI[which(grepl(i,IncomeHHI[,1])),2]^2)
    HHIExpense[k] <- sum(ExpenseHHI[which(grepl(i,ExpenseHHI[,1])),2]^2)
    k <- k+1
  }
  HHIIncome <- cbind(Years, HHIIncome)
  colnames(HHIIncome) <- c("Year","HHI")
  HHIExpense <- cbind(Years, HHIExpense)
  colnames(HHIExpense) <- c("Year","HHI")
  HHIIncome
  HHIExpense
  
}


## job 5: Lorenz curve and Gini indexes ======

if(any(Tnames=="test_wages")){
  # read test_wages table as data frame
  test_wages <- as.data.frame(dbReadTable(con,"test_wages"))
  wages <- as.numeric(test_wages[,"actualAmountRevenue"])
  
  dates <- test_wages[,"payedDate"]
  inMonths <- paste(1900+as.POSIXlt(dates)$year+1*(as.POSIXlt(dates)$year==12),  as.POSIXlt(dates)$mon+1, sep="-")
  
  # plot lorenz curve 
  # 用R画出最近一个月的员工工资的洛伦兹曲线，并且画出各月的基尼系数的时间序列曲线
  UniMonths <- sortInMonths(unique(inMonths))
  plot(Lc(wages[inMonths==UniMonths[length(UniMonths)]]),main="Lorenz curve of wages in 2014-10")
  
  GiniS <- sapply(UniMonths,function(i) ineq(wages[inMonths==i],type="Gini"))
  plot(GiniS,type='b',main="Time-series of Gini indexes",xaxt='n',xlab="",ylab="Ginis")
  axis(1,at=1:length(GiniS),labels =FALSE)  
  text(1:length(GiniS), par("usr")[3]-0.019, labels = UniMonths, srt = 90, pos = 1, xpd = TRUE)
  
  
}

## job 6: cross correlation functions ======

# 利用银行流水收入月合计数据以及支出月合计数据，做出二者的互相关（移动）函数�?

ccfs <- ccf_HQ(as.numeric(IncomeMonth[,2]),as.numeric(ExpenseMonth[,2])) ## 互相关函�?
n <- floor(length(ccfs)/2)
plot(ccfs,xaxt='n',xlab="lag",ylab="Cross Correlation",main="Cross correlations across different lags")
axis(1,at=1:length(ccfs),labels = seq(-n,n,1))
abline(h=0,lty=2,lwd=1)

# validation based on the inside function "ccf"
# ccfs1 <- ccf(as.numeric(IncomeMonth[,2]),as.numeric(ExpenseMonth[,2]))
# plot(ccfs1)

dbDisconnect(con)
