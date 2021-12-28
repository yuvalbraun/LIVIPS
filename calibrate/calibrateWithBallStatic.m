%% calibrate the system using 3 constants light sources
%% set properties and open a new serial port
close all
clc
clear
ballRadius=20;
info = instrhwinfo('serial');
if isempty(info.AvailableSerialPorts)
   error('No ports free!');
end
I=instrfindall;
if ~isempty(I)
   fclose(instrfindall);
    delete(instrfindall);
    clear 
end
NumberOfCapturedFrames=1;%Number of frames to capture with the camera
CurrentDir='D:\RawVideos\';
NewMovies='.\VideoResults\';
ImageResults='.\ImageResults\';
topDir = fullfile(fileparts(mfilename('fullpath')), 'data');
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
 dlmwrite(fullfile(topDir, 'light_directions.txt'), directions, ...
    'delimiter', ' ', 'precision', '%20.16f');
 dlmwrite(fullfile(topDir, 'scale.txt'), ballRadius/r);
