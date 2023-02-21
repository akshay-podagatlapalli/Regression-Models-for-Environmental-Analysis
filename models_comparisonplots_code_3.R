library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(gridExtra)

setwd("C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/")

dUOA_data <- read.csv("Training Data Splitting Predictions.csv")

df_l <- dUOA_data %>%
  pivot_longer(
    cols = c(
      dUOA_AL,
      dUOA_AlogKOA,
      dUOA_logKOA,
      dUOA_Opera,
      dUOA_PaDEL,
      logKOA_AL,
      logKOA_AlogKOA,
      logKOA_logKOA,
      logKOA_Opera,
      logKOA_PaDEL,
      clusters_AL,
      clusters_AlogKOA,
      clusters_logKOA,
      clusters_Opera,
      clusters_PaDEL,
      randomized_AL,
      randomized_AlogKOA,
      randomized_logKOA,
      randomized_Opera,
      randomized_PaDEL
    ),
    names_to = "Predictions",
    values_to = "dUOA_Pred"
  )

df_l_2 <- df_l %>%
  pivot_longer(
    cols = c(
      SplittingdUOA,
      SplittinglogKOA,
      Splittingclusters,
      Splittingrandomized
    ),
    names_to = "SplittingType",
    values_to = "ValueType"
  )

compare_plots <- function(data) {
  ggplot(data,
         aes(x = Exp..endpoint,
             y = dUOA_Pred,
             color = ValueType)) +
    scale_shape(solid = FALSE) +
    geom_point() +
    geom_abline(
      intercept = 0,
      slope = 1,
      colour = "dimgray",
      linetype = "solid",
      size = 0.25
    ) +
    facet_wrap( ~ Predictions, nrow = 4, ncol = 5) +
    theme_classic()
}

plot_1 <- compare_plots(df_l_2)
plot_1

ggsave("SplittingTypes_Comparison.jpg", plot = last_plot(), device = "jpeg",
       path = "C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Plots",
       scale = 1, width = 30, height = 25, units = "cm", dpi = 320,
       limitsize = TRUE)

