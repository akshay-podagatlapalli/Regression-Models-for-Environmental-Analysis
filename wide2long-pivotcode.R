library(ggplot2)
library(stringr)
library(dplyr)
library(latex2exp)

# load the data
data <-
  read.csv(
    "C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Training Data Splitting Predictions_ALE.csv",
    stringsAsFactors = F
  )

# Reshape from Wide to Long
## varying = the name of the variables that need to be pivoted
## times = the name of the new variable in long format. You need to pivot both Preds and Slit at the same time!
### This function automatically recognize the "." as a separator for groups and variables. I renamed your columns so that they were separated by a "."
### and the function automatically detect them. See function help "F1" if you need more info. Run the example, it is helpful to understand
Long <- reshape(data, direction = "long", varying = names(data)[3:42], times = c('Preds', 'Split'))

# Reshape calls time the diffferent groups. In your file, model and spilt were aggregated in the same "name" (e.g. dUOA_AL).
# You may need to separete those. So I'm separating the string to create two new columns, one for Split Type and one for model
# you need the package "stringr"
Long$Split_Type <- unlist(stringr::str_split_fixed(Long$time, "_", n = 2))[,1]
Long$Model_Type <- unlist(stringr::str_split_fixed(Long$time, "_", n = 2))[,2]

# Here is the basic plot with facets. This is very basic, you may want to customize as you like
# PLOT <- ggplot(Long)+
#   geom_point(aes(x = Exp, y = Preds, col = Split))+
#   facet_grid(vars(Split_Type), vars(Model_Type))

compare_plots <- function(data) {
  ggplot(data,
         aes(x = Exp,
             y = Preds,
             col = Split)) +
    ylab(TeX("Estimated $\\Delta U_{OA}$ (kJ $mol^{-1})$")) +
    xlab(TeX("Experimental $\\Delta U_{OA}$ (kJ $mol^{-1})$")) +
    scale_shape(solid = FALSE) +
    geom_point() +
    geom_abline(
      intercept = 0,
      slope = 1,
      colour = "dimgray",
      linetype = "solid",
      size = 0.25
    ) +
    facet_grid( vars(Split_Type), vars(Model_Type)) +
    theme_classic()
}

plot <- compare_plots(Long)
plot

ggsave("SplittingTypes_Comparison.jpg", plot = last_plot(), device = "jpeg",
       path = "C:/Users/Akshay/Documents/Research/dUOA data/Manuscript/Plots",
       scale = 1, width = 30, height = 25, units = "cm", dpi = 320,
       limitsize = TRUE)


# Looking at the plots, the graphs for the same model all look the same. That's why predictions for the same compounds are very similar in 
# the different splittings. 
# I ran a little test to verify that

dif <- Long %>%
  group_by(Model_Type , Name) %>%
  summarise(diff = max(Preds)-min(Preds))

max(dif$diff)

# the max difference between prediction for the same compound in the different splittings is 5.8049
# that difference is so small that can barely be seen in the graph with a scale 1:100
