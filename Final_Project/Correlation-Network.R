library("tidyverse")
library("igraph")
setwd("")
Exp_table = read.table("allsamplesFPKM-BreastCancer-genes-filtgt1.txt", header=F, sep="," , row.names=1) ##Input expression matrix
Cor_table_spearman = cor(t(Exp_table), method = "spearman") #Generate Correlation matrix
Cor_table_pearson = cor(t(Exp_table), method = "pearson") #Generate Correlation matrix
#write.table(Cor_table, file ="Cor_table.csv", sep =',', dec=".") ##Save correlation matrix
rm(Exp_table)
diag(Cor_table) <- 0

findThreshold<-function(Cor_table)
{
  thresholdMatrix<-matrix(0,nrow = length(seq(0.01,1,by=0.01)),ncol = 2)
  count<-1
  for(i in seq(0.01,1,by=0.01))
  {
    sig_values <- which(Cor_table>=i, arr.ind=TRUE)
    Cor_Edges <- data.frame(rownames(Cor_table)[sig_values[,1]],colnames(Cor_table)[sig_values[,2]])
    graphGraph1<-graph.data.frame(Cor_Edges,directed = FALSE)
    graphGraph<-simplify(graphGraph1,remove.multiple = TRUE, remove.loops = TRUE, edge.attr.comb = igraph_opt("edge.attr.comb"))
    thresholdMatrix[count,1]<-i
    thresholdMatrix[count,2]<-graph.density(graphGraph)
    count <- count + 1
  }
  ggplot(data = thresholdMatrix,aes(x = X1, y = X2)) + geom_point() + geom_line()
}
findThreshold(Cor_table_pearson)
findThreshold(Cor_table_spearman)

sig_values <- which(Cor_table_pearson>=0.7, arr.ind=TRUE) 
Cor_Edges <- data.frame(rownames(Cor_table)[sig_values[,1]],colnames(Cor_table)[sig_values[,2]]) ##Build a table with Correlation values > 0.6.
write.table(Cor_Edges , file = "Cor_Network_BC_pearson.csv", sep=",",dec=".",col.names=T,row.names=F) ##Save edgelist file

sig_values <- which(Cor_table_spearman>=0.7, arr.ind=TRUE) 
Cor_Edges <- data.frame(rownames(Cor_table)[sig_values[,1]],colnames(Cor_table)[sig_values[,2]]) ##Build a table with Correlation values > 0.6.
write.table(Cor_Edges , file = "Cor_Network_BC_spearman.csv", sep=",",dec=".",col.names=T,row.names=F) ##Save edgelist file