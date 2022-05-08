%% find the light directions using chrome ball and 3 constants light sources
% created by Yuval Braun
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
NumberOfCapturedFrames=1;%Number of frames to capture with the camera
FPS=398;
T=1/FPS;

%% initialize the camera
% input('please turn on all the light at the highest intensity')
% [capture,vid]=InitCameraRaw;
[capture,vid,ExposureSet,GainSet]=InitCameraRaw_(NumberOfCapturedFrames);
s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 115200);
fopen(s);
%% turn on all each LED seperately and capture image
pause(1);
[capture,vid,ExposureSet,GainSet]=InitCameraRaw_(NumberOfCapturedFrames);
vid.ReturnedColorSpace ='rgb';
fprintf(s,'%s',char(64+56));
pause(1);
trigger(vid);
img1 = getdata(vid);
pause(0.1);
fprintf(s,'%s',char(64));
pause(0.9);
fprintf(s,'%s',char(128+56));
pause(1);
trigger(vid);
img2 = getdata(vid);
pause(0.1);
fprintf(s,'%s',char(128));
pause(0.9);
fprintf(s,'%s',char(192+56));
pause(1);
trigger(vid);
img3 = getdata(vid);
fprintf(s,'%s',char(192));
fclose(s);
%% find and save light directions
 [directions,r]  = find3direction3( img1,img2,img3,img3 );
  directions(2,:) =-directions(2,:);
 dlmwrite(fullfile(dataDir, 'light_directions.txt'), directions, ...
    'delimiter', ' ', 'precision', '%20.16f');
 dlmwrite(fullfile(dataDir, 'scale.txt'), ballRadius/r);

