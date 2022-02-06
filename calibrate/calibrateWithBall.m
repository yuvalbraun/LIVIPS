%% set properties and open a new serial port
close all
clear
clc
info = instrhwinfo('serial');

if isempty(info.AvailableSerialPorts)
   I=instrfindall;
    if ~isempty(I)
     fclose(instrfindall);
     delete(instrfindall);
     clear 
    end
end
I=instrfindall;
if ~isempty(I)
   fclose(instrfindall);
    delete(instrfindall);
    clear 
end
%% set dir and path
currnetDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currnetDir,"calibrate");
dataDir=topDir+"PSBox-v0.3.1\data";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");


%% set parameters

ballRadius=20; %%radius in mm
NumberOfCapturedFrames=398;%Number of frames to capture with the camera
FPS=398;
T=1/FPS;

%% initialize the camera
% input('please turn on all the light at the highest intensity')
% [capture,vid]=InitCameraRaw;
[capture,vid,ExposureSet,GainSet]=InitCameraRaw_(NumberOfCapturedFrames,200);
s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 115200);
fopen(s);
%% turn on all LEDs on
pause(1);
fprintf(s,'%s',char(192+44));
pause(1);
fprintf(s,'%s',char(128+43));
pause(1);
fprintf(s,'%s',char(64+50));
pause(1);
%% capture movie and turn off all LEDs on
[ mov ] = double(CaptureMovie_( vid,NumberOfCapturedFrames,0 ))./255;
fprintf(s,'%s',char(64));
pause(1);
fprintf(s,'%s',char(128));
pause(1);
fprintf(s,'%s',char(192));
pause(1);
fclose(s);
save('ball.mat','mov');
%% perform 3 filters to find 3 images
f=figure(1);
[Base,Freq,Location]  = FindFreqFromMovRaw( mov,1,FPS,3 );
[ FilteredLightTmp1,~] = ReconstructModulatedLightFastRaw( mov,Base(1,:),0 );
[ FilteredLightTmp2,~] = ReconstructModulatedLightFastRaw( mov,Base(2,:),0 );
[ FilteredLightTmp3,~] = ReconstructModulatedLightFastRaw( mov,Base(3,:),0 );
MovMeanRaw=mean(double(mov(:,:,1,:)*255),4);
 FilteredLightDemosaic1=uint8(ColorBalanceRedLED(double(demosaic(uint8(FilteredLightTmp1*255),'rggb'))./255)*255);
 FilteredLightDemosaic2=uint8(ColorBalanceRedLED(double(demosaic(uint8(FilteredLightTmp2*255),'rggb'))./255)*255);
 FilteredLightDemosaic3=uint8(ColorBalanceRedLED(double(demosaic(uint8(FilteredLightTmp3*255),'rggb'))./255)*255);
 MovDemosaicMean=uint8(ColorBalanceRedLED(double(demosaic(uint8(MovMeanRaw),'rggb'))./255)*255);
figure;
%% plot images
 h1 = subplot(2,2,1),imshow(FilteredLightDemosaic1,'parent',h1),title(h1,'filter1');hold on
 h2 = subplot(2,2,2),imshow(FilteredLightDemosaic2,'parent',h2),title(h2,'filter2'); 
 h3 = subplot(2,2,3),imshow(FilteredLightDemosaic3,'parent',h3),title(h3,'filter3'); 
 h4 = subplot(2,2,4),imshow(MovDemosaicMean,'parent',h4),title(h4,'origin');hold off
%% find and save light directions
 [directions,r]  = find3direction3( FilteredLightDemosaic1,FilteredLightDemosaic2,FilteredLightDemosaic3,MovDemosaicMean );
  directions(2,:) =-directions(2,:);
 dlmwrite(fullfile(dataDir, 'light_directions.txt'), directions, ...
    'delimiter', ' ', 'precision', '%20.16f');
 dlmwrite(fullfile(dataDir, 'scale.txt'), ballRadius/r);

