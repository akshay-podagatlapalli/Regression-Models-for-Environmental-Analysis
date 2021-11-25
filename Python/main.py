import numpy as np
import pandas as pd
from scipy import stats

"""
enter the file name within the paranthesis below
"""

df = pd.read_excel('datafile.xlsx')

def filter_func():
    """
    Function to filter out ChemIDs with sample size < 4 
    """
    global df
    chemid_filter = df.groupby('ChemID').filter(lambda x: len(x) > 3)
    return chemid_filter.to_csv('filter1.csv')

def temp_filter():
    """Filtering out ChemIDs that have the same temp"""
    df1 = pd.read_csv('filter1.csv')
    temp_filter = df1[["ChemID", "Temp", "log KOA"]]
    chem_name = temp_filter['ChemID']

    """mname splits the temp_filter df into smaller dfs based on the the ChemIDs""" 
    mname = temp_filter.groupby(temp_filter.ChemID)

    """This block isolates each dataframe into its own entity"""
    ID = 0
    for name in chem_name:
        try:
            ID += 1
            name = "chem" + str(ID).zfill(4) 
            val = mname.get_group(name)
        except KeyError:
            continue
        val.to_csv('filter3.csv', mode='a')

def stats_chem():
    df2 = pd.read_csv('filter3.csv')
    """
    setting up empty lists to append slope and r-vals. ln_e for the conversion of log
    log Koa to ln Koa
    """ 
    ln_e = np.log10(np.e)
    arr_slope = []
    arr_rval = []

    mname = df2.groupby(df2.ChemID)
    """This block isolates each dataframe into its own entity"""
    ID = 0
    for name in df2['ChemID']:
        try:
            ID += 1
            name = "chem" + str(ID).zfill(4) 
            val = mname.get_group(name)
        except KeyError:
            continue
        temp = 1/(val['Temp'] + 273.15)
        lnKOA = (val['log KOA'])
        lnKOA = lnKOA/ln_e
        slope, intercept, r_value, p_value, std_err = stats.linregress(temp, lnKOA)
        arr_slope.append(slope)
        arr_rval.append(r_value)
    slope = pd.Series(arr_slope)                        ##slope for each chemid
    r_val = pd.Series(arr_rval)                         ##r-val for each chemid
    count = df2.groupby('ChemID').ChemID.agg(['count']) ##determines the sample size of each chemid
    minimum = df2.groupby('ChemID').Temp.agg(['min'])   ##provides the min temp for each chemid
    maximum = df2.groupby('ChemID').Temp.agg(['max'])   ##provides the max temp for each chemid
    count.to_csv('filter4.csv', mode='a')
    minimum.to_csv('filter4.csv', index=False, mode='a')
    maximum.to_csv('filter4.csv', index=False, mode='a')
    slope.to_csv('filter4.csv', index=False, header=['Slope'], mode='a')
    r_val.to_csv('filter4.csv', index=False, header=['r-value'], mode='a')


def temp_range():
    """
    function to identify which chemids have a temp range < 30
    """
    df2 = pd.read_csv('filter3.csv')

    mname = df2.groupby(df2.ChemID)
    ID = 0
    for name in df2['ChemID']:
        try:
            ID += 1
            name = "chem" + str(ID).zfill(4) 
            val = mname.get_group(name)
        except KeyError:
            continue
        min_temp = val.iloc[0, 1]
        max_temp = val.iloc[-1, 1]
        iv_range = pd.Interval(left=min_temp, right=max_temp)
        if iv_range.length < 30:
            res = val['ChemID'].drop_duplicates(keep='last')
            res.to_csv('filter4.csv', index=False, header=0, mode='a')

print(filter_func())
#print(temp_filter())
#print(stats_chem())
#print(temp_range())