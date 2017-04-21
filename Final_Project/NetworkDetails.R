library("igraph")

graphDetails<-function(edgeFile,sep)
{
  graph<-as.matrix(read.table(edgeFile,sep = sep,header = T))
  graphGraph1<-graph.data.frame(graph,directed = FALSE)
  graphGraph<-simplify(graphGraph1,remove.multiple = TRUE, remove.loops = TRUE,edge.attr.comb = igraph_opt("edge.attr.comb"))
  graphDetails<-c(vcount(graphGraph), ecount(graphGraph), graph.density(graphGraph),diameter(graphGraph), radius(graphGraph), transitivity(graphGraph, type = "average"),transitivity(graphGraph, type = "global"),mean_distance(graphGraph),length(decompose.graph(graphGraph)))
  return(list(graphDetails,graphGraph))
}

#path<-"https://raw.githubusercontent.com/ashishjain1988/BCB570/master/HW3/"
outputPearson<-graphDetails(paste0("Cor_Network_BC_pearson.csv"),",")
outputSpearman<-graphDetails(paste0("Cor_Network_BC_spearman.csv"),",")

details<-c("Number of Nodes","Number of Edges","Graph Density","Diameter","Radius","Average Clustering Coefficent","Global Clustering Coefficent","Average Shortest Path","Number of Modules")
table<-data.frame(Properties=details,"Pearson"=outputPearson[[1]],"Spearman"=outputSpearman[[1]])
write.table(table , file = "networkDetails.csv", sep=",",dec=".",quote = F) ##Save edgelist file
#table %>% knitr::kable(caption = "PPI Details of the Network")

graphPearson<-outputPearson[[2]]
graphSpearman<-outputSpearman[[2]]

gdetails<-function(graphGraph1)
{
  graphGraph<-simplify(graphGraph1,remove.multiple = TRUE, remove.loops = TRUE,edge.attr.comb = igraph_opt("edge.attr.comb"))
  graphDetails<-c(vcount(graphGraph), ecount(graphGraph), graph.density(graphGraph),diameter(graphGraph), radius(graphGraph), transitivity(graphGraph, type = "average"),transitivity(graphGraph, type = "global"),mean_distance(graphGraph))
  return(graphDetails)
}

largestSubNet<-function(graph)
{
  dGraph<-decompose.graph(graph)
  lgraph<-dGraph[[1]]
  for(i in 1:length(dGraph))
  {
    if(vcount(lgraph) < vcount(dGraph[[i]]))
    {
      lgraph <- dGraph[[i]]
    }
  }
  return(lgraph)
}

lgraphPearson<-largestSubNet(graphPearson)
lgraphSpearman<-largestSubNet(graphSpearman)
details<-c("Number of Nodes","Number of Edges","Graph Density","Diameter","Radius","Average Clustering Coefficent","Global Clustering Coefficent","Average Shortest Path")
table<-data.frame(Properties=details,"Pearson"=gdetails(lgraphPearson),"Spearman"=gdetails(lgraphSpearman))
write.table(table , file = "larg-sub-networkDetails.csv", sep=",",dec=".",quote = F) ##Save edgelist file
write.table(get.edgelist(lgraphPearson) , file = "larg-sub-network-pearson-edgeList.csv", sep=",",dec=".",quote = F) ##Save edgelist file
write.table(get.edgelist(lgraphSpearman) , file = "larg-sub-network-spearman-edgeList.csv", sep=",",dec=".",quote = F) ##Save edgelist file
#table %>% knitr::kable(caption = "PPI Details of largest connected sub-network")
