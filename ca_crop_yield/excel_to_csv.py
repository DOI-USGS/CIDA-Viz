'''
Created on Sep 21, 2014

@author: ayan
'''
import os
import xlrd
import csv


def excel_to_csv(excel_path, csv_path):
    wb = xlrd.open_workbook(excel_path)
    sheet_name = wb.sheet_names()
    sh = wb.sheet_by_name(sheet_name[0])
    csv_file = open(csv_path, 'wb')
    wr = csv.writer(csv_file, quoting=csv.QUOTE_ALL)

    for rownum in xrange(sh.nrows):
        wr.writerow(sh.row_values(rownum))
    csv_file.close()
    
def get_files_in_directory(directory_path, search_string='emp.xls'):
    excel_list = os.listdir(directory_path)
    pertinent_file_list = []
    for excel_file in excel_list:
        if excel_file.endswith(search_string):
            full_pathname = '{0}\\{1}'.format(directory_path, excel_file)
            basename = os.path.basename(excel_file)
            no_extention = os.path.splitext(basename)[0]
            file_tuple = (full_pathname, no_extention)
            pertinent_file_list.append(file_tuple)
    return pertinent_file_list

if __name__ == '__main__':
    directory = 'C:\\Users\\ayan\\Downloads\\ca_ag_emp'
    pfl = get_files_in_directory(directory)
    for excel_file_tuple in pfl:
        pathname, filename = excel_file_tuple
        year = '2008_2010'
        emp_dir = 'data/emp_data_{0}'.format(year)
        if not os.path.exists(emp_dir):
            os.makedirs(emp_dir)
        csv_path = '{0}/{1}.csv'.format(emp_dir, filename)
        excel_to_csv(pathname, csv_path)
    