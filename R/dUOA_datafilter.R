library(readxl)
library(tidyr)
library(dplyr)
library(plyr)
library(ggplot2)
library(hablar)
library(data.table)
library(writexl)

setwd("C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Raw Data/")

#selecting the data
koa_data <- read_excel("1.0-KOA and dHOA Data.xlsx", sheet="KOA Data")

count_CT_01 <- koa_data%>%
  group_by(ChemID) %>%
  dplyr::summarise(n())

#selecting the columns of interest
#filtering out chemicals with <= 3 data-points
fil_ChemID <- koa_data %>%
  select(ChemID, Chemical_Name, Cas_No, Temp, log_KOA, methID, Citation) %>%
  group_by(ChemID) %>%
  filter(n() > 3) 

count_CT <- fil_ChemID %>%
  group_by(ChemID) %>%
  dplyr::summarise(n()) 

dupeCT <- fil_ChemID %>%
  find_duplicates(ChemID, Temp) %>%
  group_by(Temp, ChemID) %>%
  dplyr::summarise(count = n()) %>%
  dplyr::rename(`#duplicates` = count) %>%
  pivot_wider(names_from = Temp, values_from = Temp, values_fill = 0)
  
dupeCT <- ddply(dupeCT, "ChemID", numcolwise(sum))

UniCT <- fil_ChemID %>%
  distinct(ChemID, Temp, .keep_all = TRUE) %>%
  dplyr::summarise(n())

count_CT <- count_CT %>%
  inner_join(UniCT, by = c("ChemID" = "ChemID")) %>%
  dplyr::rename(unique_dps = `n().y`,inital_dps =`n().x`) %>%
  full_join(dupeCT, by = c("ChemID" = "ChemID"))

fil_Temp <- count_CT %>%
  dplyr::filter(`unique_dps` <= 3)

fil_CT <- anti_join(fil_ChemID, fil_Temp, by = c("ChemID" = "ChemID"))
fil_CT_summary <- fil_CT %>%
  group_by(ChemID)%>%
  dplyr::summarise()

#calculating the ln Koa and 1/Temp values for all data-points
for(i in 1:ncol(fil_CT)) {
  fil_CT$`1/Temp` <- 1/(fil_CT$Temp + 273.15)
  fil_CT$`ln_KOA` <- log(10) * fil_CT$log_KOA
}

#obtaining the summary of filtered table
#calculating the difference between the min and max temperatures
sum_filCT <- fil_CT %>%
  group_by(ChemID) %>%
  dplyr::summarise(n(), Chemical_Name = min(Chemical_Name), 
                   Cas_No = min(Cas_No), minTemp = min(Temp), maxTemp = max(Temp))
  sum_filCT$`T_Diff` <- sum_filCT$`maxTemp` - sum_filCT$`minTemp`

#performing regression on the data-points for all chemicals 
lr <- sapply(split(fil_CT, fil_CT$ChemID, sep = '\n'), function(x) {
  model <- lm(ln_KOA ~ `1/Temp`, data = x)
  c(coef(model), R2 = summary(model)[['r.squared']])
})

#converting the "lr" datatype from matrix to the dataframe "slopes"
lr2 <- unlist(lr)
attributes(lr2) <- attributes(lr)
slopes <- transpose(as.data.frame(lr2))

colnames(slopes) <- rownames(lr2)
rownames(slopes) <- colnames(lr2)
setDT(slopes, keep.rownames = "ChemID")

dUOA <- full_join(sum_filCT, slopes, by = c("ChemID" = "ChemID"))

dUOA$`(Intercept)` <- NULL
names(dUOA)[names(dUOA) == '`1/Temp`'] <- 'slope'
names(dUOA)[names(dUOA) == 'n()'] <- 'count'
  
dUOA$`dUOA` <- dUOA$slope * 0.008314

write_xlsx(
  dUOA,
  "C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Raw Data/2.0-dUOA Data.xlsx"
)

#identify chemIDs with R^2 less than 0.95
low_r <- dUOA %>%
  group_by(ChemID, R2) %>%
  dplyr::filter(`R2` < 0.95) 

low_rd <- low_r %>%
  group_by(ChemID, R2) %>%
  select(ChemID, R2) 
low_rd <- semi_join(fil_CT, low_rd, by = c("ChemID" = "ChemID"))


ggplot(low_rd,aes(x = `1/Temp`, y = ln_KOA)) +
  geom_point(aes(colour = factor(methID)), show.legend = FALSE) + 
  geom_smooth(method = 'lm', se = FALSE) + 
  geom_smooth(method = 'lm', aes(colour = factor(methID)), se = FALSE, show.legend = FALSE) +
  facet_wrap(~Chemical_Name, ncol = 6, nrow = 6, scales = "free", shrink = FALSE)

#ggsave("Plots.jpg", plot = last_plot(), device = "jpeg",
#       path = "C:/Users/aksha/Documents/Research/dUOA data",
#       scale = 1, width = 17, height = 21, units = "cm", dpi = 320,
#       limitsize = TRUE)