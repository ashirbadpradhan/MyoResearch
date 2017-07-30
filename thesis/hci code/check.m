% for i=1:598
%     if (strcmpi(labels_pred(i,1),'open')== 1)
%         i
%     end
% end

close all
    scatterd(train(:,[1 2]));
for i=1:1200
    pause(0.05)
    hold on
    scatterd(test(i,[1 2]));
    labels_pred(i,:)
end


hold off
