function [ ReconstructedLight1,FilteredDC ] = ReconstructModulatedLightFastRawManyPhases( mov,Base1,DEBUG )
%% Reconstruct Modulated Light
[RowSize,ColSize,~,nFrames]=size(mov);
FilteredLight1=zeros(RowSize, ColSize, 1, 'double');
FilteredDC=FilteredLight1;

Base1Matrix=zeros(RowSize,ColSize,1,nFrames);

Base1Matrix(1:RowSize,1:ColSize,1,:)=Base1(:,ones(1,ColSize),:,:);



Mult=Base1Matrix.*mov;
FilteredLight1=sum(Mult,4)/nFrames;

FilteredDC=mean(mov,4);

ReconstructedFilter1DC=FilteredLight1.*2*0.55/0.45;


ReconstructedLight1=FilteredLight1.*2+ReconstructedFilter1DC;

ReconstructedDCFinal=FilteredDC-ReconstructedFilter1DC;
end
