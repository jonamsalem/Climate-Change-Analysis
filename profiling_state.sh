# look at the data to understand it 

head -n 10 GlobalLandTemperaturesByState.csv

#Columns: dt,AverageTemperature,AverageTemperatureUncertainty,State,Country

#AverageTemperatureUncertainty is important for scientific accuracy 
#but not neccesarily for visualizing and understanding the data so we can drop it

cut -d, -f1,2,4 GlobalLandTemperaturesByState.csv > tempByState.csv

#remove any field where location is a country because we are only focusing on country.
awk -F, '{gsub(/\r/, ""); if ($3 != "Country" && $3 != "Unknown") print $0}' tempByState.csv > temp.csv && mv temp.csv tempByState.csv

#count rows with missing AverageTemperature values
grep ',,' tempByState.csv | wc -l 

#count total rows for comparison
cat tempByState.csv | wc -l 

# Use MapReduce to calculate medians
python3 MRTemperatureMedian.py tempByState.csv > medians_state.txt

#impute the medians into the csv file and save it in a new csv file
python3 medians_state.py 