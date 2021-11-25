import numpy as np
import pandas as pd
from scipy import stats

data_file = pd.read_csv("temp&koa.csv")
mname = data_file.groupby(data_file.ChemID)
chem_name = data_file['ChemID']
ln_e = np.log10(np.e)

arr = []

ID = 0
for name in chem_name:
    try:
        ID += 1
        name = "chem" + str(ID).zfill(4)
        val = mname.get_group(name)
    except KeyError:
        continue
    #chem_gc = pd.concat([(val['ChemID']), (val['Group'])], axis=1)
    #(chem_gc.drop_duplicates(keep='first')).to_csv('test.csv', mode='a')
    temp = 1/(val['Temp'] + 273.15)
    lnKOA = (val['log KOA'])
    lnKOA = lnKOA/ln_e
    slope, intercept, r_value, p_value, stderr = stats.linregress(temp, lnKOA)
    arr.append(r_value)
    reg_vals = pd.concat([temp, lnKOA], axis=1)
    reg_vals.to_csv('test.csv', mode='a')
dU = pd.Series(arr)
dU.to_csv('test.csv', mode='a')    

#dU.to_csv('test.csv', mode='a')