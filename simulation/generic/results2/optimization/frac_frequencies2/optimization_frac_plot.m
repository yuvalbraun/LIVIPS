indexOfInterest = ( x< 800) & (x > 720);
%indexOfInterest = ( x< 440) & (x > 360);
figure
plot(x,y,'LineWidth',1.5)
hold on
plot(x,padded,'LineWidth',1.5)
plot(x,z,'LineWidth',1.5)
legend("\fontname{Times New Roman}DFT with N Points","\fontname{Times New Roman}DFT with Zero Padding to 800 points","\fontname{Times New Roman}N Points with Phase Correction")
%legend('DFT with N Points','DFT with Zero Padding to 400 points')
title("\fontname{Times New Roman}Angular Error of Bunny",'fontweight','bold','fontsize',16)
rectangle('Position',[720,2.80,80,0.77],EdgeColor='r')
%rectangle('Position',[360,3.35,80,0.87],EdgeColor='r')
xlabel("\fontname{Times New Roman}Number of Frames (N)",'fontweight','bold','fontsize',16);
ylabel("\fontname{Times New Roman}Mean Angular Error",'fontweight','bold','fontsize',16)
axes('position',[.55 .5 .25 .25])
plot(x(indexOfInterest),y(indexOfInterest),'LineWidth',1.5);
box on
hold on
plot(x(indexOfInterest),padded(indexOfInterest),'LineWidth',1.5);
plot(x(indexOfInterest),z(indexOfInterest),'LineWidth',1.5);
axis tight

