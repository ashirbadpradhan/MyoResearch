s=1;
t=30;
k=0;
length=size(data,1);
zc=zeros(length,8);
while t<length
     k=k+1;
     
      for i=s:t-1
          for(j=1:8)
            if data(i,j).*data(i+1,j)<0
            zc(k,j)=zc(k,j)+1;
            else
            zc(k,j)=zc(k,j)+0;
            end
          end
      end
    s=s+1;
    t=t+1;
end