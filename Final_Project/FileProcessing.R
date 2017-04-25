library("igraph")
library("MCL")

getRandomNetworkDetails<-function(graph)
{
  randomNetwork <- erdos.renyi.game(vcount(graph), ecount(graph),type='gnm')
  output1<-average.path.length(graph)
  output2<-average.path.length(randomNetwork)
  output3<-transitivity(graph, type="global")
  output4<-transitivity(randomNetwork, type="global")
  output5<-graph.density(graph)
  output6<-graph.density(randomNetwork)
  
  return(c(output1,output2,output3,output4,output5,output6))
}

graphPearson<-graph.data.frame(as.matrix(read.table("Breast-CancerResults/larg-sub-network-pearson-edgeList.csv",sep = sep,row.names = 1,header = T)),directed = FALSE)
graphSpearman<-graph.data.frame(as.matrix(read.table("Breast-CancerResults/larg-sub-network-spearman-edgeList.csv",sep = sep,row.names = 1,header = T)),directed = FALSE)

graphPeasrsonProp<-getRandomNetworkDetails(graphPearson)
graphSpearmanProp<-getRandomNetworkDetails(graphSpearman)

details<-c("Average Path Length-Graph","Average Path Length-Random Graph","Clustering Coefficient-Graph","Clustering Coefficient-Random Graph","Density-Graph","Denisty-RandomGraph")
table<-data.frame(Features=details,Graph_P=graphPeasrsonProp,Graph_S=graphSpearmanProp)
write.table(table , file = "BC-random-networkcomparison.csv", sep=",",dec=".",quote = F) ##Save edgelist file

##MCL Code
getModules<-function(graph,type){
  adjacencyMatrix<-get.adjacency(graph)
  groups<-mcl(x=adjacencyMatrix,addLoops=TRUE)$Cluster
  
  geneNames<-colnames(adjacencyMatrix)
  groupsNames<-unique(groups)
  for (g in groupsNames){
    module=geneNames[which(groups==g)]
    write.table(module, paste("module_",g,type, ".txt",sep=""), sep="\t", row.names=FALSE, col.names=FALSE,quote=FALSE)
  }
}

getModules(graphPearson,"pearson")
getModules(graphSpearman,"spearman")


# proteome <- read.table("/home/jain/BCB570/Final_project/Proteome_Data/77_cancer_proteomes_CPTAC_itraq-filt.csv", header=T, sep="," , row.names=1) ##Input expression matrix
# proteomeVal<-proteome[,3:ncol(proteome)]
# dim(proteomeVal[apply(proteomeVal,MARGIN = 1, function(x) all(!is.na(x))), ])
# 
# bcdata <- read.table("/home/jain/BCB570/Final_project/Normal-Breast-Samples/allsamplesFPKM-normalBC-genes.txt", header=F, sep=" " , row.names=2) ##Input expression matrix
# bcdataVal<-bcdata[,2:ncol(bcdata)]
# bcdataVal<-bcdataVal[apply(bcdataVal,MARGIN = 1, function(x) any(x>=1)), ]
# write.table(bcdataVal,"/home/jain/BCB570/Final_project/Normal-Breast-Samples/allsamplesFPKM-normalBC-genes-filtgt1.txt", sep="," , quote = F,col.names = F) ##Input expression matrix
# 
