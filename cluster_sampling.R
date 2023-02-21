library(dplyr)
library(writexl)

setwd("C:/Users/Akshay/Desktop")

df <- read.csv("test.csv")

sub_df <- df %>%
  select(Name, clusters) %>%
  group_by(clusters) %>%
  sample_frac(0.25)
sub_df$splitting <- 2 

df1 <- left_join(df, sub_df, by="Name")
drop <- c("clusters.y")
df1 = df1[,!(names(df1) %in% drop)]

df1 <- df1 %>% 
  dplyr::rename(clusters = `clusters.x`)

write_xlsx(df1,"C:/Users/Akshay/Documents/Research/dUOA data/cluster_splitting.xlsx")
