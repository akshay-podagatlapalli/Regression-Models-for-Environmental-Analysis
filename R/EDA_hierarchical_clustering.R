library(readxl)
library(plyr)
library(dplyr)
library(factoextra)
library(corrplot)
library(ggplot2)
library(tidyverse)
library(writexl)
library(clValid)
library(vegan)
library(dendextend)

setwd(
  "C:/Users/Akshay/Documents/Research/dUOA data/Spreadsheets/QSAR Files"
)

QSAR_data <- read_excel("PaDEL Descriptors_Entire Dataset_Revised.xlsx")

#pubchem_data <- QSAR_data[, c(3, 1304:2184)]
pubchem_data <- QSAR_data[, c(2, 1305:2185)]

pubchem_data_HC <-
  pubchem_data %>% remove_rownames %>% column_to_rownames(var = "Name")

#pubchem_data_HC <-
#  scale(pubchem_data_HC) ##preparing data for HC by normalizing it.

pubchem_data_HC <- as.data.frame(pubchem_data_HC)

#dist_mat <- dist(pubchem_data_HC, method = 'euclidean')

# Hierarchical Agglomerative Clustering
h1 <- pubchem_data_HC %>% dist %>% hclust(method='average') %>% as.dendrogram
h2 <- pubchem_data_HC %>% dist %>% hclust(method='complete') %>% as.dendrogram
h3 <- pubchem_data_HC %>% dist %>% hclust(method='ward.D') %>% as.dendrogram
h4 <- pubchem_data_HC %>% dist %>% hclust(method='single') %>% as.dendrogram

# cut tree
cluster1=cutree(h1, 4)
cluster2=cutree(h2, 4)
cluster3=cutree(h3, 4)
cluster4=cutree(h4, 4)

dunn(dist_mat, cluster1)
dunn(dist_mat, cluster2)
dunn(dist_mat, cluster3)
dunn(dist_mat, cluster4)

# Cophenetic Distances, for each linkage
c1=cophenetic(h1)
c2=cophenetic(h2)
c3=cophenetic(h3)
c4=cophenetic(h4)

cor(dist_mat,c1) 
cor(dist_mat,c2) 
cor(dist_mat,c3) 
cor(dist_mat,c4)

compare_clusters <- function(data_1, data_2, data_3, data_4, size){
  par(mfrow=c(4,1))
  cols = c('red', 'green', 'blue', 'pink')
  plot(data_1, main='Average Linkage')
  cut_avg_h1 <- cutree(data_1, k = 4)
  rect.dendrogram(data_1 , k = 4, border = cols)
  plot(data_2, main='Complete Linkage')
  cut_avg_h2 <- cutree(data_2, k = 4)
  rect.dendrogram(data_2 , k = 4, border = cols)
  plot(data_3, main="Ward's Linkage")
  cut_avg_h3 <- cutree(data_3, k = 4)
  rect.dendrogram(data_3 , k = 4, border = cols)
  plot(data_4, main='Single Linkage')
  cut_avg_h4 <- cutree(data_4, k = 4)
  rect.dendrogram(data_4 , k = 4, border = cols)
}

#plot <- compare_clusters(h1, h2, h3, h4, 1)

png(filename = "C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Plots/CompareCluster.png",
    width = 2000,
    height = 1600)
plot <- compare_clusters(h1, h2, h3, h4, 1) 
dev.off()
