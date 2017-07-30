% clear all
countMyos = 1;%number of myos connected
mm = MyoMex(countMyos);
% pause(5)
close all
m1 = mm.myoData(1);
pause(0.5)
% pause(0.1);
% mm.myoData
% length(mm.myoData.timeIMU_log)
% plot(mm.myoData.timeEMG_log,mm.myoData.emg_log)
%pre_five_time = m1.timeEMG_log;
%pre_five_data = m1.emg_log;
%plot(pre_five_time, pre_five_data);
%plot(pre_five_data);


% collect about T seconds of data

T = 20; % seconds
m1.clearLogs()
m1.startStreaming();
 pause(2);
figure
tic
disp('Starting')
i=0;
while(toc<T)
time_emg = m1.timeEMG_log;
data = m1.emg_log;

% figure
%plot(data);
plot(time_emg(end-300:end),data(end-300:end,:));
%g=length(data());
%p=g-5;
%axis([p g]);

axis('tight');
ylim([-2 2]);
drawnow
ylim([-2 2]);
%axis([xmin xmax ymin ymax] );
%i=i+1;
%h = plot(t,y,'YDataSource','y');
%refreshdata(h,'caller') 

i=i+1;
end
disp('Stopping')
m1.stopStreaming();
