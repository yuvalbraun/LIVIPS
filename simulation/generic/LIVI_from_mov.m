%% This script perform the Light Invariant PS on parts of a video that has already been taken
% it performs the algorithem seperatly on each sub-video and evaluates the
% results compare to GT. It also plot the error as a function of the number
% of frames
%% important: before running, a variable named 'mov' must be loaded in the workspace
range=400:2:400; % range of number of frames
k=1; 
%% set dir
currentDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currentDir,"simulation");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");
addpath(currentDir+"_lib");
resultsDir=currentDir+"\results";
%% set parameters
lower_freq=80;
upper_freq=130;
N=3; % set number of sources
freq= [upper_freq:-(upper_freq-lower_freq)/N:lower_freq]+0.1 ;   %round([upper_freq:-(upper_freq-lower_freq)/N:lower_freq]);
freq=freq(1:N);
total=zeros(size(range,2),1);
FPS=400; %set frame rate
correction=1; %% set 1 to use phase correction
%% perform LIPS seperately on each sub video and evaluate using GT. Performs twice : with and without phase correction
for number_of_frames= range

    delta_f=FPS/number_of_frames;
    nearest_freq=round(freq/delta_f)*delta_f;
    error=(nearest_freq-freq);
    sincs=abs(sin(error*pi*(number_of_frames/FPS))./sin(error*pi/FPS))/number_of_frames;
    sincs(isnan(sincs))=1;
    freq_dist(k,:)=abs(error); %%the distance from the closest discrete frequencies
    %% perform 3 filters to find 3 images
    f=figure(1);        
    [Base,Freq,Location,Phase]  = FindFreqFromMovRaw( mov(:,:,:,1:number_of_frames),1,FPS,N,freq );
    MovMeanRaw=mean(double(mov(:,:,1,1:number_of_frames)*255),4);

    for i=1:N
    [ image,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(i,:),0 );
        imwrite(mask.*image,imagesDir + "\image_0"+num2str(i)+".png");  
        imwrite(double(image/255),imagesDir + "\image_0"+num2str(i)+".tiff");
        save(imagesDir + "\image_0"+num2str(i),'image');
    
    end





    %%   perform photometric stereo algorithm
    demoPSBox;


    %% evaluate with GT
    degrees=calcDegreeError(flipud(n_GT),n);
    [H1,W1,D1]=size(degrees);
    figure
    him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
    set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
    shading flat;
    set(gca, 'ydir', 'reverse');
    title('angular error map');
    colorbar;   
    medianDegree=calcMedian(degrees);
    avDegree=calcSum(degrees);
    figure
    histogram(degrees);
    xlabel('angular error [degrees]');
    ylabel('number of points');
    title('angular error histogram');
    y(k)=avDegree;
    error=(Freq-freq); % distance from the closest discrete frequencies

    T=1/FPS;
    StopTime = number_of_frames*T;   % [seconds]
    t = (0:T:StopTime-T)';     % [seconds]
    
    for i=1:N
          Base(i,:) = cos(2*pi*freq(i)*t+Phase(i)+error(i)*pi*(number_of_frames/FPS)); %phase correction
    end

for i=1:N
    [ image,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:number_of_frames),Base(i,:),0 ); %reconstruct images
    imwrite(mask.*image,imagesDir + "\image_0"+num2str(i)+".png");  
    imwrite(double(image/255),imagesDir + "\image_0"+num2str(i)+".tiff");
    save(imagesDir + "\image_0"+num2str(i),'image');

end





    %%   perform photometric stereo algorithm
    demoPSBox;


    %% evaluate with GT
    n_GT=exrread(convertStringsToChars(currentDir+"\GT\"+'bunny_GT.exr')); 
    degrees=calcDegreeError(flipud(n_GT),n);
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
    z(k)=avDegree;
    Phasediff(k,:)=mod(Phase,2*pi)-mod(gtPhase,2*pi);
    Phasediffcorrect(k,:)=mod(Phase+error*pi*(number_of_frames/FPS),2*pi)-mod(gtPhase,2*pi);



    k=k+1;
    close all
end
%%plot graphs
 plot(range,y);
 hold on
 plot(range,z);
 figure
 plot(range,freq_dist)