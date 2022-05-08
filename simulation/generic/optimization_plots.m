
%% only for plot 
indexOfInterest = ( x< 440) & (x > 360);
figure
plot(x,y)
title("\fontname{Times New Roman}Angular Error of Bunny",'fontweight','bold','fontsize',16)
rectangle('Position',[360,3.40,80,0.77],EdgeColor='r')
xlabel("\fontname{Times New Roman}Number of Frames (N)",'fontweight','bold','fontsize',16);
ylabel("\fontname{Times New Roman}Mean Angular Error",'fontweight','bold','fontsize',16)
axes('position',[.55 .5 .25 .25])
plot(x(indexOfInterest),y(indexOfInterest));
box on
axis tight
figure
plot(x,total)
title("\fontname{Times New Roman}Sum of Distances From Sources Frequencies \psi (N)",'fontweight','bold','fontsize',16)
rectangle('Position',[360,0,80,2.7],EdgeColor='r')
xlabel("\fontname{Times New Roman}Number of Frames (N)",'fontweight','bold','fontsize',16);
ylabel("\fontname{Times New Roman}\psi (N)",'fontweight','bold','fontsize',16)
axes('position',[.55 .5 .25 .25])
plot(x(indexOfInterest),total(indexOfInterest));
box on
axis tight
figure
scatter(total,y,'.')
xlabel("\fontname{Times New Roman}\psi(N)",'fontweight','bold','fontsize',16)
ylabel("\fontname{Times New Roman}Mean Angular Error",'fontweight','bold','fontsize',16)
figure
scatter3(x,total,y,'.')
xlabel("\fontname{Times New Roman}N frames",'fontweight','bold','fontsize',16);
ylabel("\fontname{Times New Roman}\psi(N)",'fontweight','bold','fontsize',16)
zlabel("\fontname{Times New Roman}Mean Angular Error",'fontweight','bold','fontsize',16)

