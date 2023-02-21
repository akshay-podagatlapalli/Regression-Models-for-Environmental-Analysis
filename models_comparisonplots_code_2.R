library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(writexl)
library(gridExtra)

setwd("C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Raw Data/")

dUOA_data <- read_excel("dUOA-Data_AP_2021-09-17.xlsx")
df <- dUOA_data %>%
  select(
    `Training/External`,
    Opera_descriptor_Type,
    PaDEL_descriptor_Type,
    AL_descriptor_type,
    AlogKOA_descriptor_Type,
    logKOA_descriptor_Type,
    dUOA,
    dUOA_ALPred,
    dUOA_AlogKOAPred,
    dUOA_logKOAPred,
    dUOA_OperaPred,
    dUOA_PaDELPred
  )

df_l <- df %>%
  pivot_longer(
    cols = c( dUOA_ALPred,
              dUOA_AlogKOAPred,
              dUOA_logKOAPred,
              dUOA_OperaPred,
              dUOA_PaDELPred), 
    names_to = "ModelType",
    values_to = "dUOA_Pred")

df_l_2 <- df_l %>%
  pivot_longer(
    cols = c( Opera_descriptor_Type,
              PaDEL_descriptor_Type,
              AL_descriptor_type,
              AlogKOA_descriptor_Type,
              logKOA_descriptor_Type), 
    names_to = "SomeType",
    values_to = "DescriptorType")


compare_plots <- function(data) {
    plt <- ggplot(
      data,
      aes(
        x = dUOA,
        y = dUOA_Pred,
        shape = DescriptorType,
        color = `Training/External`)) +
      scale_shape(solid = FALSE) +
      geom_point() +
      geom_abline(
        intercept = 0,
        slope = 1,
        colour = "dimgray",
        linetype = "solid",
        size = 0.25) +
      theme_classic() +
  facet_wrap(~ModelType)
}

plot <- compare_plots(df_l_2)
plot
