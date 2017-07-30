% clear all
countMyos = 1;%number of myos connected
mm = MyoMex(countMyos);
% pause(5)
close all
m1 = mm.myoData(1);
filename='emg_myo_openclose_ash20.csv'
direction = 0;
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
T = 3; % seconds
m1.clearLogs()
m1.startStreaming();
pause(0.5)

s=1;
t=30;
k=0;
%d_eachclass=zeros(1,4);

disp('Starting')
%r=[];
% res=[];
% sampleWindow = [];
% meanval=[];
% rmsval=[];
% varval=[];
% wl=[];
featurevec=[];
% zc=zeros(1,8);
% waveformlength=zeros(1,8);
%zerocrossing=[];

figure
tic
while(toc<T)
time_emg = m1.timeEMG_log;
data = m1.emg_log;
if  size(data,1) > 50
    sampleWindow = data(end-49:end, :);
    absval=abs(sampleWindow);
    r= rms( absval(:,1:8));
    featurevec=[featurevec;r];
end 
plot(data);
drawnow


end

disp('Stopping')
m1.stopStreaming();

% filename='emgmyo_flexext5.csv'
% data1=csvread('emgmyo_flexext5.csv');
if direction>0
x=featurevec(:,8);

[xmax,Imax]=max(x);
[xmin,Imin]=min(x);

x=x(Imin:Imax);
maxind = find(x>xmax-0.15*xmax,1,'first')
minind = find(x<xmin+0.15*xmin,1,'last')

range=maxind+1-minind;
ang=linspace(0,90,range);
ang=ang';
featurevec=featurevec(minind:maxind,:);
featurevec(:,9)=ang;
dlmwrite(filename,featurevec,'-append');
end

if direction<0
x=featurevec(:,2);

[xmax,Imax]=max(x);
[xmin,Imin]=min(x);

x=x(Imin:Imax);
maxind = find(x>xmax-0.15*xmax,1,'first')
minind = find(x<xmin+0.15*xmin,1,'last')

range=maxind+1-minind;
ang=linspace(0,-90,range);
ang=ang';
featurevec=featurevec(minind:maxind,:);
featurevec(:,9)=ang;
dlmwrite(filename,featurevec,'-append');
end
%featurevec=[meanval(x(1):x(2),:) rmsval(x(1):x(2),:) varval(x(1):x(2),:) waveformlength(x(1):x(2),:) zc(x(1):x(2),:)];
%dlmwrite(filename,featurevec,'-append');
figure 
plot(x)