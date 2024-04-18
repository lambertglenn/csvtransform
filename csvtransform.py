import pandas as pd

sample1 = pd.read_csv("sample1.csv")
sample2 = pd.read_csv("sample2.csv")

def fastmerge(d1, d2):
    d1_names = d1.columns
    d2_names = d2.columns
    
    # columns in d1 but not in d2
    d2_add = list(set(d1_names) - set(d2_names))
    
    # columns in d2 but not in d1
    d1_add = list(set(d2_names) - set(d1_names))
    
    # add blank columns to d2
    if d2_add:
        for col in d2_add:
            d2[col] = pd.NA
    
    # add blank columns to d1
    if d1_add:
        for col in d1_add:
            d1[col] = pd.NA
    
    return pd.concat([d1, d2], ignore_index=True)

table = fastmerge(sample1, sample2)

# Replace null values with 0's
table.fillna(0, inplace=True)

# Extract year and month from the date column
table['year'] = table['date'].str[-4:]
table['month'] = table['date'].str[5:7]

# Create a new key column by concatenating year and month
table['key'] = table['year'] + "-" + table['month']

# Remove spaces from the key column
table['key'] = table['key'].str.replace(" ", "")

# Drop the month and year columns
table.drop(['month', 'year'], axis=1, inplace=True)

# Write the table to a CSV file
table.to_csv("splunkcloudingest.csv", index=True, quoting=pd.QUOTE_NONE)
