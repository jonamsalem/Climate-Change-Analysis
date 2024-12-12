import numpy as np
from mrjob.step import MRStep
from mrjob.job import MRJob

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

class MRTemperatureMedian(MRJob):
    def mapper(self, _, line):
        if line.startswith('dt,'):
            return
        
        try:
            fields = line.strip().split(',')
            if len(fields) == 6:
                date, temp, city, country, lat, long = fields
                if temp.strip():
                    temp_float = float(temp)
                    normalized_city = normalize_city_names(city)
                    yield normalized_city, temp_float
        except (ValueError, IndexError) as e:
            print(f"DEBUG Mapper Error: {str(e)} on line: {line}")
            
    def reducer(self, city, temperatures):
        temp_list = list(temperatures)
        if temp_list:
            median_temp = np.median(temp_list)
            # Output format: city temp
            yield city, round(median_temp, 2)
            
    def steps(self):
        return [
            MRStep(mapper=self.mapper, reducer=self.reducer)
        ]

if __name__ == '__main__':
    MRTemperatureMedian.run()