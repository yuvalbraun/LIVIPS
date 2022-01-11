
clear all
close all
clc
NumberOfCapturedFrames=398;%Number of frames to capture with the camera
FPS=398;
T=1/FPS;
CurrentDir='D:\RawVideos\';
NewMovies='.\VideoResults\';
ImageResults='.\ImageResults\';
file= load('mov');
mov =file.mov;
[Base,Freq,Location]  = FindFreqFromMovRaw( mov,1,FPS,5 );
[ FilteredLightTmp1,~] = ReconstructModulatedLightFastRaw( mov,Base(1,:),0 );
[ FilteredLightTmp2,~] = ReconstructModulatedLightFastRaw( mov,Base(2,:),0 );
[ FilteredLightTmp3,~] = ReconstructModulatedLightFastRaw( mov,Base(3,:),0 );
[ FilteredLightTmp12,~] = ReconstructModulatedLightFastRaw2( mov,Base(1,:),0 );

MovMeanRaw=mean(double(mov(:,:,1,:)*255),4);
 FilteredLightDemosaic1=uint8((double(demosaic(uint8(FilteredLightTmp1*255),'rggb'))./255)*255);
 FilteredLightDemosaic2=uint8((double(demosaic(uint8(FilteredLightTmp2*255),'rggb'))./255)*255);
 FilteredLightDemosaic3=uint8((double(demosaic(uint8(FilteredLightTmp3*255),'rggb'))./255)*255);
  FilteredLightDemosaic12=uint8((double(demosaic(uint8(FilteredLightTmp12*255),'rggb'))./255)*255);
 MovDemosaicMean=uint8(ColorBalanceRedLED(double(demosaic(uint8(MovMeanRaw),'rggb'))./255)*255);
green1=demosaic(uint8(FilteredLightTmp1*255),'rggb');
green2=demosaic(uint8(FilteredLightTmp2*255),'rggb');
green3=demosaic(uint8(FilteredLightTmp3*255),'rggb');
figure;
 h1 = subplot(2,2,1),imshow(FilteredLightDemosaic1,'parent',h1),title(h1,'filter1');hold on
 h2 = subplot(2,2,2),imshow(FilteredLightDemosaic2,'parent',h2),title(h2,'filter2'); 
 h3 = subplot(2,2,3),imshow(FilteredLightDemosaic3,'parent',h3),title(h3,'filter3'); 
 h4 = subplot(2,2,4),imshow(MovDemosaicMean,'parent',h4),title(h4,'origin');hold off
 [I1,I2,I3]=removeGreenBackground(green1,green2,green3,MovMeanRaw,FilteredLightDemosaic1,FilteredLightDemosaic2,FilteredLightDemosaic3);
 imwrite(I1,'image_01.png');    
 imwrite(I2,'image_02.png');    
 imwrite(I3,'image_03.png');    
%    directions  = find3direction3( FilteredLightDemosaic1,FilteredLightDemosaic2,FilteredLightDemosaic3 );
