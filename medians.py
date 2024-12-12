import pandas as pd
import numpy as np

# Step 1: Load the tempByCountry.csv file and explicitly treat empty strings as NaN
csv_df = pd.read_csv('tempByCountry.csv', dtype={'AverageTemperature': float}, na_values=['', ' '])

# Step 2: Load the medians.txt file (tab-separated file)
medians_df = pd.read_csv('medians_country.txt', sep='\t', header=None, names=['Country', 'Median'])

# Step 3: Merge the two DataFrames on the 'Country' column
merged_df = pd.merge(csv_df, medians_df, on='Country', how='left')

# Step 4: Force-fill missing 'AverageTemperature' values with the 'Median'
merged_df['AverageTemperature'] = merged_df['AverageTemperature'].fillna(merged_df['Median'])

# Check if there are any missing values left
if merged_df['AverageTemperature'].isnull().any():
    print("Warning: Some missing values remain!")
else:
    print("All missing values filled.")

# Step 5: Drop the 'Median' column (no longer needed)
merged_df = merged_df.drop(columns=['Median'])

# Step 6: Save the updated DataFrame to a new CSV file
merged_df.to_csv('CleanTempByCountry.csv', index=False)

# Print the final data for inspection
print(merged_df.head())


