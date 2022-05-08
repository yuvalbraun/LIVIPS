%% This script perform the Light Invariant PS on parts of a video that has already been taken
% it performs the algorithem seperatly on each sub-video and evaluates the
% results compare to GT. It also plot the error as a function of the number
% of frames
range=398:2:398;
k=1;
currentDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currentDir,"scanner");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");
resultsDir=currentDir+"\results";
freq=[141.28,115.6,90.8];
freq_dist=zeros(size(range,2),size(freq,2));
total=zeros(size(range,2),1);
FPS=398;
y=[];
z=[];
 for number_of_frames= 398:2:398
    delta_f=FPS/number_of_frames;
    nearest_freq=round(freq/delta_f)*delta_f;
    error=(nearest_freq-freq);
    sincs=abs(sin(error*pi*(number_of_frames))./sin(error*pi));
    freq_dist(k,:)=100./sincs;
    total(k)=(mean(error))+(std(error));
    %% perform 3 filters to find 3 images
    f=figure(1);
    [Base,Freq,Location,Phase]  = FindFreqFromMovRaw( mov(:,:,:,1:number_of_frames),1,FPS,3 );
    [ FilteredLightTmp1,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(1,:),0 );
    [ FilteredLightTmp2,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(2,:),0 );
    [ FilteredLightTmp3,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(3,:),0 );
    MovMeanRaw=mean(double(mov(:,:,1,1:number_of_frames)*255),4);
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
    y(k)=avDegree; %save results in array
    
    
    %% repet with phase correction
    T=1/FPS;
    StopTime = number_of_frames*T;             % seconds
    t = (0:T:StopTime-T)';     % seconds
    % Fc1=1/round(20/f(MaxLoc));
    error=(Freq-freq);
    for i=1:3
        Base(i,:) = cos(2*pi*freq(i)*t+Phase(i)+error(i)*pi*(number_of_frames/FPS));
    end

    [ FilteredLightTmp1,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(1,:),0 );
    [ FilteredLightTmp2,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(2,:),0 );
    [ FilteredLightTmp3,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(3,:),0 );
    MovMeanRaw=mean(double(mov(:,:,1,1:number_of_frames)*255),4);
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
    z(k)=avDegree; % save the tesult in array 
    k=k+1;

    
    
    close all
 end
 figure
plot(range,total)
figure
plot(range,freq_dist)