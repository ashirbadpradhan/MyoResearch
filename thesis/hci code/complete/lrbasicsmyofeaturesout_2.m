% data1=csvread('datalr1.csv');
% tbl1 = mat2dataset(data1);
% mdl1 = LinearModel.fit(tbl1)
% data2=csvread('lrtrainulna.csv');
% tbl2 = mat2dataset(data2);
% mdl2 = LinearModel.fit(tbl2)
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
% pre_five_time = m1.timeEMG_log;
% pre_five_data = m1.emg_log;
%plot(pre_five_time, pre_five_data);
% plot(pre_five_data);

aa=1200

T = 20; % seconds
m1.clearLogs()
m1.startStreaming();
pause(0.5)

s=1;
t=30;
k=0;
%d_eachclass=zeros(1,4);

disp('Starting')
%r=[];
y1=[];
y2=[];
% res=[];
% sampleWindow = [];
% meanval=[];
% rmsval=[];
% varval=[];
% wl=[];
%featurevec=[];
% zc=zeros(1,8);
% waveformlength=zeros(1,8);
%zerocrossing=[];

figure
tic
while(toc<T)
time_emg = m1.timeEMG_log;
data = m1.emg_log;
if  size(data,1) > 80
    sampleWindow = data(end-79:end, :);
    absval=abs(sampleWindow);
    r= rms(absval(:,[1:8]));
    %featurevec=[featurevec;r];
    ypred1 = predict(mdl1,r) ;
    y1=[y1;ypred1];
    ypred2 = predict(mdl4,r) ;
    y2=[y2;ypred2];
end

plot(y1,'r');
hold on
plot(y2,'b');
drawnow

end
hold off
disp('Stopping')
m1.stopStreaming();
    
%featurevec=[meanval(x(1):x(2),:) rmsval(x(1):x(2),:) varval(x(1):x(2),:) waveformlength(x(1):x(2),:) zc(x(1):x(2),:)];
%csvwrite('features_emg_myo.csv',featurevec);