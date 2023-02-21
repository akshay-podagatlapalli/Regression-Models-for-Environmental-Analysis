library(readxl)
library(tidyr)
library(plyr)
library(hablar)
library(openxlsx)

# setting up the working directory and reading in the file
setwd("C:/Users/aksha/Documents/Research/dUOA data/spreadsheets")
dUOA <- read_excel('dUOA.xlsx')

# filtering out records based on certain values
fil_dUOA <- dUOA %>%
  filter(`Diff(Calc-Exp)` > 4.50 & `dUOA (Exp)` != "NA")

# joining tables based on R^2 < 0.95 and fil_dUOA values
diff_n_R2 <- fil_dUOA %>%
  semi_join(low_r, fil_dUOA, by = c("ChemID" = "ChemID"))

# performing anti join based on the diff_n_R2 table to exclude 
# records from that df 
only_dUOA <- fil_dUOA %>%
  anti_join(diff_n_R2, fil_dUOA, by = c("ChemID" = "ChemID"))

# join tables based on the the low R^2 values and combining the primary keys 
# from the dUOA table
only_R2 <- anti_join(low_r, diff_n_R2, by = c("ChemID" = "ChemID"))
only_R2 <-  semi_join(dUOA, only_R2, by = c("ChemID" = "ChemID")) %>%
  filter(`dUOA (Exp)` != "NA")

# creating spreadsheets for the transformed datasets from the above
data_cleaning <- createWorkbook()
addWorksheet(data_cleaning, sheetName = "diff_n_R2")
addWorksheet(data_cleaning, sheetName = "only_dUOA")
addWorksheet(data_cleaning, sheetName = "only_R2")

# write the data to the spreadsheets
writeData(data_cleaning, sheet = 1, x = diff_n_R2)
writeData(data_cleaning, sheet = 2, x = only_dUOA)
writeData(data_cleaning, sheet = 3, x = only_R2)

# saving the spreadsheet
saveWorkbook(data_cleaning, file = "C:/Users/aksha/Documents/Research/dUOA data/data_cleaning.xlsx")

# joining the data for each of the sheets from the spreadsheet abv
data_diffnR2 <- diff_n_R2 %>%
  group_by(ChemID) %>%
  select(ChemID) 
data_diffnR2 <- semi_join(fil_CT, data_diffnR2, by = c("ChemID" = "ChemID"))

# joining the data for each of the sheets from the spreadsheet abv
data_OnlyDiff <- only_dUOA %>%
  group_by(ChemID) %>%
  select(ChemID) 
data_OnlyDiff <- semi_join(fil_CT, data_OnlyDiff, by = c("ChemID" = "ChemID"))

# joining the data for each of the sheets from the spreadsheet abv
data_OnlyR2 <- only_R2 %>%
  group_by(ChemID) %>%
  select(ChemID) 
data_OnlyR2 <- semi_join(fil_CT, data_OnlyR2, by = c("ChemID" = "ChemID"))


ggplot(data_OnlyR2,aes(x = `1/Temp`, y = ln_KOA)) +
  geom_point(aes(colour = factor(Citation)), show.legend = FALSE) + 
  geom_smooth(method = 'lm', se = FALSE) + 
  geom_smooth(method = 'lm', aes(colour = factor(Citation)), se = FALSE, show.legend = FALSE) +
  facet_wrap(~ChemID, scales = "free", shrink = FALSE)

ggsave("Plots.jpg", plot = last_plot(), device = "jpeg",
       path = "C:/Users/aksha/Documents/Research/dUOA data",
       scale = 1, width = 30, height = 30, units = "cm", dpi = 320,
       limitsize = TRUE)
