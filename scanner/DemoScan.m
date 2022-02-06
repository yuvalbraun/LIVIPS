%% demo of full scan and 3D reconstruction (with 3 sources). The system must be calibrated before
close all
clc
clear 

%% close all previous connections
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

%% set properties
ExposureSet=150;
NumberOfCapturedFrames=398;%Number of frames to capture with the camera
FPS=398;
T=1/FPS;
create_GT=0;
saveBW=0;
if saveBW==0
    BW = load('MASK').BW;
end

%% set dir and path
currentDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currentDir,"scanner");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");
resultsDir=currentDir+"\results";







%% initialize the camera and open port
% input('please turn on all the light at the highest intensity')
% [capture,vid]=InitCameraRaw;
[capture,vid,ExposureSet,GainSet]=InitCameraRaw_(NumberOfCapturedFrames,ExposureSet);
s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 115200);
fopen(s);
pause(1);

%% turn on the LEDs, take a sequance of images and turn off the leds
fprintf(s,'%s',char(192+30));
pause(1);
fprintf(s,'%s',char(128+36));
pause(0.9);
fprintf(s,'%s',char(64+20));
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
[Base,Freq,Location]  = FindFreqFromMovRaw( mov,1,FPS,3 );
[ FilteredLightTmp1,~] = ReconstructModulatedLightFastRaw( mov,Base(1,:),0 );
[ FilteredLightTmp2,~] = ReconstructModulatedLightFastRaw( mov,Base(2,:),0 );
[ FilteredLightTmp3,~] = ReconstructModulatedLightFastRaw( mov,Base(3,:),0 );
MovMeanRaw=mean(double(mov(:,:,1,:)*255),4);
 FilteredLightDemosaic1=double(demosaic(uint8(FilteredLightTmp1*255),'bggr'))./255;
 FilteredLightDemosaic2=double(demosaic(uint8(FilteredLightTmp2*255),'bggr'))./255;
 FilteredLightDemosaic3=double(demosaic(uint8(FilteredLightTmp3*255),'bggr'))./255;
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
 I=zeros(size(FilteredLightDemosaic1,1),size(FilteredLightDemosaic1,2),size(FilteredLightDemosaic1,3),3);
 I(:,:,:,1)=FilteredLightDemosaic1.*BW;
 I(:,:,:,2)=FilteredLightDemosaic2.*BW;
 I(:,:,:,3)=FilteredLightDemosaic3.*BW;
 imwrite(I(:,:,:,1),imagesDir+'\image_01.png');    
 imwrite(I(:,:,:,2),imagesDir+'\image_02.png');    
 imwrite(I(:,:,:,3),imagesDir+'\image_03.png');
 for i=1:3
     image=I(:,:,:,i);
     save(imagesDir + "\image_0"+num2str(i),'image');
 end
     
    


%%   perform photometric stereo algorithm
demoPSBox;


%% save as GT
if create_GT==1
    save(currentDir+"\GT_face",'n','Z')
end


%% evaluate with GT
n_GT=load(currentDir+"\GT_face").n;
Z_GT=load(currentDir+"\GT_face").Z;

degrees=calcDegreeError(n_GT,n);
[H1,W1,D1]=size(degrees);
figure
%imagesc(flipud(degrees'));
him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
shading flat;
set(gca, 'ydir', 'reverse');
%title('angular error map');
colorbar;   
medianDegree=calcMedian(degrees);
avDegree=calcSum(degrees);
figure
histogram(degrees);
xlabel('angular error [degrees]');
ylabel('number of points');
title('angular error histogram');

save(resultsDir+"\LIVI "+datestr(now,'mm-dd-yyyy HH-MM'),'mov','create_GT','ExposureSet','n_GT','Z_GT','FPS','NumberOfCapturedFrames','BW')

%save('Zmap_LIVI','Z');
%save('nmap_LIVI','n');