# -*- coding: utf-8 -*-
"""
Created on Fri Feb  5 09:31:07 2021

@author: ASUS
"""
#%% Preamble
import os
import pandas as pd


#%%Importing data
df1 = pd.read_stata('D:/0_complexaton/Challenge4/EntrepAno3y_87_09.dta')
df2 = pd.read_stata('D:/0_complexaton/Challenge4/MoldsEntransWorkerEntrep_87_09.dta')


#%%Checking data
df1.info()
df2.info()

df1.dtypes
df2.dtypes
#df[ano_ent].dtype


#%%Trying something
print(df1.shape[0])
print(len(df1))
print(df1.shape)

#%%
print(df1['idade'].describe())


#%% Statistics
#This doesnt work yet because idade is string
#print(df['idade'].quantile([.1,.25,.5,.75,.9]))

# *The molds database has 36148 data entry of workers history. This implies that 
# 	*one woker can have multiple entries, as he or she appears in different years
# 	*We saw that some workers appear in different years and same company, other cases
# 	*have same worker different years different companies. Other workers appear just once.
# 	*It is not clear yet, the case in which a worker seems to have not changed company, but appear repeteadly 
# 	*in different years. It could be because some change were registered i.e 
# 	*the worker has now a different position/occupation/salary ?? 
# 	*We didnt explore taht yet
# 	
# 	*We dropped non-merging companies. 
# 	*This means that after the merge, we will be analysing workers for which we have fianncial information
# 	*about the companies tehy were working for.
# 	*Why? because out of 36773 data entry of the history of molds-(plastic and glass) workers only for 3112 
# 	*there is companies financial entries
    
#%%Cleaning 
df1_a = df1.drop_duplicates(subset=['ntrab'])
print(df1_a['ntrab'].describe())

#%%Cleaning workers
df1_b = df1.drop_duplicates(subset=['nuemp_ent'])
print(df1_b['nuemp_ent'].describe())
print(df1_b.info())

#%% Merge
df_merge = pd.merge(df2,df1_b,left_on='nuemp',right_on='nuemp_ent', how='inner',validate="many_to_one")
print(df_merge.info())
print(df_merge.dtypes)
print(len(df_merge))


# 	*At first, we wanted to keep only workers at the molds industry but we found that 
# 	*some have history at the plastic and glass industry. Besides, those companies
# 	*have information from the first database, which means that we have info about 
# 	*the companies' financial performance
# 	*keep if molds_ent==1
    
#%%Trying to sort
df_merge.sort_values(['ntrab_x', 'nuemp', 'ano'], ascending=[True, True,True])
df_merge["ntrab_nuemp"] = df_merge["ntrab_x"].astype(str) + df_merge["nuemp"].astype(str) 

#   *Now, despite the merge and inicial cleanning of the merged database being clear
# 	*We still require to keep one unique data entry of the workers. Why?
# 	*because hat we can create a matrix with workers as rows and companies as columns
# 	*As an adjacency matrix...
# 	
# 	*To doing so, we first sort workers, companies and the years
    
#%% Unique
#df_merge['worker_year'] = df_merge.groupby(['df_merge', 'ao']).ngroup()

df_merge.sort_values(['ntrab_nuemp','ano'], ascending=[True, True])
df_merge['worker_year'] = df_merge.groupby(['ntrab_nuemp']).cumcount(ascending=True)


#%%
print(df_merge['worker_year'].describe())
print(pd.pivot_table(df_merge, index=['worker_year']))


#%%To matrix form
df_merge_a=df_merge['worker_year']==0
df_adjacency= df_merge['worker_year']==0
print(df_adjacency)
df_adjacency.info()