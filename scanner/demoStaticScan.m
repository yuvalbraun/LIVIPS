%% demo of full scan and 3D reconstruction using classic PS (without modulation). The system must be calibrated before %% work only with the FPGA based system described on the appendix
%% crated by Yuval Braun
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
%% set parameters
ExposureSet=300; %set exposure time [us]
flash_no_flash=0; % set to 1 to use flash no flash
NumberOfCapturedFrames=100;%Number of frames to capture with the camera
saveBW=1;  % set to 1 to create new mask. 0 to use the previous mask
create_GT=0;  %set to 1 to create new GT. 0 to use the previous GT
if saveBW==0
    BW = load('MASK').BW;
end

currentDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currentDir,"scanner");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
resultsDir=currentDir+"\results";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");
%% open a new port
s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 115200);
fopen(s);
pause(1);
%% set camera parameters
[capture,vid,ExposureSet,GainSet]=InitCameraRaw_(NumberOfCapturedFrames,ExposureSet);
%% no flesh
if flash_no_flash ==1
    trigger(vid);
    no_flash_mov = getdata(vid);
    no_flash=mean(no_flash_mov,4);
end
%vid.ReturnedColorSpace ='rgb';
%% take 3 images for calssic PS.
fprintf(s,'%s',char(128+56));
pause(1.1);
fprintf(s,'%s',char(64+56));
pause(1.1);
fprintf(s,'%s',char(128));
pause(1.1);
trigger(vid);
mov1 = getdata(vid);
pause(0.2);
fprintf(s,'%s',char(64));
pause(0.11);
fprintf(s,'%s',char(64));
pause(1);
fprintf(s,'%s',char(128+56));
pause(1);
trigger(vid);
mov2 = getdata(vid);
pause(0.1);
fprintf(s,'%s',char(128));
pause(0.8);
fprintf(s,'%s',char(192+56));
pause(1);
trigger(vid);

%% for segmentation only
mov3 = getdata(vid);
fprintf(s,'%s',char(128+56));
pause(1);
fprintf(s,'%s',char(64+56));
pause(1);
trigger(vid);

mov4 = getdata(vid); %%all lights on, just for segmentation
pause(1);

%% turn off all lights

fprintf(s,'%s',char(128));
pause(1);
fprintf(s,'%s',char(128));
pause(1);
fprintf(s,'%s',char(64));
pause(1);
fprintf(s,'%s',char(192));
pause(1);
fprintf(s,'%s',char(192));
%% close the port
fclose(s);

%% take the average frame
img1=mean(mov1,4);
img2=mean(mov2,4);
img3=mean(mov3,4);
img4=mean(mov4,4);

f=figure(1);
%% substruct the no flash image

if flash_no_flash==1
  img_sub1=img1-no_flash;
  img_sub2=img2-no_flash; 
  img_sub3=img3-no_flash;    
else
    img_sub1=img1;
    img_sub2=img2;
    img_sub3=img3;
end
 %% perform demoasic for color images   
 FilteredLightDemosaic1=double(demosaic(uint8(img_sub1),'bggr'))./255;
 FilteredLightDemosaic2=double(demosaic(uint8(img_sub2),'bggr'))./255;
 FilteredLightDemosaic3=double(demosaic(uint8(img_sub3),'bggr'))./255;
 FilteredLightDemosaic4=double(demosaic(uint8(img4),'bggr'))./255;

 %% create new mask if needed
 if saveBW==1
    [BW,maskedImage] = segmentStaticImage(FilteredLightDemosaic4);
    imwrite(maskedImage,'for_GT.png');
    save('MASK','BW');
 end
 I=zeros(size(FilteredLightDemosaic1,1),size(FilteredLightDemosaic1,2),size(FilteredLightDemosaic1,3),3);
 I(:,:,:,1)=FilteredLightDemosaic1.*BW;
 I(:,:,:,2)=FilteredLightDemosaic2.*BW;
 I(:,:,:,3)=FilteredLightDemosaic3.*BW;
 I4=FilteredLightDemosaic4.*BW; %% I4 is only for evaluation
 imwrite(I(:,:,:,1),imagesDir+'\image_01.png');    
 imwrite(I(:,:,:,2),imagesDir+'\image_02.png');    
 imwrite(I(:,:,:,3),imagesDir+'\image_03.png');
 imwrite(I4,imagesDir+'\forGT.png');
 for i=1:3
     image=I(:,:,:,i);
     save(imagesDir + "\image_0"+num2str(i),'image');
 end
     

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

%% save the results
if flash_no_flash ==1
    save(resultsDir+"\static "+datestr(now,'mm-dd-yyyy HH-MM'),'create_GT','NumberOfCapturedFrames','flash_no_flash','no_flash_mov','BW','mov1','mov2','mov3','mov4','ExposureSet')
else
    save(resultsDir+"\static "+datestr(now,'mm-dd-yyyy HH-MM'),'create_GT','NumberOfCapturedFrames','flash_no_flash','BW','mov1','mov2','mov3','mov4','ExposureSet')
end
%save('Zmap_static_fish_Hlight2','Z');
%save('nmap_static_fish_Hlight2','n');