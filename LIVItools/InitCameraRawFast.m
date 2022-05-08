function [ capture,vid,ExposureSet,GainSet ] = InitCameraRawFast(NumberOfcapturedFrames)
% Capture
% imaqtool
%% working with matrix vision bluefox3 
%created by Amir Kolaman
delete(imaqfind)

vid = videoinput('gentl', 1, 'BayerRG8');
GainSet=0;
ExposureSet=1000;
stop(vid);
src = getselectedsource(vid);
vid.ROIPosition = [648 368 256  256];
% vid.ROIPosition = [648 368 640  480];
triggerconfig(vid,'manual');
set(vid,'TriggerRepeat',inf);
set(vid,'FramesPerTrigger',NumberOfcapturedFrames)
% set(src,'ExposureMode','timed');
% set(src,'BalanceWhiteAuto','off');
% set(src,'AnalogAllGainAuto','off');
% set(src,'DigitalAllGain',GainSet);
% set(src,'ExposureTime',ExposureSet);
% set(vid,'FramesPerTrigger',1)
set(vid,'Timeout',50);
vid.ReturnedColorspace = 'grayscale';
src.ExposureTime = ExposureSet;
src.Gain = GainSet;
% src.AcquisitionFrameRate = 398;
start(vid);
% trigger(vid);
% imaqmem(1000000)
% capture=(getdata(vid));
capture=0;

% MaxExposure=3;
% Upper=0.00015;
% Lower=0.001;
% delete(imaqfind)
% % point grey
% InitialExposureSet=1;
% RealExposure=2^(InitialExposureSet+1.0444);
% ExposureSet=floor(log2(RealExposure)-1);
% InitialGainSet=000;
% RealGain=10^(InitialGainSet/1000/20);
% GainSet=int32(20*log10(RealGain)*1000);
% % vid=videoinput('winvideo',2, 'RGB24_1024x768');
% % vid=videoinput('winvideo',2, 'RGB24_800x600');
% vid=videoinput('winvideo',2, 'RGB32_640x480');
% % vid=videoinput('winvideo',2, 'RGB24_320x240');
% % vid=videoinput('winvideo',2, 'RW08_1024X768');
% % vid = videoinput('pointgrey', 1, 'F7_BayerRG16_752x480_Mode0');
% 
% set(vid,'ReturnedColorSpace','rgb');
% stop(vid);
% src = getselectedsource(vid);
% set(src,'ExposureMode','manual');
% set(src,'GainMode','manual');
% set(src,'VerticalFlip','off');
% set(src,'Gain',GainSet)
% set(src,'Exposure',ExposureSet);
% triggerconfig(vid,'manual')
% set(vid,'TriggerRepeat',inf)
% set(vid,'FramesPerTrigger',1)
% 
% % German camera
% % vid=videoinput('gentl',1, 'BayerGR8');
% % set(vid,'ReturnedColorSpace','rgb');
% % src = getselectedsource(vid);
% % set(src,'ExposureTime',2000);
% % set(src,'AcquisitionFrameRate',60);
% % set(vid,'FramesPerTrigger',100)
% % triggerconfig(vid,'manual')
% %% set exposure and gain such that burned pixel are between 2% and 1% of the image
% start(vid);
% set(0,'DefaultFigureWindowStyle','default')
% preview(vid);
% set(0,'DefaultFigureWindowStyle','docked')
% trigger(vid);
% capture=double(getdata(vid))/256;
% % capture=MakeWB(double(demosaic(getdata(vid),'rggb'))/2^16);
% % capture=double(getdata(vid))/2^16;
% % figure
% % imagesc(MakeWB(double(demosaic(uint16(capture*2^16),'rggb'))/2^16))
% 
% stop(vid);
% GainSet=0;
% ExposureSet=1;
%     set(src,'Gain',GainSet)
%     set(src,'Exposure',ExposureSet);
%     start(vid);
% end