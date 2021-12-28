function [tform,rmse]=findTransform(moving,fixed)
%% find registration between two points clouds
%input : moving is the transformed points cloud, fixed is the static cloud
%output : tform is rigid transformation
%created by Yuval Braun
% movingDownsampled = pcdownsample(moving,'gridAverage',1);
% fixedDownsampled = pcdownsample(fixed,'gridAverage',1);
movingDownsampled=moving;
fixedDownsampled=fixed;
% 
figure
pcshowpair(movingDownsampled,fixedDownsampled,'MarkerSize',5)
xlabel('X')
ylabel('Y')
zlabel('Z')
% title('Point clouds before registration')
legend({'Ground truth points cloud','Estimates points cloud'},'TextColor','w')
legend('Location','southoutside')
[tform,movingReg,rmse] = pcregistericp(movingDownsampled,fixedDownsampled);
figure
pcshowpair(movingReg,fixedDownsampled,'MarkerSize',5)
xlabel('X')
ylabel('Y')
zlabel('Z')
% title('Point clouds after registration')
legend({'Ground truth points cloud','Estimates points cloud'},'TextColor','w')
legend('Location','southoutside')
end
