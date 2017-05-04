load("www/data_2002_2015")
source("www/misc.R")
source("www/PTA_prediction.R")

ALLT <- rownames(data)
sub0=11

Price_curves <- function(good="PTA",seDates){
        
        t1 <- as.character(seDates[1])
        t2 <- as.character(seDates[2])
        sub1 <- which(ALLT==t1)
        sub2 <- which(ALLT==t2)
        tsone <- data[sub1:sub2, sub0]
        year1 <- unlist(strsplit(t1,"-"))[1]
        year2 <- unlist(strsplit(t2,"-"))[1]

        if(good=="PTA") {
                plot(tsone,type="l",xlab="Time",ylab="Price",xaxt="n")
                a1 <- median(which(grepl(year1,ALLT[sub1:sub2])))
                a2 <- median(which(grepl(year2,ALLT[sub1:sub2])))
                axis(1,at=seq(a1,a2,length.out=as.numeric(year2)-as.numeric(year1)+1),labels=as.numeric(year1):as.numeric(year2)) 
        }

}

Fitting_curves <- function(good="PTA",seDates,dim){

        t1 <- as.Date(seDates[1])
        t2 <- as.Date(seDates[2])
        sub <- which(rownames(data)==as.character(t2))
        data <- data[1:sub, ]
        if(good=="PTA") {
                if(t1=="2015-12-01" & t2=="2015-12-31" & dim==1){
                        defaultPreList(dim)
                }else{
                        tmp <- PTA_Prediction(data,t1,t2,filenames=NULL,trace1=1,dim=dim);
                }
        }
        
}

defaultPreList <- function(i){
        
        if(i==1){
                labs <- c(2015-12-01,2015-12-02,2015-12-03,2015-12-04,2015-12-05,2015-12-06,2015-12-07,2015-12-08,2015-12-09,2015-12-10,2015-12-11,2015-12-12,2015-12-13,2015-12-14,2015-12-15,2015-12-16,2015-12-17,2015-12-18,2015-12-19,2015-12-20,2015-12-21,2015-12-22,2015-12-23,2015-12-24,2015-12-25,2015-12-26,2015-12-27,2015-12-28,2015-12-29,2015-12-30,2015-12-31)
                x <- c(4700.000,4700.000,4650.000,4650.000,4633.333,4616.667,4600.000,4500.000,4400.000,4450.000,4400.000,4366.667,4333.333,4300.000,4200.000,4200.000,4200.000,4200.000,4183.333,4166.667,4150.000,4250.000,4300.000,4300.000,4300.000,4300.000,4300.000,4300.000,4280.000,4300.000,4300.000)
                y <- c(4700.000,4700.000,4700.000,4650.000,4650.000,4633.333,4616.667,4600.000,4500.000,4400.000,4450.000,4400.000,4366.667,4333.333,4300.000,4200.000,4200.000,4200.000,4200.000,4183.333,4166.667,4150.000,4250.000,4300.000,4300.000,4300.000,4300.000,4300.000,4300.000,4280.000,4300.000)
                
                main="";ylab="Price";xlab="";ord="topleft";
                ymax <- 1.1*max(c(x,y))
                ymin <- 0.9*min(c(x,y))
                par(mai=c(1.2,1.2,1,1))
                plot(x,col=1,type="b",ylim=c(ymin,ymax),ylab=ylab,xlab=xlab,xaxt="n",lwd=3,main=main)
                lines(y,col=2,type="b",lwd=3)
                axis(1,at=1:31,labels =FALSE)  
                pos <- 1:31-31/100
                text(pos, par("usr")[3]-0.11*(ymax-ymin), labels = labs, srt = 90, pos = 1, xpd = TRUE)
                legend(ord,legend=c("观察值","预测值"),col=1:2,lwd=2)   
        }
 
}

Predict_curves <- function(good="PTA"){
        
        t1 <- "2016-01-01" ## only for test
        sub <- which(rownames(data)==as.character(t1)) ### only for test
        data <- data[1:sub, ] ### only for test
        if(good=="PTA")  tmp <- PTA_Prediction(data,"","",filenames=NULL,trace1=1,dim=5);
        
        tmp <- round(tmp,4)
        
        t(cbind(c("日","周","月","季度"),tmp))
}
