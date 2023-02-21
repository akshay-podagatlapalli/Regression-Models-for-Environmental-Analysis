##load libraries

library(gridExtra) #used for grid arrange function
library(tidyverse)
library(readxl)
library(ggplot2)
library(viridis) # for the colour palette

#the plot has some customization. Feel free to change colour palettes, backgrounds, etc. as you like.
setwd("C:/Users/aksha/Documents/Research/dUOA data")

#load file
### I use csv files in R, but excel should work too!
data <- read_excel("data.xlsx")

#create a blank list
plots <- list()

#for each unique ChemID run the following
for (i in unique(data$ChemID)) {
  #filter the low_rd list to include only data from the ChemID of interest
  a <- data[data$ChemID == i, ]
  
  #create a list of plots
  plots[[i]] <- ggplot(a, aes(x = `1/Temp`, y = ln_KOA))  +
    # create scatter plot with different colours and shapes for each citation
    geom_point(aes(colour = Citation, shape = Citation), size = 2) +
    #use the viridus colour palette
    scale_colour_viridis_d() +
    #create a black dashed line of best fit
    geom_smooth(
      method = 'lm',
      se = FALSE,
      colour = "black",
      linetype = "dashed"
    ) +
    #create a line of best fit for each citation
    geom_smooth(method = 'lm', aes(colour = factor(Citation)), se = FALSE) +
    #label y axis ln KOA
    ylab(expression(paste("ln K"[OA]))) +
    #label x axis 1/T(K)
    xlab ("1/T(K)") +
    #use bw theme
    theme_bw() +
    theme(
      #remove background behind legend icons
      legend.key = element_blank(),
      #remove legend title
      legend.title = element_blank(),
      #make area behind legend text white and semi transparent
      legend.background = element_rect(fill = alpha('white', 0.1)),
      #move the legend to the top right (x, y) coordinates
      legend.position = c(0.15, 0.75)
    ) +
    #name the plot using the chemical name
    ggtitle(paste0(a$Chemical_Name))
  
}

#arrange 4 plots at a time in 2 columns
graph1 <- do.call("grid.arrange", c(grobs = plots[1:4], ncol = 2))

graph2 <- do.call("grid.arrange", c(grobs = plots[5:8], ncol = 2))

graph3 <- do.call("grid.arrange", c(grobs = plots[9:12], ncol = 2))

graph4 <- do.call("grid.arrange", c(grobs = plots[13:18], ncol = 2))

graph5 <- do.call("grid.arrange", c(grobs = plots[19:22], ncol = 2))

graph6 <- do.call("grid.arrange", c(grobs = plots[23:25], ncol = 2))

ggsave("graph1.jpg", plot = graph1, device = "jpeg",
       path = "C:/Users/aksha/Documents/Research/dUOA data",
       scale = 1, width = 25, height = 25, units = "cm", dpi = 320,
       limitsize = TRUE)

ggsave("graph2.jpg", plot = graph2, device = "jpeg",
       path = "C:/Users/aksha/Documents/Research/dUOA data",
       scale = 1, width = 25, height = 25, units = "cm", dpi = 320,
       limitsize = TRUE)

ggsave("graph3.jpg", plot = graph3, device = "jpeg",
       path = "C:/Users/aksha/Documents/Research/dUOA data",
       scale = 1, width = 25, height = 25, units = "cm", dpi = 320,
       limitsize = TRUE)

ggsave("graph4.jpg", plot = graph4, device = "jpeg",
       path = "C:/Users/aksha/Documents/Research/dUOA data",
       scale = 1, width = 25, height = 25, units = "cm", dpi = 320,
       limitsize = TRUE)

ggsave("Plots.jpg", plot = last_plot(), device = "jpeg",
       path = "C:/Users/aksha/Documents/Research/dUOA data",
       scale = 1, width = 17, height = 21, units = "cm", dpi = 320,
       limitsize = TRUE)

ggsave("Plots.jpg", plot = last_plot(), device = "jpeg",
       path = "C:/Users/aksha/Documents/Research/dUOA data",
       scale = 1, width = 17, height = 21, units = "cm", dpi = 320,
       limitsize = TRUE)
#You will need to save each of these files. As you save them they may render a little different due to scales.
## For example the position of the legends may shift, the size of the points may be too large or too small. 
## Render graph1 first and see how that appears as a jpg file, then modify the code for the plot in the "for loop".