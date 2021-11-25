library(tidyverse)
library(viridis)
library(ggplot2)
library(grid)
library(gridExtra)
library(GGally)
library(ggtext)
library(ggpubr)
library(cowplot)
library(readxl)

#function to round all digits in a dataframe
round_df <-
  function(df,                                                 #Specify data frame
           digits)                                             #Number of digits to round to
  {
    nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))     #Identify all columns with numerical data
    df[, nums] <- round(df[, nums], digits = digits)           #Round values of these columns to specified digits
    (df)                                                       #Print data frame
  }

#```{r Load Sample Data}```
setwd("C:/Users/Akshay/Documents/Research/dUOA data/Spreadsheets/Data Analysis")

data <- read_excel("ALL_DATA_2021-07-27.xlsx")

plot_1_est <- data %>%                     #calling the datafile
  filter(!is.na(data$dUOA)) %>%     #only include values where the model has an estimate. If a value is NA it is not plotted.
  ggplot () +                              #call ggplot
  geom_abline(                            #add a diagonal line where m = 1 and b = 0
    intercept = 0,                         # this is the 1:1 line
    slope = 1,
    colour = "dimgray",                    # colour of the line
    linetype = "solid",                   #type of line
    size = 0.25                           # width of the line
  ) + 
  geom_abline(                            #add a diagonal line where m = 1.1 and b = 0
    intercept = 0,                         # this line shows the upper bound of the 10% error range
    slope = 1.1,
    colour = "dimgray",                    # colour of the line
    linetype = "dashed",                   #type of line
    size = 0.25                           # width of the line
  ) + 
  geom_abline(                            #add a diagonal line where m = 0.9 and b = 0
    intercept = 0,                         # this line shows the lower bound of the 10% error range
    slope = 0.9,
    colour = "dimgray",                    # colour of the line
    linetype = "dashed",                   #type of line
    size = 0.25                           # width of the line
  ) + 
  geom_point(                          #add a scatter plot
    aes(x = dUOA,                     # the name of the column containing experimental data 
        y = AL_dUOA_calc,                 # the name of the column containing the model estimates
  color = descriptor_type,              # the variable to use to colour each point. Here you can use a column that indicates if the
                                        #solute descriptors are experimental or estimated. Or if the chemicals are part of the 
                                      #training or validation set.
        shape = `Training/External`),                #similar to color, instead changing the shape of the point. You can use assign different
                                        #columns for the shape and colour. 
    na.rm = T,                           # removes all NA values
    size = 1.2                           # the size of the points
  ) +
  scale_colour_manual("Reliability Score:",                  #The title of the legend for the based on the color of the points
                      values = c("red", "blue", "green", "orange")) +  #the colours of the points. You can define a list before
  #and call the list instead. Or use viridis or other color palettes
  scale_shape_manual("Level of Polarity:",                  #The title of the legend for the based on the shape of the points
                     values = c(1, 3, 4, 5)) +  #specify which shapes to use. 
  theme_pubr() +                                   #add theme formatting. There are more ways to customize the plots you can explore.
  theme(legend.position = "right") +                 #puts the legend on the right of the plot
  scale_x_continuous(breaks = seq(from = -2, to = 15, by = 2)) +  #adds tick marks on the x axis for every 2nd number between -2 and 15
  scale_y_continuous(breaks = seq(from= -2, to = 15, by = 2)) +   #same as above, but for y axis
  coord_cartesian(xlim = c(-2, 15), ylim=c(-2, 15)) +             #defines the co-ordinate system for the plot. Sets limits for both axis.
  ggtitle("ppLFER, estimated solute descriptors") +            #title of the graph
  xlab("Experimental Value") +                                    #x axis title
  ylab("Estimated Value") +                                       #y axis title
  theme (aspect.ratio = 1/2)                                      #sets a ratio for displaying the plot the x and y plot. 

plot_1_est  #prints the plot below


#```{r BA plot, echo=FALSE}



plot_2_est <- data %>%                     #calling the datafile
  filter(!is.na(data$mod_exp_koa)) %>%     #only include values where the model has an estimate. If a value is NA it is not plotted.
  ggplot () +                              #call ggplot
  geom_hline(                            #add a horizontal line where  b = 0
    yintercept = 0,                         # this line indicates the residual is 0 and that experimental & estimated values are the same
    colour = "dimgray",                    # colour of the line
    linetype = "solid",                   #type of line
    size = 0.25                           # width of the line
  ) + 
  geom_abline(                            #add a diagonal line where m = 0.1 and b = 0
    intercept = 0,                         # this line shows the upper bound of the 10% error range
    slope = 0.1,
    colour = "dimgray",                    # colour of the line
    linetype = "dashed",                   #type of line
    size = 0.25                           # width of the line
  ) + 
  geom_abline(                            #add a diagonal line where m = -0.1 and b = 0
    intercept = 0,                         # this line shows the lower bound of the 10% error range
    slope = -0.1,
    colour = "dimgray",                    # colour of the line
    linetype = "dashed",                   #type of line
    size = 0.25                           # width of the line
  ) + 
  geom_point(                          #add a scatter plot
    aes(x = log_KOA,                     # the name of the column containing experimental data 
        y = mod_exp_MD,                 # the name of the column containing the residuals for the model
        color = mod_est_ad,              # the variable to use to colour each point. Here you can use a column that indicates if the
        #solute descriptors are experimental or estimated. Or if the chemicals are part of the 
        #training or validation set.
        shape = polcat),             # similar to color, instead changing the shape of the point. You can use assign different
    #columns for the shape and colour. 
    na.rm = T,                           # removes all NA values
    size = 1.2                           # the size of the points
  ) +
  scale_colour_manual("Reliability Score:",                  #The title of the legend for the based on the color of the points
                      values = c("red", "blue", "green", "orange")) +  #the colours of the points. You can define a list before
  #and call the list instead. Or use viridis or other color palettes
  scale_shape_manual("Level of Polarity:",                  #The title of the legend for the based on the shape of the points
                     values = c(1, 3, 4, 5)) +  #specify which shapes to use. 
  theme_pubr() +                                   #add theme formatting. There are more ways to customize the plots you can explore.
  theme(legend.position = "right") +                 #puts the legend on the right of the plot
  scale_x_continuous(breaks = seq(from = -2, to = 15, by = 2)) +  #adds tick marks on the x axis for every 2nd number between -2 and 15
  scale_y_continuous(breaks = seq(from= -3, to = 3, by = 1)) +   #same as above, but for y axis
  coord_cartesian(xlim = c(-2, 15), ylim=c(-3, 3)) +             #defines the co-ordinate system for the plot. Sets limits for both axis.
  ggtitle("ppLFER, estimated solute descriptors") +            #title of the graph
  xlab("Experimental Value") +                                    #x axis title
  ylab("Estimated Value") +                                       #y axis title
  theme (aspect.ratio = 1/2)                                      #sets a ratio for displaying the plot the x and y plot. 

plot_2_est  #prints the plot below


