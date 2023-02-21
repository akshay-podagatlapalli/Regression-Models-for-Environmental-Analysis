# code perform regression, calculat the lineofbestfit
# and create the corresponding scatterplots for each of the primary keys

# every primary key has 3 or more datapoints with different temperature values
# and different "log KOA" value at each temperature point. 

# the "log KOA" is plotted against the reciprocal of the temperature value 
# to identify any descrepanies in the experimental values of the KOA value. 

# these plots are used to investigate what is wrong with a given record for
# each of the primary keys. 

import numpy as np
import pandas as pd
from scipy import stats
import matplotlib.pyplot as plt

df = pd.read_csv("datafile.csv")
dpoints = df[["ChemID", "1/Temp", "log KOA", "methID"]]
data_frame = dpoints.groupby([dpoints.ChemID, dpoints.methID])      # For scatter plot series
chem_data_frame = dpoints.groupby(dpoints.ChemID)                   # For line of best fit
chem_names, method_names = list(df['ChemID'].drop_duplicates()), list(df['methID'].drop_duplicates())

GRAPHS_PER_PAGE = 1
print(len(chem_names))
for index, chem_name in enumerate(chem_names):
    print(index, chem_name)

    # Save figure
    if index % GRAPHS_PER_PAGE == 0 and index > 0:
        plt.savefig(f'./graphs/{index-GRAPHS_PER_PAGE}-{index}')
    # Create new figure every 4 graphs
    if index % GRAPHS_PER_PAGE == 0:
        plt.figure(figsize=(8,8))
        

    plt.subplot(GRAPHS_PER_PAGE//1, GRAPHS_PER_PAGE//1, (index) % GRAPHS_PER_PAGE+1)
    plt.title(chem_name)
    
    # Plot line of best fit
    val = chem_data_frame.get_group(chem_name)
    x = val["1/Temp"].to_numpy()
    y = val["log KOA"].to_numpy()
    m, b = np.polyfit(x, y, 1)
    slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
    r_val = round(r_value**2, 3)
    plt.plot(x, m*x + b, color = "black", label=(r_val))

    # Plot all method_name scatter plots
    for method_name in method_names:
        try:
            val = data_frame.get_group((chem_name, method_name))
            x = val["1/Temp"].to_numpy()
            y = val["log KOA"].to_numpy()
            m_1, b_1 = np.polyfit(x, y, 1)
            plt.plot(x, m_1*x + b_1)
            plt.scatter(x, y, label=method_name)
        except:
            # case where chem_name, method_name doesn't exist
            continue
    
    plt.legend(loc='upper left')
