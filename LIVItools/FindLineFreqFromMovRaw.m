function [Base1,Freq,Location]  = FindLineFreqFromMovRaw( mov,PresetLocation,DEBUG,FrameRate )
%% Analyze frequency of dominant signal
set(0,'DefaultFigureWindowStyle','docked')
SampleVideoRow=squeeze((mean(mov,2)));
nFrames=size(mov,4);

T = 1/FrameRate;                     % Sample time
NFFT = nFrames;
SampleVideoFFT = fft(SampleVideoRow-mean(SampleVideoRow,2),NFFT,2)/nFrames;
% MeanRow=squeeze(mean(mov,4));
% MeanMatrix=MeanRow(:,:,ones(1,15));
% VideoFFT=fft(squeeze(mov)-MeanMatrix,NFFT,3)/nFrames;


f = FrameRate/2*linspace(0,1,NFFT/2+1);

SampleVideoFFTRight=2*abs(SampleVideoFFT(:,1:NFFT/2+1));
% VideoFFTRight=2*abs(squeeze(VideoFFT(:,:,1:NFFT/2+1)));

p = unwrap(angle(SampleVideoFFT));                  % Phase

%
% figure
% plot(f,p(1:NFFT/2+1))
% xlabel 'Frequency (arb.)'
% ylabel 'Phase (rad)'
% [B,I]=sort(SampleVideoFFTRight,'descend');
[~,MaxLoc]=max(SampleVideoFFTRight,[],2);
if PresetLocation==0;
    Location=MaxLoc(1);
else
    Location= PresetLocation;
end
Freq=ones(size(p,1),1,size(p,2))*f(Location);
Phase=p(:,Location);

StopTime = nFrames*T;             % seconds
t = (0:T:StopTime-T); 
tMat=zeros(size(p,1),1,size(t,2));
tMat(:,:,:)=t(ones(size(p,1),1),:);
% seconds
% Fc1=1/round(20/f(MaxLoc));
Base1 = cos(2*pi*Freq.*tMat+Phase);
% Base1_2= cos(2*pi*f(MaxLoc+2)*t+p(MaxLoc+2));
% Base1_3= cos(2*pi*f(MaxLoc+1)*t+p(MaxLoc+1));


% Plot single-sided amplitude spectrum.
if DEBUG==1
    figure;%(100);
    plot((1:size(SampleVideo,2))/FrameRate,SampleVideo,'g');
    hold on
%     plot((1:size(SampleVideoR,2))/FrameRate,SampleVideoR,'r');
%     plot((1:size(SampleVideoB,2))/FrameRate,SampleVideoB,'b');
    average=mean(SampleVideo);
    StandardDev=std(SampleVideo);
    plot((1:length(Base1))/FrameRate,Base1*StandardDev+average,'m')
    legend('green','base');
    figure;%(101);
    plot(f,SampleVideoFFTRight)
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
end
end

