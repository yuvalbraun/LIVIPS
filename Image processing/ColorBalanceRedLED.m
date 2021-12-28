function ImWB=ColorBalanceRedLED(Im)
% this function gets an 8 bit RGB image and turns it into a white balance
%created by Amir Kolaman, edited by Yuval Braun

 Im=double(Im);

Factors(3)=1.76;
Factors(2)=1.26;
Factors(1)=1;

Brightness=1;


ImWB(:,:,3)=Im(:,:,3)*Factors(3);
ImWB(:,:,2)=Im(:,:,2)*Factors(2);
ImWB(:,:,1)=Im(:,:,1)*Factors(1);
ImGrey=ImWB(:,:,1)/3+ImWB(:,:,2)/3+ImWB(:,:,3)/3;
Iblur=imresize(ImGrey,0.1,'nearest');
% PSF = fspecial('gaussian',25,25);
% Iblur = imfilter(ImGrey,PSF,'symmetric','conv');
[counts,binLocations]=imhist(Iblur);
TenPerCent=0.05*size(Iblur,2)*size(Iblur,1);
Accumulator=0;
ii=floor(max(double(counts>0).*(256*binLocations)));
if ii==0 
    ii=1;
end
while Accumulator< TenPerCent
Accumulator=Accumulator+counts(ii);
    ii=ii-1;
 if ii==0
     Accumulator=TenPerCent;
    ii=1;
end   
end
ImMaxDiff=0.98/binLocations(ii);
if ImMaxDiff>10
%     display(num2str(ImMaxDiff));
    ImMaxDiff=10;
end
ImWB=Brightness.*ImWB*ImMaxDiff;