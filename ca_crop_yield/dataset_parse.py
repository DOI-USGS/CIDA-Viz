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
import csv
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


def get_csv_row_number(csv_file, search_string, delimiter=','):
    iterator = 0
    row_number = None
    with open(csv_file, 'rt') as cf:
        reader = csv.reader(cf, delimiter=delimiter)
        for row in reader:
            iterator += 1
            for field in row:
                if field == search_string:
                    row_number = iterator
    header_row = row_number - 1
    return (row_number, header_row)
                    
    
        
if __name__ == '__main__':
    """
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
    """
    
    csv_path = 'C:\\Users\\ayan\\git\\CIDA-Viz\\ca_crop_yield\\data\\emp_data_2008_2010\\ca2008emp.csv'
    search_str_row_number = get_csv_row_number(csv_path, 'TOTAL AGRICULTURAL')
    print(search_str_row_number)