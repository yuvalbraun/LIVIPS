function [ ReconstructedLight1,FilteredDC ] = ReconstructModulatedLightFastRaw2( mov,Base1,DEBUG )
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


% Mult=gpuArray(Base1Matrix).*gpuArray(mov);
% FilteredLight1=gather(sum(Mult,4)/nFrames);


Mult=Base1Matrix.*mov;
FilteredLight1=sum(Mult,4)/nFrames;

FilteredDC=mean(mov,4);

ReconstructedFilter1DC=FilteredLight1.*2*0.55/0.45;


ReconstructedLight1=(FilteredLight1.*2+ReconstructedFilter1DC)/2;

ReconstructedDCFinal=FilteredDC-ReconstructedFilter1DC;
% if DEBUG==6
% figure(3);subplot(1,2,1);
% tst(1:nFrames)=BlueMatrix(130,160,:);
% plot(tst)
% hold on
% plot(Base1*FilteredLight1(130,160,1).*2,'m')
% tst(1:nFrames)=RedMatrix(130,160,:);
% plot(tst,'r')
% tst(1:nFrames)=GreenMatrix(130,160,:);
% plot(tst,'g')
% title('upper part');
% subplot(1,2,2);
% tst(1:nFrames)=BlueMatrix(180,160,:);
% plot(tst)
% hold on
% plot(Base1.*FilteredLight1(130,160,1).*2,'m')
% tst(1:nFrames)=RedMatrix(180,160,:);
% plot(tst,'r')
% tst(1:nFrames)=GreenMatrix(180,160,:);
% plot(tst,'g')
% title('Lower part');
% 
% FilteredLight1(180,160,:)
end
