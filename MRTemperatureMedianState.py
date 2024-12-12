import numpy as np
from mrjob.step import MRStep
from mrjob.job import MRJob

class MRTemperatureMedian(MRJob):
    def mapper(self, _, line):
        if line.startswith('dt,'):
            return
        
        try:
            fields = line.strip().split(',')
            if len(fields) == 4:
                date, temp, _, state = fields
                if temp.strip():  
                    temp_float = float(temp)
                    yield state, temp_float
        except (ValueError, IndexError) as e:
            print(f"DEBUG Mapper Error: {str(e)} on line: {line}")
            
    def reducer(self, state, temperatures):
        temp_list = list(temperatures)
        if temp_list:
            median_temp = np.median(temp_list)
            yield state, round(median_temp, 2)
            
    def steps(self):
        return [
            MRStep(mapper=self.mapper, reducer=self.reducer)
        ]

if __name__ == '__main__':
    MRTemperatureMedian.run()