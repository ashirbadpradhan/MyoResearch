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

subplot(2,1,1);
plot(data);
drawnow

    for i=1:4
        %meanvalue(:,i) = abs(lda.Average(:,i)-featurevec(:,j));
        d_eachclass(i) = r*lda.W(:,i)+lda.C(1,i);
        
    end
    results = d_eachclass;      
    [C,I]=max(results);
    if (I==4)
    I=0;
    end
    res=[res;I]
%     if I==1
%         disp('left');
%     elseif I==2
%         disp('right');
%      elseif I==3
%         disp('open');
%     else
%         disp('no movement'); 
%     end
    d_eachclass=0;
    I=0;
   pause(0.005)
   
  subplot(2,1,2)
  plot(res);
  drawnow
end
disp('Stopping')
m1.stopStreaming();




%featurevec=[meanval(:,[3 7]) rmsval(:,[3 7]) varval(:,[3 7]) waveformlength(:,[3 7]) zc(:,[3 7])];