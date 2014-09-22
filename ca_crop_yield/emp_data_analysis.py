'''
Created on Sep 21, 2014

@author: ayan
'''

import datetime
import xlrd
import pandas as pd
from excel_to_csv import get_files_in_directory
from dataset_parse import get_csv_row_number
from matplotlib.pylab import plt

def rename_index(index_name):
    xls_date = xlrd.xldate_as_tuple(float(index_name), 0)
    year, month, day, hour, minute, second = xls_date
    py_datetime = datetime.datetime(year, month, day, hour, minute, second)
    datetime_str = py_datetime.strftime('%b-%Y') 
    
    return datetime_str
    
emp_data_dir_2013 = 'data/emp_data_2008_2014'
emp_files = get_files_in_directory(emp_data_dir_2013, '.csv')
df_list = []
for csv_file in emp_files:
    pathname = csv_file[0]
    ag_row, header_row = get_csv_row_number(pathname, 'TOTAL AGRICULTURAL')
    df = pd.read_csv(pathname, sep=',', quotechar='"', skiprows=header_row-1, index_col=1, header=0)
    df_list.append(df)
pertinent_dfs = []
for df in df_list:
    columns_not_of_interest = ['NAICS CODES', 'TITLE']
    df_columns = list(df.columns.values)
    column_list = [column for column in df_columns if column not in columns_not_of_interest]
    df_pert_dirty = df[column_list]
    df_clean = df_pert_dirty.loc['TOTAL AGRICULTURAL', :]
    df_clean_reindex = df_clean.rename(rename_index)
    print(df_clean_reindex)
    pertinent_dfs.append(df_clean_reindex)
s_concat = pd.concat(pertinent_dfs)
s_concat.plot(kind='bar')
plt.title('CA Agricultural Employment')
plt.xlabel('Month')
plt.ylabel('Agricultural Employment')
plt.show()