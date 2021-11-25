import numpy as np
import pandas as pd

df = pd.read_csv("test.csv")

chem_id = df['ChemID']
cit = df['Temp']

ID = 0
mname = df.groupby(df.ChemID)
for name in chem_id:
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
        res.to_csv('test1.csv', mode='a')
    
    #res = val['Citation'].value_counts()
    #res.to_csv('test1.csv', mode='a')
    



'''data_file = pd.read_csv("dU & KOA Values.csv")

minimum = data_file.groupby('ChemID').Temp.agg(['min'])
maximum = data_file.groupby('ChemID').Temp.agg(['max'])

chem_id = data_file['ChemID'].drop_duplicates(keep='last')
meth_id = data_file['methID'].drop_duplicates(keep='last')
cit_id = data_file['Citation'].drop_duplicates(keep='last')

cit_filter = data_file[["ChemID", "Citation"]]
chem_name = cit_filter['ChemID']

mname = cit_filter.groupby(cit_filter.ChemID)
## This block isolates each dataframe into its own entity
ID = 0
for name in chem_name:
    try:
        ID += 1
        name = "chem" + str(ID).zfill(4) 
        val = mname.get_group(name)
    except KeyError:
        continue
    cit_filter2 = cit_filter[['ChemID', 'Citation']].drop_duplicates(keep='last')
final = cit_filter2.groupby('ChemID').Citation.agg(['count'])

print(final)

#minimum.to_csv("test.csv", mode='a')
#maximum.to_csv("test.csv", mode='a')
#cit_filter2.to_csv("test.csv", mode='a')
#final.to_csv('test.csv', mode='a')'''