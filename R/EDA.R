library(readxl)
library(plyr)
library(dplyr)
library(factoextra)
library(corrplot)
library(ggplot2)
library(tidyverse)
library(writexl)
library(dendextend)
library(cluster)
library(NbClust)
library(clValid)
library(vegan)
library(dendextend)

setwd(
  "C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Raw Data/"
)

##### PCA #####################################################

pca_data <- read_excel("3.1-Molecular Descriptors (Abraham & PaDEL).xlsx", sheet = "Abraham Descriptors")
cluster_analysis <- read_excel("3.1-Molecular Descriptors (Abraham & PaDEL).xlsx", sheet = "Pubchem Fingerprints")


absolv_data <- pca_data %>%
  select(`Names/Acronyms`, E, S, A, B, V...10, L, `log KOA`) %>% 
  remove_rownames %>%
  column_to_rownames(var = "Names/Acronyms")

absolv.pca <-
  prcomp(absolv_data, scale = TRUE) ## function performs PCA
fviz_eig(absolv.pca, addlabels = TRUE)  ## function displays scree plot

## function provides summary of PCA
summary(absolv.pca)

## function to display the names of all chemicals on the plots.
#options(ggrepel.max.overlaps = Inf)

## Individual PCA plot
ind_pca <-
  fviz_pca_ind(
    absolv.pca,
    col.ind = "cos2",
    gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
    repel = TRUE
  )
ind_pca

descriptors <-
  get_pca_var(absolv.pca) ## The variables used for PCA
corrplot(descriptors$contrib, is.corr = FALSE) ## Correlation Matrix Plot

## displays the contribution of each variable to PCA Dimensions
descriptors$coord

fviz_pca_var(
  ## Graph of Variables for PCA
  absolv.pca,
  col.var = "contrib",
  gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
  repel = TRUE
)

## Biplot of individuals and Variables
fviz_pca_biplot(absolv.pca,
                
                repel = TRUE,
                col.var = "#2E9FDF",
                col.ind = "#696969")

######  Pubchem Fingerprints df  ###############################################

pubchem_data <- cluster_analysis[,c(2, 4:884)]

names(pubchem_data)

####  Hierarchical Clustering ##################################################

pubchem_data_HC <-
  pubchem_data %>% remove_rownames %>% column_to_rownames(var = "Names/Acronyms")

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

cols = c('red', 'green', 'blue', 'pink')
plot(h1, main='Average Linkage')
cut_avg_h1 <- cutree(h1, k = 4)
rect.dendrogram(h1 , k = 4, border = cols)
plot(h2, main='Complete Linkage')
cut_avg_h2 <- cutree(h2, k = 4)
rect.dendrogram(h2 , k = 4, border = cols)
plot(h3, main="Ward's Linkage")
cut_avg_h3 <- cutree(h3, k = 4)
rect.dendrogram(h3, k = 4, border = cols)
plot(h4, main='Single Linkage')
cut_avg_h4 <- cutree(h4, k = 4)
rect.dendrogram(h4, k = 4, border = cols)


compare_clusters <- function(data_1, data_2, data_3, data_4, size){
  par(mfrow=c(2,2))
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

plot <- compare_clusters(h1, h2, h3, h4, 1)

##### k - means clustering #####################################################

pubchem_data_kmc <-
  pubchem_data %>% remove_rownames %>% column_to_rownames(var = "Names/Acronyms")

#pubchem_data_kmc <-
#  scale(pubchem_data_kmc[, c(0:32)]) ##preparing data for kmc by normalizing it.

NbClust(
  data = pubchem_data_kmc,
  distance = "binary",
  min.nc = 2,
  max.nc = 15,
  method = "complete"
)

fviz_nbclust(pubchem_data_kmc, kmeans, method = "gap_stat") +
  labs(subtitle = "Gap statistic method")
fviz_nbclust(pubchem_data_kmc, kmeans, method = "silhouette") +
  labs(subtitle = "Silhoette method")
fviz_nbclust(pubchem_data_kmc, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2) +
  labs(subtitle = "Elbow method")


pubchem.cluster <- kmeans(pubchem_data_kmc, 4)
pubchemRes <- factor(pubchem.cluster$cluster)

cluster_plot <- fviz_cluster(
  pubchem.cluster,
  data = pubchem_data_kmc,
  repel = TRUE,
  ellipse.type = "t"
)

cluster_plot

pubchem.pam <- pam(pubchem_data, 6)
fviz_cluster(pubchem.pam, repel = TRUE, ellipse.type = "t")

## k - means w/ functional groups

func_data <- read_excel("functional_groups.xlsx")

func_data_kmc <-
  func_data %>% remove_rownames %>% column_to_rownames(var = "Names/Acronym")

func_data_kmc <-
  scale(func_data_kmc)

fviz_nbclust(func_data_kmc, kmeans, method = "gap_stat") +
  labs(subtitle = "Gap statistic method")
fviz_nbclust(func_data_kmc, kmeans, method = "silhouette") +
  labs(subtitle = "Silhoette method")
fviz_nbclust(func_data_kmc, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2) +
  labs(subtitle = "Elbow method")

func.cluster <- kmeans(func_data_kmc, 4)
#pubchemRes <- factor(pubchem.cluster$cluster)

func_cluster_plot <- fviz_cluster(
  func.cluster,
  data = func_data_kmc,
  repel = TRUE,
  ellipse.type = "t"
)

func_cluster_plot

func_data.pam <- pam(func_data_kmc, k = 4)
fviz_cluster(func_data.pam, repel = TRUE, ellipse.type = "t")

NbClust(
  data = func_data_kmc,
  distance = "euclidean",
  min.nc = 2,
  max.nc = 15,
  method = "kmeans"
)

################################################################################

QSAR_data$clusters <- pubchem_data$cluster_cntr

fviz_pca_ind(
  absolv.pca,
  #geom.ind = "point", # show points only (nbut not "text")
  col.ind = QSAR_data$clusters,
  # color by groups
  addEllipses = TRUE,
  # Concentration ellipses
  repel = TRUE,
  legend.title = "Groups"
)

################################################################################

ggsave(
  "pca-biplot_filtered_data.jpg",
  plot = last_plot(),
  device = "jpeg",
  path = "C:/Users/Akshay/Desktop",
  scale = 1,
  width = 30,
  height = 21,
  units = "cm",
  dpi = 320,
  limitsize = TRUE
)

################################################################################

write_xlsx(QSAR_data,
           "C:/Users/Akshay/Documents/Research/QSAR_data(euclidean-complete).xlsx")
