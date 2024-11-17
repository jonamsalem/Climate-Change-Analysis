# look at the data to understand it 

head -n 10 GlobalLandTemperaturesByCountry.csv

#dt,AverageTemperature,AverageTemperatureUncertainty,Country

#AverageTemperatureUncertainty is important for scientific accuracy 
#but not neccesarily for visualizing and understanding the data so we can drop it


cut -d, -f1,2,4 GlobalLandTemperaturesByCountry.csv > tempByCountry.csv

#remove any field where location is North America, South America, Europe, Asia, Africa. Had to use gsub to remove carriage returns
awk -F, '{gsub(/\r/, ""); if ($3 != "Africa" && $3 != "Asia" && $3 != "Europe" && $3 != "North America" && $3 != "South America" && $3 != "Oceania" && $3 != "Antarctica") print $0}' tempByCountry.csv > temp.csv && mv temp.csv tempByCountry.csv

grep ',,' tempByCountry.csv | wc -l #31274

cat tempByCountry.csv | wc -l #562296

#31274/562296 = 0.056. We can drop these rows but lets use MR to find the median and instead impute the missing values


python3 MRTemperatureMedian.py tempByCountry.csv > medians.txt

#now we impute the medians into the csv file and save it in a new csv file
python3 medians.py 