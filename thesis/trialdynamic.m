data_read1=csvread('emg_myo_flexext3_ash27.csv');
a = [1 0 0 1 1 1 1 1 1];
data1 = a.*data_read1;
tbl1 = mat2dataset(data1);
mdl1 = LinearModel.fit(tbl1)

data_read2=csvread('emg_myo_raduln5_ash27.csv');
b = [1 0 0 0 1 1 1 1 1]; 
data2 = b.*data_read2;
tbl2 = mat2dataset(data2);
mdl2 = LinearModel.fit(tbl2)


data_read3=csvread('emg_myo_prosup3_ash28.csv');
data_read3=data_read3(:,[1 2 3 4 5 6 7 8 10]);
c = [1 1 1 1 1 1 1 1 1]; 
data3 = c.*data_read3;
tbl3 = mat2dataset(data3);
mdl3 = LinearModel.fit(tbl3)
