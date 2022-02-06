 x=40:2:400;
 k=1;
currentDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currentDir,"simulation");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");
resultsDir=currentDir+"\results";
lower_freq=60;
upper_freq=185;
freq=round([upper_freq:-(upper_freq-lower_freq)/N:lower_freq]);
freq=freq(1:8);
total=zeros(size(x,2),1);
FPS=400;
 for number_of_frames= 40:2:400

    delta_f=FPS/number_of_frames;
    nearest_freq=round(freq/delta_f)*delta_f;
    error=(freq-nearest_freq);
    sincs=abs(sin(error*pi*(number_of_frames))./sin(error*pi));
    freq_dist(k,:)=abs(error);
%     %% perform 3 filters to find 3 images
%     f=figure(1);
%     [Base,Freq,Location]  = FindFreqFromMovRaw( mov(:,:,:,1:number_of_frames),1,FPS,8,freq );
%     MovMeanRaw=mean(double(mov(:,:,1,1:number_of_frames)*255),4);
% for i=1:N
% [ image,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(i,:),0 );
%     imwrite(image,imagesDir + "\image_0"+num2str(i)+".png");  
%     imwrite(double(image/255),imagesDir + "\image_0"+num2str(i)+".tiff");
%     save(imagesDir + "\image_0"+num2str(i),'image');
% 
% end
% 
% 
% 
% 
% 
%     %%   perform photometric stereo algorithm
%     demoPSBox;
% 
% 
%     %% evaluate with GT
%     n_GT=exrread(convertStringsToChars(currentDir+"\GT\"+'bunny_GT.exr')); 
%    % Z_GT=load(currentDir+"\GT_face").Z;
% 
%     degrees=calcDegreeError(flipud(n_GT),n);
%     [H1,W1,D1]=size(degrees);
%     figure
%     %imagesc(flipud(degrees'));
%     him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
%     set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
%     shading flat;
%     set(gca, 'ydir', 'reverse');
%     %title('angular error map');
%     colorbar;   
%     medianDegree=calcMedian(degrees);
%     avDegree=calcSum(degrees);
%     figure
%     histogram(degrees);
%     xlabel('angular error [degrees]');
%     ylabel('number of points');
%     title('angular error histogram');
%     y(k)=avDegree;
     k=k+1;
%     close all
 end
 plot(x,y)
 figure
 plot(x,freq_dist)