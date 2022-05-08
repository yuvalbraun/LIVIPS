function [ ReconstructedLight1,FilteredDC ] = ReconstructModulatedLightFastRaw( mov,Base1,DEBUG )
%% Reconstruct Modulated Light from the sampled video
% Input : mov is the sampled video, Base1 is the cosine function with the
% correspond frequancy, DEBUG is for DEBUG mode
% Output : ReconstructedLight1 is the filtered video with the corresponding
% light, FilteredDC is the video with the background light
%created by Amir Kolaman, edited by Yuval Braun

[RowSize,ColSize,~,nFrames]=size(mov);
FilteredLight1=zeros(RowSize, ColSize, 1, 'double');
FilteredDC=FilteredLight1;

Base3d=zeros(1,1,nFrames); % create a 3d matrix of 1,1,number of frames
Base3d(1,1,:)=Base1;
Base1Matrix=zeros(RowSize,ColSize,1,nFrames);
Base1Matrix(1:RowSize,1:ColSize,1,:)=Base3d(ones(1,RowSize),ones(1,ColSize),:);




Mult=Base1Matrix.*double(mov);
FilteredLight1=sum(Mult,4)/nFrames;

FilteredDC=mean(mov,4);

ReconstructedFilter1DC=FilteredLight1.*2*0.55/0.45; 


ReconstructedLight1=FilteredLight1.*2+ReconstructedFilter1DC;

ReconstructedDCFinal=FilteredDC-ReconstructedFilter1DC;
end
