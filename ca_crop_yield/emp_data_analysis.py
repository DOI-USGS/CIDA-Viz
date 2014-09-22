'''
Created on Sep 21, 2014

@author: ayan
'''

import pandas as pd
from excel_to_csv import get_files_in_directory
from dataset_parse import get_csv_row_number

emp_data_dir_2013 = 'data/emp_data_2008_2010'
emp_2013_files = get_files_in_directory(emp_data_dir_2013, '.csv')
df_2013 = []
print(emp_2013_files)
for csv_file in emp_2013_files:
    pathname = csv_file[0]
    ag_row, header_row = get_csv_row_number(pathname, 'TOTAL AGRICULTURAL')
    df = pd.read_csv(pathname, sep=',', quotechar='"', skiprows=header_row - 1, index_col=1, header=header_row)
    df_2013.append(df)
print(df_2013[0])
for df in df_2013:
    print(df.loc['TOTAL AGRICULTURAL', "41275.0"])


    
