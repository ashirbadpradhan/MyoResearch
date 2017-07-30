
clear all
countMyos = 1;%number of myos connected
mm = MyoMex(countMyos);
% pause(5)
close all
m1 = mm.myoData(1);
pause(1)
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
tic
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
% csvwrite('test_01.csv',data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

%close all



% data = csvread('test_01.csv');
length=size(data,1)
s=1;
t=30;
k=0;
% l=0;
aa=length;
absval=abs(data);
meanval=zeros(aa,8);%aa+1 for discrete windows
maxval=zeros(aa,8);
rmsval=zeros(aa,8);
varval=zeros(aa,8);
sumval=zeros(aa,8);
waveformlength=zeros(aa,8);
zc=zeros(aa,8);
% rem=length-aa*20


while t<length
    k=k+1;
% d1=data(s:t,10:11);
    sumval(k,:)=sum(absval(s:t,2:9));
    meanval(k,:)=mean(absval(s:t,2:9));
%     maxval(k,:)=max(absval(s:t,2:9));
    rmsval(k,:)=rms(absval(s:t,2:9));
    varval(k,:)= var(absval(s:t,2:9));
   %waveform length
    for(l=s:t-1)
    z(1,2:9)=abs(absval(l+1,2:9)-absval(l,2:9));
    waveformlength(k,:)=waveformlength(k,:)+z(1,2:9);
    end
    
    
    %zero crossing
  
      for i=s:t-1
          for(j=2:9)
            if data(i,j).*data(i+1,j)<0
            zc(k,j-1)=zc(k,j-1)+1;
            else
            zc(k,j-1)=zc(k,j-1)+0;
            end
          end
      end
  
    s=s+1;
    t=t+1;
end
% a(1,:)=mean(absval(:,:));
 
%last row
% meanval(aa+1,:)=mean(absval(aa*30:length,2:9));
%  maxval(aa+1,:)=max(absval(aa*30:length,2:9));

plot(absval(:,1),absval(:,2:9));
figure
plot(meanval);
% % figure
% % plot(maxval);
% figure
% plot(rmsval);
% figure
% plot(varval);
% figure
% plot(waveformlength);
% 

% [x,y]=ginput(2);

%peak value approach
[C,I]=max(meanval(:,:));
[cc,n]=max(C);%return n for max val
x=I(n)
n
x(1)=x-20;
x(2)=x+20;
%write into a new file
featurevec=[meanval(x(1):x(2),:) rmsval(x(1):x(2),:) varval(x(1):x(2),:) waveformlength(x(1):x(2),:) zc(x(1):x(2),:)];
dlmwrite('features8_train_left_50.csv',featurevec,'-append');
featurevec=[meanval(x(1):x(2), [1 3 5 7]) rmsval(x(1):x(2),[1 3 5 7]) varval(x(1):x(2),[1 3 5 7]) waveformlength(x(1):x(2),[1 3 5 7]) zc(x(1):x(2),[1 3 5 7])];
dlmwrite('features4_train_left_50.csv',featurevec,'-append');
featurevec=[meanval(x(1):x(2),[3 7]) rmsval(x(1):x(2),[3 7]) varval(x(1):x(2),[3 7]) waveformlength(x(1):x(2),[3 7]) zc(x(1):x(2),[3 7])];
dlmwrite('features2_train_left_50.csv',featurevec,'-append');

toc