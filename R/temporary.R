library(readxl)
library(tidyr)
library(dplyr)
library(plyr)
library(ggplot2)
library(hablar)
library(data.table)
library(writexl)

setwd("C:/Users/aksha/Documents/Research/dUOA data")

low_rd <- read_excel("low_rd.xlsx")

ggplot(low_rd,aes(x = x, y = y)) +
  geom_point(aes(colour = factor(source)), show.legend = FALSE) + 
  geom_smooth(method = 'lm', se = FALSE) + 
  geom_smooth(method = 'lm', aes(colour = factor(source)), se = FALSE, show.legend = FALSE) +
  facet_wrap(~id, scales = "free", shrink = FALSE)
