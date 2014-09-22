'''
Created on Sep 21, 2014

@author: ayan
'''

import pandas as pd
from excel_to_csv import get_files_in_directory

emp_data_dir_2013 = 'data/emp_data_2013'
emp_2013_files = get_files_in_directory(emp_data_dir_2013, '.csv')
df_2013 = []
print(emp_2013_files)
for csv_file in emp_2013_files:
    pathname = csv_file[0]
    df = pd.read_csv(pathname, sep=',', quotechar='"', skiprows=3, index_col=1, header=0)
    df_2013.append(df)
print(df_2013[0])
for df in df_2013:
    print(df.loc['TOTAL AGRICULTURAL', "41275.0"])


    
