# Developing Multi-Linear Regression (MLR) Models to Estimate How Chemicals Move Between Air and Organic Mediums at Different Temperatures  

## Objective 
The objective of this study is to develop a new MLR models for predicting how chemicals move between air and organic phases (blood, nasal cavities, lipids, etc...) at different temperatures using fewer parameters than earlier models. Specifically, we aim to estimate how temperature affects the behaviour of a chemical and how it moves between the two phases. We evaluated the use of several molecular [parameters/descriptors](https://www.sciencedirect.com/topics/medicine-and-dentistry/molecular-descriptor) for developing these MLR equations.

## Approach
We created a chemical database by gathering relevant data from scientific literature and online chemical databases. The data was then cleaned and transformed to prepare it for analysis. To better understand the data, we applied exploratory data analysis (EDA) techniques such as scatter plots, clustering, correlation matrices, and PCA.

![Figure 1](https://media.springernature.com/full/springer-static/image/art%3A10.1007%2Fs10953-022-01214-7/MediaObjects/10953_2022_1214_Fig1_HTML.png?as=webp)
**Figure 1**: A scheme describing how the data was collected and how it was used for model training and validation.


![Figure 2](https://media.springernature.com/full/springer-static/image/art%3A10.1007%2Fs10953-022-01214-7/MediaObjects/10953_2022_1214_Fig2_HTML.png?as=webp)
**Figure 2**: A distribution of the data that was used for training and validating the data


![Figure 3](https://media.springernature.com/full/springer-static/image/art%3A10.1007%2Fs10953-022-01214-7/MediaObjects/10953_2022_1214_Fig3_HTML.png?as=webp)
**Figure 3**: Data estimated using the models plotted against the original values for the training and validation datasets.

Using the QSAR development platform QSARINS, we developed multilinear regression (MLR) models to predict the internal energy ($\Delta U_{OA}$) of neutral organic chemicals at different temperatures. We evaluated the use of Abraham descriptors, other molecular descriptors, and the $log_{10} K_{OA}$ at 25 °C as variables in different MLR equations.

## Conclusion 
Our study resulted in the development of 5 new models that use fewer parameters than [earlier models](https://www.sciencedirect.com/science/article/abs/pii/S0040603108000403?via%3Dihub) for predicting the temperature dependence of the octanol-air partition ratio. The best performing model relies only on the $log_{10} K_{OA}$ at 25 °C and has similar or slightly improved performance relative to previous estimation techniques. Our work suggests that the ($\Delta U_{OA}$) of neutral organic chemicals can be reliably predicted using only the $log_{10} K_{OA}$ (a single parameter only) or a combination of $log_{10} K_{OA}$ and the solute’s hydrogen acidity A (two parameters).

Overall, we created a comprehensive chemical database, performed data cleaning and transformation, applied EDA techniques, and developed MLR models to achieve our objectives. Our findings could help in the development of new environmental chemistry models and inform future research in this field.
