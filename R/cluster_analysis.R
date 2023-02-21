## Code to cluster chemical data based on physiochemical properties 

library(dplyr)
library(writexl)

# setting up the directory
setwd("C:/Users/Akshay/Desktop")

# reading in the file
df <- read.csv("test.csv")

# creating df based on the clusters col 
# and sampling 1/4 of the data
sub_df <- df %>%
  select(Name, clusters) %>%
  group_by(clusters) %>%
  sample_frac(0.25)
sub_df$splitting <- 2 

# data manipulation
df1 <- left_join(df, sub_df, by="Name")
drop <- c("clusters.y")
df1 = df1[,!(names(df1) %in% drop)]

df1 <- df1 %>% 
  dplyr::rename(clusters = `clusters.x`)

# creating a new spreadsheet based on the analysis ab
write_xlsx(df1,"C:/Users/Akshay/Documents/Research/dUOA data/cluster_splitting.xlsx")
