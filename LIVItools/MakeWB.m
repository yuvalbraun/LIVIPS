function ImWB=MakeWB(Im)
% this function gets an 8 bit RGB image and turns it into a white balance
% image
Brightness=0.7;
% 
Im=double(Im);
ImAvg=mean(mean(Im));

Factors=max(ImAvg,0.5)./ImAvg; % this is for grey patch
% Factors=max(ImAvg,0.9)./ImAvg; % this is for white card

ImWB(:,:,3)=Im(:,:,3)*Factors(3)*Brightness;
ImWB(:,:,2)=Im(:,:,2)*Factors(2)*Brightness;
ImWB(:,:,1)=Im(:,:,1)*Factors(1)*Brightness;

ImGrey=ImWB(:,:,1)/3+ImWB(:,:,2)/3+ImWB(:,:,3)/3;
PSF = fspecial('gaussian',25,25);
Iblur = imfilter(ImGrey,PSF,'symmetric','conv');
ImMaxDiff=0.98/max(max(Iblur));
ImWB=ImWB*ImMaxDiff;