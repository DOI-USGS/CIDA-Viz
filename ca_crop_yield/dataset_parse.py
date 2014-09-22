'''
Created on Sep 16, 2014

@author: ayan
'''
# focusing on california
# discharge/reservoir data
# drought
# snowpack
# fire
# economic damage

# 2001 - Present

import pandas as pd
from matplotlib.pylab import plt

def convert_to_float(element):
    try:
        float_val = float(element)
    except(TypeError, ValueError):
        float_val = element
    return float_val


def price_per_ton(series, production_series, value_series):
    value = series[value_series]
    production = series[production_series]
    price_per_production = value / production
    return price_per_production
        

csv_path = 'data/Table-B22.txt' # olive production data
df = pd.read_csv(csv_path, sep='\t', quotechar='"', skiprows=8, header=None)

df1 = df[[0, 2, 12]]

df1['year'] = df[0]
df1['total_production'] = df[2]
df1['total_value'] = df[12]
df2 = df1[['year', 'total_production', 'total_value']]
df3 = df2.applymap(convert_to_float)
df3_no_nans = df3[pd.notnull(df3['year'])]
df3_no_nans['price_per_production'] = df3_no_nans.apply(price_per_ton, axis=1, production_series='total_production', value_series='total_value')
df3_no_nans.plot(x='year', y='price_per_production', kind='scatter')
plt.ylabel('Total Value of Olives')
plt.xlabel('Total Production of Olives')
plt.show()