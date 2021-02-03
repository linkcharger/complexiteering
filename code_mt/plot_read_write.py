"""
======================
Read and write graphs.
======================

Read and write graphs.
"""

import matplotlib.pyplot as plt
import networkx as nx
import pandas as pd
from io import StringIO

import csv

#pd.DataFrame
df  = pd.read_csv('C://Users//ASUS//Dropbox//UU_master//2nd_year//Complexaton//Challenge4//matrx_worcom_2.txt', 'r')
#df = pd.read_csv('test.csv')

df

df_2  = pd.read_csv(StringIO('C://Users//ASUS//Dropbox//UU_master//2nd_year//Complexaton//Challenge4//matrx_worcom_2.txt'), 'r')
####################################
G = nx.from_pandas_adjacency(df)

print(nx.info(G))