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


flash_no_flash=0;
saveBW=1;
if saveBW==0
    BW = load('MASK').BW;
end
    
NumberOfCapturedFrames=1;%Number of frames to capture with the camera
CurrentDir='D:\RawVideos\';
NewMovies='.\VideoResults\';
ImageResults='.\ImageResults\';
topDir = fullfile(fileparts(mfilename('fullpath')), 'data');
s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 115200);
fopen(s);
pause(1);
[capture,vid,ExposureSet,GainSet]=InitCameraRaw_(NumberOfCapturedFrames);
if flash_no_flash ==1
    trigger(vid);
    no_flash = getdata(vid);
    no_flash=mean(no_flash,4);
end
%vid.ReturnedColorSpace ='rgb';
fprintf(s,'%s',char(64+56));
pause(1);
trigger(vid);
mov1 = getdata(vid);
pause(0.1);
fprintf(s,'%s',char(64));
pause(1);
fprintf(s,'%s',char(128+56));
pause(1);
trigger(vid);
mov2 = getdata(vid);
pause(0.1);
fprintf(s,'%s',char(128));
fprintf(s,'%s',char(128));
pause(0.8);
fprintf(s,'%s',char(192+56));
pause(1);
trigger(vid);
mov3 = getdata(vid);
fprintf(s,'%s',char(128+56));
pause(1);
fprintf(s,'%s',char(64+56));
pause(1);
trigger(vid);
mov4 = getdata(vid); %%all lights on, just for segmentation
pause(1);
fprintf(s,'%s',char(128));
pause(1);
fprintf(s,'%s',char(64));
pause(1);
fprintf(s,'%s',char(192));
pause(0.3);



fclose(s);
img1=mean(mov1,4);
img2=mean(mov2,4);
img3=mean(mov3,4);
img4=mean(mov4,4);

%% perform a cyclic reconstruction and measure noise
f=figure(1);
CurrentDir='D:\RawVideos\';
NewMovies='.\VideoResults\';
ImageResults='.\ImageResults\';
if flash_no_flash==1
  img_sub1=img1-no_flash;
  img_sub2=img2-no_flash; 
  img_sub3=img3-no_flash;    
else
    img_sub1=img1;
    img_sub2=img2;
    img_sub3=img3;
end
    
 %[I1,I2,I3]=removeGreenBackgroundStatic(img1,img2,img3);
 FilteredLightDemosaic1=uint8((double(demosaic(uint8(img_sub1),'bggr'))./255)*255);
 FilteredLightDemosaic2=uint8((double(demosaic(uint8(img_sub2),'bggr'))./255)*255);
 FilteredLightDemosaic3=uint8((double(demosaic(uint8(img_sub3),'bggr'))./255)*255);
 FilteredLightDemosaic4=uint8((double(demosaic(uint8(img4),'bggr'))./255)*255);

 if saveBW==1
    [BW,maskedImage] = segmentStaticImage(FilteredLightDemosaic4);
    imwrite(maskedImage,'for_GT.png');
    save('MASK','BW');
 end
 I1=FilteredLightDemosaic1.*uint8(BW);
 I2=FilteredLightDemosaic2.*uint8(BW);
 I3=FilteredLightDemosaic3.*uint8(BW);
 I4=FilteredLightDemosaic4.*uint8(BW);

 imwrite(I1,'C:\Users\yuval\Documents\meitar\3Dlivi\PSBox-v0.3.1\data\Objects\image_01.png');    
 imwrite(I2,'C:\Users\yuval\Documents\meitar\3Dlivi\PSBox-v0.3.1\data\Objects\image_02.png');    
 imwrite(I3,'C:\Users\yuval\Documents\meitar\3Dlivi\PSBox-v0.3.1\data\Objects\image_03.png');   
 imwrite(I4,'C:\Users\yuval\Documents\meitar\3Dlivi\PSBox-v0.3.1\data\Objects\forGT.png');

demoPSBox;

save('Zmap_static_fish_Hlight2','Z');
save('nmap_static_fish_Hlight2','n');