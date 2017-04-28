library(igraph)

Cancer <- graph_from_edgelist(as.matrix(read.csv("Cor_Network7_Combined.csv",header = T, sep = ",")),directed = F)
cancerNetwork <- simplify(Cancer,remove.multiple = T, remove.loops = T)
Normal <- graph_from_edgelist(as.matrix(read.csv("Cor_Network7_Cold.csv",header = T, sep = ",")),directed = F)
normalNetwork<-simplify(Normal,remove.multiple = T, remove.loops = T)

gsize(cancerNetwork)
gsize(normalNetwork)

Diff_Cancer_normal <- cancerNetwork %m% normalNetwork
Diff_normal_cancer <- normalNetwork %m% cancerNetwork

gsize(Diff_Cancer_normal)
gsize(Diff_normal_cancer)

gorder(Diff_Cancer_normal)
gorder(Diff_normal_cancer)

gorder(cancerNetwork)
gorder(normalNetwork)

# data<-read.table("/Users/jain/Desktop/test.txt",sep = "\t")
# ggplot(data[with(data, order(-V2)), ],aes(x=reorder(V1,V2),y=V2))+
# geom_bar(stat = 'identity', fill = 'orange')+
#   coord_flip()+
#   theme_bw()+
#   theme(plot.title = element_text(hjust = 0.5))+
#   labs(x='GO Biological Processes Terms', y = '-LOG10(FDR)')+
#   ggtitle('Module M3 GO Biological Processes Terms')

