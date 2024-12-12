import pandas as pd
import numpy as np
import unicodedata 

def normalize_city_names(city_name):
    """
    Normalize city names by:
    - Removing accents
    - Converting to lowercase
    - Stripping whitespace
    """
    city_name = unicodedata.normalize('NFD', city_name)
    city_name = city_name.encode('ascii', 'ignore').decode('utf-8')  # Remove non-ASCII characters
    return city_name.strip().lower()

# Step 1: Load the tempByMajorCity.csv file and explicitly treat empty strings as NaN
csv_df = pd.read_csv('tempByMajorCity.csv', dtype={'AverageTemperature': float}, na_values=['', ' '])

# Step 2: Load the medians.txt file (tab-separated file)
medians_df = pd.read_csv('medians.txt', sep='\t', header=None, names=['City', 'Median'])

# Step 3: Normalize city names in both DataFrames
csv_df['City'] = csv_df['City'].apply(normalize_city_names)
medians_df['City'] = medians_df['City'].apply(normalize_city_names)

# Extract unique city names from both files
cities_in_csv = set(csv_df['City'].str.strip().str.lower())
cities_in_medians = set(medians_df['City'].str.strip().str.lower())

# Find missing matches
missing_cities = cities_in_csv - cities_in_medians
print(f"Cities in tempByMajorCity.csv but not in medians.txt: {missing_cities}")


# Step 3: Merge the two DataFrames on the 'Major City' column
merged_df = pd.merge(csv_df, medians_df, on='City', how='left')

# Check for null values in the 'Median' column
null_values = merged_df[merged_df['Median'].isnull()]

# Print the rows with null values
if not null_values.empty:
    print("Rows with null values in the 'Median' column:")
    print(null_values)
else:
    print("No null values found in the 'Median' column.")


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
merged_df.to_csv('CleanTempByMajorCity.csv', index=False)

# Print the final data for inspection
print(merged_df.head())
