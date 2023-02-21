library(dplyr)
library(ggplot2)
library(ggpubr)
library(gridExtra)
################################################################################

setwd("C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Plots_Data/")

data_1 <- read.csv("plots_data_AL.csv")
data_1$res <- data_1$dUOA_Pred - data_1$dUOA
data_2 <- read.csv("plots_data_AlogKOA.csv")
data_2$res <- data_2$dUOA_Pred - data_2$dUOA
data_3 <- read.csv("plots_data_logKOA.csv")
data_3$res <- data_3$dUOA_Pred - data_3$dUOA
data_4 <- read.csv("plots_data_Opera.csv")
data_4$res <- data_4$dUOA_Pred - data_4$dUOA
data_5 <- read.csv("plots_data_PaDEL.csv")
data_5$res <- data_5$dUOA_Pred - data_5$dUOA
data_6 <- read.csv("plots_data_Mintz.csv")
data_6$res <- data_6$dUOA_Pred - data_6$dUOA

################################################################################

##function to plot the data from all 6 dataframes
compare_plots <- function(data) {
  ggplot(data,
         aes(
           x = dUOA,
           y = dUOA_Pred,
           shape = DescriptorType,
           color = `Training.External`
         )) +
    scale_shape(solid = FALSE) +
    geom_point() +
    geom_abline(
      intercept = 0,
      slope = 1,
      colour = "dimgray",
      linetype = "solid",
      size = 0.25
    ) +
    geom_abline(
      intercept = 0,
      slope = 1.1,
      colour = "dimgray",
      linetype = "dashed",
      size = 0.25
    ) +
    geom_abline(
      intercept = 0,
      slope = 0.9,
      colour = "dimgray",
      linetype = "dashed",
      size = 0.25
    ) +
    theme_classic()
  
}

plot_1 <- compare_plots(data_1) + ggtitle("Model: AL")
plot_2 <- compare_plots(data_2) + ggtitle("Model: A logKOA")
plot_3 <- compare_plots(data_3) + ggtitle("Model: logKOA")
plot_4 <- compare_plots(data_4) + ggtitle("Model: nHBDon, MLFER_L")
plot_5 <- compare_plots(data_5) + ggtitle("Model: PaDEL")

ggarrange(
  plot_1,
  plot_2,
  plot_3,
  plot_4,
  plot_5,
  ncol = 3,
  nrow = 2,
  common.legend = TRUE,
  legend = "right"
)

################################################################################

##Function to plot all 6 residual plots from all 6 dataframes
residual_plots <- function(data) {
  ggplot(data, aes(x = dUOA, y = res)) +
    geom_point(
      aes(color = `Training.or.External.Dataset`,
          shape = `Descriptor.Combination`),
      na.rm = T,
      size = 1.2
    ) +
    geom_hline(
      yintercept = 0,
      colour = "dimgray",
      linetype = "solid",
      size = 0.25
    ) +
    #scale_colour_manual("Reliability Score:",
    #                    values = c("red", "blue", "green", "orange")) +
    
    #scale_shape_manual("Level of Polarity:",
    #                   values = c(1, 3, 4, 5)) +
    theme_pubr() +
    theme(legend.position = "right") +
    #scale_x_continuous(breaks = seq(from = -2, to = 15, by = 2)) +
    #scale_y_continuous(breaks = seq(from = -3, to = 3, by = 1)) +
    #coord_cartesian(xlim = c(-2, 15), ylim = c(-3, 3)) +
    #ggtitle("ppLFER, estimated solute descriptors") +
    xlab("Experimental Value") +
    ylab("Residual Value") +
    scale_shape(solid = FALSE) +
    theme (aspect.ratio = 1 / 2)
}

res_plot_1 <- residual_plots(data_1) + ggtitle("Model: AL")
res_plot_2 <- residual_plots(data_2) + ggtitle("Model: A logKOA")
res_plot_3 <- residual_plots(data_3) + ggtitle("Model: logKOA")
res_plot_4 <- residual_plots(data_4) + ggtitle("Model: nHBDon, MLFER_L")
res_plot_5 <- residual_plots(data_5) + ggtitle("Model: PaDEL")
res_plot_6 <- residual_plots(data_6) + ggtitle("Model: Mintz")

res_plot_1
res_plot_2
res_plot_3
res_plot_4
res_plot_5
res_plot_6

ggarrange(
  res_plot_1,
  res_plot_2,
  res_plot_3,
  res_plot_4,
  res_plot_5,
  res_plot_6,
  ncol = 2,
  nrow = 3,
  common.legend = FALSE,
  legend = "right"
)

ggarrange(
  res_plot_1,
  res_plot_6,
  ncol = 1,
  nrow = 2,
  common.legend = FALSE,
  legend = "right"
)

################################################################################

ggsave("Residuals_Comp.jpg", plot = last_plot(), device = "jpeg",
       path = "C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Plots",
       scale = 1, width = 40, height = 30, units = "cm", dpi = 320,
       limitsize = TRUE)




