%% demo of full scan and 3D reconstruction (with 3 sources). The system must be calibrated before
close all
clc
clear
I=instrfindall;
if ~isempty(I)
   fclose(instrfindall);
    delete(instrfindall);
    clear 
end
info = instrhwinfo('serial');
if isempty(info.AvailableSerialPorts)
   error('No ports free!');
end
saveBW=1;
if saveBW==0
    BW = load('MASK').BW;
end


%% set properties
FPS=398;
T=1/FPS;
topDir = fullfile(fileparts(mfilename('fullpath')), 'data');
NumberOfCapturedFrames=398;%Number of frames to capture with the camera


%% initialize the camera and open port
% input('please turn on all the light at the highest intensity')
% [capture,vid]=InitCameraRaw;
[capture,vid,ExposureSet,GainSet]=InitCameraRaw_(NumberOfCapturedFrames);
s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 115200);
fopen(s);
pause(1);

%% turn on the LEDs, take a sequance of images and turn off the leds
fprintf(s,'%s',char(192+44));
pause(1);
fprintf(s,'%s',char(128+43));
pause(0.9);
fprintf(s,'%s',char(64+50));
pause(1);
% 
[ mov ] = double(CaptureMovie_( vid,NumberOfCapturedFrames,0 ))./255;
fprintf(s,'%s',char(64));
pause(1);
fprintf(s,'%s',char(128));
pause(1);
fprintf(s,'%s',char(192));
pause(1);
fclose(s);
%% perform 3 filters to find 3 images
f=figure(1);
[Base,Freq,Location]  = FindFreqFromMovRaw( mov,1,FPS,3 ); %%todo to add pre_set frquancies
[ FilteredLightTmp1,~] = ReconstructModulatedLightFastRaw( mov,Base(1,:),0 );
[ FilteredLightTmp2,~] = ReconstructModulatedLightFastRaw( mov,Base(2,:),0 );
[ FilteredLightTmp3,~] = ReconstructModulatedLightFastRaw( mov,Base(3,:),0 );
MovMeanRaw=mean(double(mov(:,:,1,:)*255),4);
 FilteredLightDemosaic1=uint8((double(demosaic(uint8(FilteredLightTmp1*255),'bggr'))./255)*255);
 FilteredLightDemosaic2=uint8((double(demosaic(uint8(FilteredLightTmp2*255),'bggr'))./255)*255);
 FilteredLightDemosaic3=uint8((double(demosaic(uint8(FilteredLightTmp3*255),'bggr'))./255)*255);
 MovDemosaicMean=uint8(ColorBalanceRedLED(double(demosaic(uint8(MovMeanRaw),'bggr'))./255)*255);
%% plot images
figure;
 h1 = subplot(2,2,1),imshow(FilteredLightDemosaic1,'parent',h1),title(h1,'filter1');hold on
 h2 = subplot(2,2,2),imshow(FilteredLightDemosaic2,'parent',h2),title(h2,'filter2'); 
 h3 = subplot(2,2,3),imshow(FilteredLightDemosaic3,'parent',h3),title(h3,'filter3'); 
 h4 = subplot(2,2,4),imshow(MovDemosaicMean,'parent',h4),title(h4,'origin');hold off
 %% remove background and save the images
 %[I1,I2,I3]=removeBackground(MovDemosaicMean,FilteredLightDemosaic1,FilteredLightDemosaic2,FilteredLightDemosaic3);
  if saveBW==1
    [BW,maskedImage] = segmentImage(MovDemosaicMean);
    imwrite(maskedImage,'for_GT.png');
    save('MASK','BW');
 end

 I1=FilteredLightDemosaic1.*uint8(BW);
 I2=FilteredLightDemosaic2.*uint8(BW);
 I3=FilteredLightDemosaic3.*uint8(BW);
 topDir = fullfile(fileparts(mfilename('fullpath')), 'data');
 imwrite(I1,'C:\Users\yuval\Documents\meitar\LIVIPS\PSBox-v0.3.1\data\Objects\image_01.png');    
 imwrite(I2,'C:\Users\yuval\Documents\meitar\LIVIPS\PSBox-v0.3.1\data\Objects\image_02.png');    
 imwrite(I3,'C:\Users\yuval\Documents\meitar\LIVIPS\PSBox-v0.3.1\data\Objects\image_03.png');
     


%%   perform photometric stereo algorithm
demoPSBox;

%save('Zmap_LIVI','Z');
%save('nmap_LIVI','n');