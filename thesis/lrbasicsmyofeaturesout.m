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
mdl=mdl3;
% mdl2=mdl2;
% pause(0.1);
% mm.myoData

aa=1200

T = 30; % seconds
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
z=[];
% res=[];
% sampleWindow = [];
% meanval=[];
% rmsval=[];
% varval=[];
% wl=[];
avg_ang=[];
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
    r1= rms( absval(:,1:8));
    %a=[1 0 0 1 1 1 1 1];
    %a = [1 0 0 0 1 1 1 1];
    a = [1 1 1 1 1 1 1 1]; 
    r=a.*r1;
    %featurevec=[featurevec;r];
    ypred = predict(mdl,r) ;
    y=[y;ypred];
    if size(y,1)>15
        window=y(end-14:end);
        %window_ru=y2(end-14:end);
        avg_ang=floor(mean(window));
        %avg_ang_ru=floor(mean(window_ru));
    end
    z=[0 avg_ang 0];
    pause(0.03)
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