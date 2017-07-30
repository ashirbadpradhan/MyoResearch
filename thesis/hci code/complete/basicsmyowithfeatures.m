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
d_eachclass=zeros(1,4);

disp('Starting')
%r=[];
res=[];
sampleWindow = [];
meanval=[];
rmsval=[];
varval=[];
wl=[];
featurevec=[];
zc=zeros(1,8);
waveformlength=zeros(1,8);
zerocrossing=[];

figure
tic
while(toc<T)
time_emg = m1.timeEMG_log;
data = m1.emg_log;
if size(data,1) > 30
    sampleWindow = data(end-29:end, :);
    absval=abs(sampleWindow);
    % compute features from the 30 readings in sample window
    %meanval=[meanval; mean(absval)];
    %rmsval=[rmsval; rms(absval)];
    %varval= [varval; var(absval)];
    for l=1:29
    z(1,1:8)=abs(absval(l+1,1:8)-absval(l,1:8));
    waveformlength=waveformlength+z(1,1:8);
    end
    %wl= [wl; waveformlength];
     for i=1:29
          for(j=1:8)
            if sampleWindow(i,j).*sampleWindow(i+1,j)<0
            zc(j)=zc(j)+1;
            else
            zc(j)=zc(j)+0;
            end
          end
     end
     %zerocrossing=[zerocrossing;zc];
    r= [mean(absval(:,[3 7])) rms(absval(:,[3 7])) var(absval(:,[3 7])) waveformlength(1,[3 7]) zc(1,[3 7])];
    featurevec=[featurevec;r];
    zc=zeros(1,8);
    waveformlength=zeros(1,8);
end 
plot(data);
drawnow


end

disp('Stopping')
m1.stopStreaming();
    
%featurevec=[meanval(x(1):x(2),:) rmsval(x(1):x(2),:) varval(x(1):x(2),:) waveformlength(x(1):x(2),:) zc(x(1):x(2),:)];
csvwrite('features_emg_myo.csv',featurevec);