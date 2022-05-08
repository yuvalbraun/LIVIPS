function AnalyzeMovieSpectrum( mov,Row,Col,Avg,RolingShutter,FrameRate )
%% Analyze frequency of dominant signal
%% Created by Amir Kolaman
set(0,'DefaultFigureWindowStyle','docked')
nFrames=size(mov,4);
SampleVideoG=zeros(1,nFrames);
SampleVideoR=SampleVideoG;
SampleVideoB=SampleVideoG;

if Avg
    ImMean=mean(mean(mov,2),1);
    SampleVideoR(:)=ImMean(1,1,1,:);
    SampleVideoG(:)=ImMean(1,1,2,:);
    SampleVideoB(:)=ImMean(1,1,3,:);
else
    if RolingShutter
        ImMean=mean(mov,2);
        SampleVideoR(:)=ImMean(Row,1,1,:);
        SampleVideoG(:)=ImMean(Row,1,2,:);
        SampleVideoB(:)=ImMean(Row,1,3,:);
        
    else
        SampleVideoR(:)=mov(Row,Col,1,:);
        SampleVideoG(:)=mov(Row,Col,2,:);
        SampleVideoB(:)=mov(Row,Col,3,:);
    end
end

T = 1/FrameRate;                     % Sample time
NFFT = nFrames;
SampleVideoFFT = fft(SampleVideoG-mean(SampleVideoG),NFFT)/nFrames;

NFFTBy2=floor(NFFT/2);
% f = FrameRate/2*linspace(0,1,NFFTBy2+1);

df=FrameRate/NFFT;
f=0:df:FrameRate/2;

SampleVideoFFTRight=2*abs(SampleVideoFFT(1:NFFTBy2+1));

p = unwrap(angle(SampleVideoFFT));                  % Phase

[~,MaxLoc]=max(SampleVideoFFTRight);

    Location=MaxLoc(1);
Freq=f(Location);
Phase=p(Location);

StopTime = nFrames*T;             % seconds
t = (0:T:StopTime-T)';     % seconds
Base1 = cos(2*pi*Freq*t+Phase);


%% Plot single-sided amplitude spectrum.
figure%(100);
hold off
plot((1:size(SampleVideoG,2))/FrameRate,SampleVideoG,'g');
hold on
plot((1:size(SampleVideoR,2))/FrameRate,SampleVideoR,'r');
plot((1:size(SampleVideoB,2))/FrameRate,SampleVideoB,'b');
averageR=mean(SampleVideoR);
StandardDevR=std(SampleVideoR);
averageG=mean(SampleVideoG);
StandardDevG=std(SampleVideoG);
averageB=mean(SampleVideoB);
StandardDevB=std(SampleVideoB);
plot((1:length(Base1))/FrameRate,(0.5*Base1+0.5)*StandardDevR*2.5+averageR*0.95,'r.-')
plot((1:length(Base1))/FrameRate,(0.5*Base1+0.5)*StandardDevG*2.5+averageG*0.95,'g.-')
plot((1:length(Base1))/FrameRate,(0.5*Base1+0.5)*StandardDevB*2.5+averageB*0.95,'b.-')

figure;%(101);
plot(f,SampleVideoFFTRight)
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
end

