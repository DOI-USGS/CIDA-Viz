from plotly.plotly import sign_in, plot
from ca_drought_econ import prep_data, calc_anomoly, df_to_plotly, convert_str_to_float

df = prep_data()
lemon_avg_nm = 'Lemons Avg Price'
orange_avg_nm = 'Navel_Oranges Avg Price'
lettuce_avg_nm = 'Lettuce Avg Price'
grape_avg_nm = 'Grapes Avg Price'
tomato_avg_nm = 'Tomatoes Avg Price'
columns = [
           lemon_avg_nm,
           orange_avg_nm,
           lettuce_avg_nm,
           grape_avg_nm,
           tomato_avg_nm
           ]
produce_mean = df[columns].mean()
lemon_2007_2014_avg = produce_mean[lemon_avg_nm]
orange_2007_2014_avg = produce_mean[orange_avg_nm]
lettuce_2007_2014_avg = produce_mean[lettuce_avg_nm]
grape_2007_2014_avg = produce_mean[grape_avg_nm]
tomato_2007_2014_avg = produce_mean[tomato_avg_nm]
lemon_anomoly = 'lemon_anomoly'
orange_anomoly = 'orange_anomoly'
lettuce_anomoly = 'lettuce_anomoly'
grape_anomoly = 'grape_anomoly'
tomato_anomoly = 'tomato_anomoly'
df[lemon_anomoly] = df.apply(calc_anomoly, axis=1, column_name=lemon_avg_nm, avg_value=lemon_2007_2014_avg)
df[orange_anomoly] = df.apply(calc_anomoly, axis=1, column_name=orange_avg_nm, avg_value=orange_2007_2014_avg)
df[lettuce_anomoly] = df.apply(calc_anomoly, axis=1, column_name=lettuce_avg_nm, avg_value=lettuce_2007_2014_avg)
df[grape_anomoly] = df.apply(calc_anomoly, axis=1, column_name=grape_avg_nm, avg_value=grape_2007_2014_avg)
df[tomato_anomoly] = df.apply(calc_anomoly, axis=1, column_name=tomato_avg_nm, avg_value=tomato_2007_2014_avg)

anomoly_columns = [lemon_anomoly, orange_anomoly, lettuce_anomoly, grape_anomoly, tomato_anomoly, 'year_str', 'Percent of CA in Severe Drought']
df_anomoly = df[anomoly_columns]
df_anomoly['year_float'] = df_anomoly.apply(convert_str_to_float, axis=1, column_name='year_str')
year_range = range(2009, 2015)
df_anomoly_2009_2014 = df_anomoly[(df_anomoly['year_float'] >= 2009)]

lemon_data = df_to_plotly(df_anomoly_2009_2014, lemon_anomoly)
orange_data = df_to_plotly(df_anomoly_2009_2014, orange_anomoly)
lettuce_data = df_to_plotly(df_anomoly_2009_2014, lettuce_anomoly)
grape_data = df_to_plotly(df_anomoly_2009_2014, grape_anomoly)
tomato_data = df_to_plotly(df_anomoly_2009_2014, tomato_anomoly)
data_list = [
             lemon_data,
             orange_data,
             lettuce_data,
             grape_data,
             tomato_data
             ]

USER = 'ayan'
API_KEY = 'p026399cim'
sign_in(USER, API_KEY)
plot(data_list, filename='produce_test')

"""
x1 = [1, 2, 3, 5, 6]
y1 = [1, 4.5, 7, 19, 38]
trace1 = dict(x=x1, y=y1)
data = [trace1]
plot(data, filename="test_plot")
"""