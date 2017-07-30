% filename='emgmyo_flexext.csv';
% data=csvread(filename);
% tbl = mat2dataset(data);
% mdl = LinearModel.fit(tbl)
% clear all
close all
system('python myoTargetGUI.py &');
% fileMove=fopen('moves.txt','w');
% fprintf(fileMove,'0,0,0');
% fclose(fileMove);
countMyos = 1;%number of myos connected
mm = MyoMex(countMyos);
% pause(5)
close all
m1 = mm.myoData(1);
pause(0.5)
mdl=mdl1;
mdl2=mdl2;
% pause(0.1);
% mm.myoData

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
y=[];
y_fe=[];
y_ru=[];
z=[];
% res=[];
% sampleWindow = [];
% meanval=[];
% rmsval=[];
% varval=[];
% wl=[];
avg_ang_fe=[];
avg_ang_ru=[];
featurevec=[];
% zc=zeros(1,8);
% waveformlength=zeros(1,8);
%zerocrossing=[];

%figure
tic
while(toc<T)
time_emg = m1.timeEMG_log;
data = m1.emg_log;
if  size(data,1) > 160
    sampleWindow = data(end-39:end, :);
    absval=abs(sampleWindow);
    r= rms( absval(:,1:8));
%     featurevec=[featurevec;r]
    a=[0.2 0.2 0.2 1 1 0.2 0.2 1];
    b = [1 1 1 0.2 0.2 1 1 0.2] ;
    r1=a.*r;
    r2=b.*r;
    ypred_fe = predict(mdl,r1) ;
    ypred_ru = predict(mdl2,r2) ;
    %ypred2 = predict(mdl2,r) ;
    y_fe=[y_fe;ypred_fe];
    y_ru=[y_ru;ypred_ru];
    if size(y_fe,1)>15
        window_fe=y_fe(end-14:end);
        window_ru=y_ru(end-14:end);
        avg_ang_fe=floor(mean(window_fe));
        avg_ang_ru=floor(mean(window_ru));
    end
    z=[avg_ang_fe -avg_ang_ru 0];
    pause(0.01)
    fileMove=fopen('moves.txt','w');
    fprintf(fileMove,'%d,%d,%d',z);
    fclose(fileMove);
    %csvwrite('moves.csv',z,0,0);
    
    %csvread('angles.csv')
end

%  plot(z);
%  drawnow

end

disp('Stopping')
m1.stopStreaming();
%   csvwrite('angles.csv',y);  
%featurevec=[meanval(x(1):x(2),:) rmsval(x(1):x(2),:) varval(x(1):x(2),:) waveformlength(x(1):x(2),:) zc(x(1):x(2),:)];
% csvwrite('features_emg_myo.csv',featurevec);