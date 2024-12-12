# look at the data to understand it 

head -n 10 GlobalLandTemperaturesByMajorCity.csv

#dt,AverageTemperature,AverageTemperatureUncertainty,City

#AverageTemperatureUncertainty is important for scientific accuracy 
#but not neccesarily for visualizing and understanding the data so we can drop it

cut -d, -f1,2,4,5,6,7 GlobalLandTemperaturesByMajorCity.csv > tempByMajorCity.csv

grep ',,' tempByMajorCity.csv | wc -l 

cat tempByMajorCity.csv | wc -l 

python3 MRTemperatureMedian.py tempByMajorCity.csv > medians.txt

#now we impute the medians into the csv file and save it in a new csv file
python3 medians.py 