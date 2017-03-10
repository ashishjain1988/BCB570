#GENIE3 Code
library("MASS")
library("ggplot2")
source("/home/jain/Placenta_Geo_Dataset/GRN_Dataset/DREAM-5/GENIE3_R_C_wrapper/GENIE3_R_C_wrapper/GENIE3.R")
setwd("/home/jain/Placenta_Geo_Dataset/GRN_Dataset/DREAM-5/GENIE3_R_C_wrapper/GENIE3_R_C_wrapper/")
filePath<-"/home/jain/BCB570/Size_10/Size_10/DREAM4_training_data/insilico_size10_5/"
expr.matrix <- read.expr.matrix(paste0(filePath,"concatenateddata1.tsv"), form="rows.are.samples")
scaleData<-t(apply(expr.matrix,1,function(x){return((x-mean(x))/sd(x))}))
weight.matrix1 <- GENIE3(scaleData,ncores = 8, K="all",ntrees = 100)
link.list <- get.link.list(weight.matrix1)
write.table(link.list[link.list$weight >= quantile(link.list$weight,0.75),],paste0(filePath,"GENIE3-filterLinks.txt"),row.names = F,col.names = F,sep = "\t")


#WGCNA
library(WGCNA)
library(igraph)
options(stringsAsFactors = FALSE);
filePath<-"/home/jain/BCB570/Size_10/Size_10/DREAM4_training_data/insilico_size10_5/"
datExpr <- read.table(paste0(filePath,"concatenateddata1.tsv"),header = T);
datAdj= adjacency(datExpr,
                  type = "unsigned",
                  power = 1,
                  corFnc = "cor", corOptions = "use = 'p', method = 'spearman'")

diag(datAdj) <- 0
ig <- graph.adjacency(datAdj, mode="directed", weighted=TRUE)
edges<-get.edgelist(ig)
weights<-edge_attr(ig,"weight")
edgesWithWT<-data.frame(cbind(edges,weights))
write.table(edgesWithWT[edgesWithWT$weights >= quantile(weights,0.75),],paste0(filePath,"WGCNA-filterLinks.txt"),row.names = F,col.names = F,sep = "\t")

##ARACNE
filePath<-"/home/jain/BCB570/HW4_Yeast1-2/HW4_Yeast1-2/"
edgesWithWT <-read.table(paste0(filePath,"ARCANEedge.txt"),header = F);
write.table(edgesWithWT[edgesWithWT$V3 >= quantile(edgesWithWT$V3,0.75),],paste0(filePath,"ARCANE-filterLinks.txt"),row.names = F,col.names = F,sep = "\t")

##PR Curves
githubPage<-"https://raw.githubusercontent.com/ashishjain1988/BCB570/master/HW4/data/"
trainingData<-"training_data/insilico_size10_"
goldstandard<-"training_data/gold_standard/insilico_size10_"
library(Bolstad2)
AUCWGCNA<-c()
AUCGEN<-c()
AUCARCNE<-c()
AccWGCNA<-c()
AccGEN<-c()
AccARCNE<-c()
for(i in 1:5)
{
  filePath<-paste0(githubPage,trainingData,i,"/")
  WGCNA<-read.table(paste0(filePath,"WGCNA-PrecisionRecallValues.txt"),header = F)
  GEN<-read.table(paste0(filePath,"GENIE3-PrecisionRecallValues.txt"),header = F)
  ARACNE<-read.table(paste0(filePath,"ARCANE-PrecisionRecallValues.txt"),header = F)
  AUCWGCNA<-c(AUCWGCNA,sintegral(WGCNA$V2,WGCNA$V1)$int)
  AUCGEN<-c(AUCGEN,sintegral(GEN$V2,GEN$V1)$int)
  AUCARCNE<-c(AUCARCNE,sintegral(ARACNE$V2,ARACNE$V1)$int)
  #png(filename=paste0(filePath,"PR-Curve.png"), width = 1200, height = 800)
  ggplot(data.frame(WGCNA,ARACNE,GEN),aes(x=WGCNA$V2,y=WGCNA$V1,color="WGCNA")) + ggtitle("PR Curve Network 5") + xlab("Recall") + ylab("Precision") + geom_line() + geom_line(aes(x=GEN$V2,y=GEN$V1,color="GENIE3")) + geom_line(aes(x=ARACNE$V2,y=ARACNE$V1,color="ARCNE"))
  #dev.off()
  ##Accuracy
  goldStd<-read.table(paste0(githubPage,goldstandard,i,"_goldstandard.tsv")) %>% mutate(edge=paste0(V1,"-",V2))
  aracaneEdges<-read.table(paste0(filePath,"ARCANE-filterLinks.txt"),header = F) %>% mutate(edge=paste0(V1,"-",V2))
  WGCNAEdges<-read.table(paste0(filePath,"WGCNA-filterLinks.txt"),header = F) %>% mutate(edge=paste0(V1,"-",V2))
  GENEdges<-read.table(paste0(filePath,"GENIE3-filterLinks.txt"),header = F) %>% mutate(edge=paste0(V1,"-",V2))
  
  AccARCNE<-c(AccARCNE,length(intersect(goldStd$edge,aracaneEdges$edge))/length(goldStd$edge)*100)
  AccGEN<-c(AccGEN,length(intersect(goldStd$edge,GENEdges$edge))/length(goldStd$edge)*100)
  AccWGCNA<-c(AccWGCNA,length(intersect(goldStd$edge,WGCNAEdges$edge))/length(goldStd$edge)*100)
}
