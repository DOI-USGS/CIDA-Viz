'''
Created on Sep 23, 2014

@author: ayan
'''
import pandas as pd
from matplotlib.pylab import plt, gcf
from excel_to_csv import excel_to_csv


if __name__ == '__main__':

    BASEPATH = 'C:\\Users\\ayan\\Desktop\\tmp\\vege_data'
    ORANGES = '{0}\\{1}'.format(BASEPATH, 'SeriesReport-20140923150541.xlsx')
    # CA citrus production: http://www.producenews.com/markets-and-trends/14025-usda-estimates-lowest-citrus-crop-in-six-years-cac-thinks-it-s-even-lower
    GRAPES = '{0}\\{1}'.format(BASEPATH, 'SeriesReport-20140923150521.xlsx')
    BROCCOLI = '{0}\\{1}'.format(BASEPATH, 'SeriesReport-20140923150449.xlsx')
    STRAWBERRIES = '{0}\\{1}'.format(BASEPATH, 'SeriesReport-20140923150329.xlsx')
    LETTUCE = '{0}\\{1}'.format(BASEPATH, 'SeriesReport-20140923161710.xlsx')
    # lettuce produced from CA: http://www.latimes.com/business/la-fi-fruit-and-vegetable-prices-california-drought-continues-20140625-story.html
    TOMATOES = '{0}\\{1}'.format(BASEPATH, 'SeriesReport-20140923161927.xlsx')
    LEMONS = '{0}\\{1}'.format(BASEPATH, 'SeriesReport-20140923162527.xlsx')
    # lemons produced from CA: http://www.bloomberg.com/news/2014-09-22/u-s-lemon-lovers-tasting-bitter-price-shock-from-drought.html
    o_tuple = (ORANGES, 'oranges')
    g_tuple = (GRAPES, 'grapes')
    b_tuple = (BROCCOLI, 'broccoli')
    s_tuple = (STRAWBERRIES, 'strawberries')
    lettuce_tuple = (LETTUCE, 'lettuce')
    t_tuple = (TOMATOES, 'tomatoes')
    lemon_tuple = (LEMONS, 'lemons')
    tuple_list = [o_tuple, g_tuple, b_tuple, s_tuple, lettuce_tuple, t_tuple, lemon_tuple]
    csv_paths = []
    for produce_tuple in tuple_list:
        filepath, produce_item = produce_tuple
        csv_path = 'data\\produce\\{0}.csv'.format(produce_item)
        csv_paths.append((csv_path, produce_item))
        excel_to_csv(filepath, csv_path)
    dfs = {}
    for csv_tuple in csv_paths:
        csv_path, produce_item = csv_tuple
        df = pd.read_csv(csv_path, sep=',', quotechar='"', skiprows=8, header=0, index_col=0)
        df1 = df.loc[2010:]
        dfs[produce_item] = df1
    stacked_dfs = []
    for key in dfs:
        produce_df = dfs[key]
        produce_df_stacked = produce_df.stack()
        stacked_dfs.append(produce_df_stacked)
        produce_df_stacked.plot(kind='bar', color='c')
        title = '{0} CPI'.format(key)
        y_label = '{0} Average Price/lb'.format(key)
        x_label = 'Month'
        plt.title(title)
        plt.ylabel(y_label)
        plt.xlabel(x_label)
        plt.legend(loc='best')
        fig = gcf()
        fig.set_size_inches(18.5, 14.5)
        figure_name = 'plots\\{0}.png'.format(key)
        fig.savefig(figure_name)
    s_df_0 = stacked_dfs[0]
    s_df_0.index.names = ['year', 'month']
    
    # print(s_df_0)
    # s_df_0_2011 = s_df_0.loc[(2011, 'Feb'):(2014, 'Mar')]
    # print(s_df_0_2011)
    
