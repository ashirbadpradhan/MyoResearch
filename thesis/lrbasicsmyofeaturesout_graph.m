% % data=csvread('datalr1.csv');
% % tbl = mat2dataset(data);
% % mdl = LinearModel.fit(tbl)
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

% s=1;
% t=30;
% k=0;
d_eachclass=zeros(1,4);

disp('Starting')
%r=[];
%y=[];
res=[];
res_sum=[];
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
if  size(data,1) > 60
    sampleWindow = data(end-59:end, :);
    absval=abs(sampleWindow);
    r= rms(absval(:,1:8));
    rsum=sum(r);
    %featurevec=[featurevec;r];
    %ypred = predict(mdl,r) ;
    %y=[y;ypred];
    
    for i=1:3
        %meanvalue(:,i) = abs(lda.Average(:,i)-featurevec(:,j));
        d_eachclass(i) = r*lda.W(:,i)+lda.C(1,i);
        
    end
    results = d_eachclass;      
    [C,I]=max(results);
    if (I==3)
    I=0;
    end
    res=[res;I];
    res_sum=[res_sum;rsum];
    d_eachclass=0;
    I=0;
   %pause(0.005)
   
 
  plot(res);
  drawnow
    
end

% plot(y);
% drawnow

end

disp('Stopping')
m1.stopStreaming();

 
    
%featurevec=[meanval(x(1):x(2),:) rmsval(x(1):x(2),:) varval(x(1):x(2),:) waveformlength(x(1):x(2),:) zc(x(1):x(2),:)];
%csvwrite('features_emg_myo.csv',featurevec);