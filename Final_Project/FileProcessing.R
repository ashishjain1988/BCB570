proteome <- read.table("/home/jain/BCB570/Final_project/Proteome_Data/77_cancer_proteomes_CPTAC_itraq-filt.csv", header=T, sep="," , row.names=2) ##Input expression matrix
proteomeVal<-proteome[,3:ncol(proteome)]
dim(proteomeVal[apply(proteomeVal,MARGIN = 1, function(x) all(!is.na(x))), ])

bcdata <- read.table("/home/jain/BCB570/Final_project/Normal-Breast-Samples/allsamplesFPKM-normalBC-genes.txt", header=F, sep=" " , row.names=2) ##Input expression matrix
bcdataVal<-bcdata[,2:ncol(bcdata)]
bcdataVal<-bcdataVal[apply(bcdataVal,MARGIN = 1, function(x) any(x>=1)), ]
write.table(bcdataVal,"/home/jain/BCB570/Final_project/Normal-Breast-Samples/allsamplesFPKM-normalBC-genes-filtgt1.txt", sep="," , quote = F,col.names = F) ##Input expression matrix

