% start streaming doesn't really work, use with clear logs...
%stopstreaming doesn't work without start streaming

clear all
countMyos = 1;%number of myos connected
mm = MyoMex(countMyos);
% pause(5)
close all
m1 = mm.myoData(1);
pause(5)
% pause(0.1);
% mm.myoData
% length(mm.myoData.timeIMU_log)
% plot(mm.myoData.timeEMG_log,mm.myoData.emg_log)
pre_five_time = m1.timeEMG_log;
pre_five_data = m1.emg_log;
plot(pre_five_time, pre_five_data);

% collect about T seconds of data
T = 3; % seconds
m1.clearLogs()
m1.startStreaming();
pause(T);
first_five_time = m1.timeEMG_log;
first_five_data = m1.emg_log;
figure
plot(first_five_time, first_five_data);



m1.stopStreaming();


fprintf('Logged data for %d seconds,\n\t',T);
fprintf('IMU samples: %10d\tApprox. IMU sample rate: %5.2f\n\t',...
length(m1.timeIMU_log),length(m1.timeIMU_log)/T);
fprintf('EMG samples: %10d\tApprox. EMG sample rate: %5.2f\n\t',...
length(m1.timeEMG_log),length(m1.timeEMG_log)/T);



data=[first_five_time,first_five_data];
csvwrite('test_01.csv',data);

% plot(mm.myoData.timeEMG_log,mm.myoData.emg_log)


% mm.delete();
% clear mm
