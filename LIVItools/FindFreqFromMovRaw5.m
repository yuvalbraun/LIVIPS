%% Analyze frequency of 3 dominants signal
% Input : mov is a sequance of N images, PresetLocation is currently
% not used, DEBUG is 1 for debud mode, FrameRate is frames per second
% Output : Base is 3 vectors contain 3 cosine functions values, 
%created by Amir Kolaman, edited by Yuval Braun
function [Base,Freq,Location]  = FindFreqFromMovRaw5( mov,PresetLocation,DEBUG,FrameRate )

set(0,'DefaultFigureWindowStyle','docked')
nFrames=size(mov,4);
ImMean=mean(mean(mov,2),1);
SampleVideo=zeros(1,nFrames);
SampleVideoR=SampleVideo;
SampleVideoB=SampleVideo;
SampleVideo(:)=ImMean(1,1,1,:);
T = 1/FrameRate;                     % Sample time
NFFT = nFrames;
SampleVideoFFT = fft(SampleVideo-mean(SampleVideo),NFFT)/nFrames;
f = FrameRate/2*linspace(0,1,NFFT/2+1);
SampleVideoFFTRight=2*abs(SampleVideoFFT(1:NFFT/2+1));
p = unwrap(angle(SampleVideoFFT));                  % Phase
[pks,locs]= findpeaks(SampleVideoFFTRight);
[B,I] = maxk(pks,5);
Location=locs(I);
Freq=f(Location);
Phase=p(Location);
[B,I1] = maxk(Freq,5);
Freq=Freq(I1);
Phase=Phase(I1);
StopTime = nFrames*T;             % seconds
t = (0:T:StopTime-T)';     % seconds
% Fc1=1/round(20/f(MaxLoc));
Base(1,:) = cos(2*pi*Freq(1)*t+Phase(1));
Base(2,:) = cos(2*pi*Freq(2)*t+Phase(2));
Base(3,:) = cos(2*pi*Freq(3)*t+Phase(3));
Base(4,:) = cos(2*pi*Freq(4)*t+Phase(4));
Base(5,:) = cos(2*pi*Freq(5)*t+Phase(5));

% Plot single-sided amplitude spectrum.
if DEBUG==1
   % figure;%(100);
  %  plot((1:size(SampleVideo,2))/FrameRate,SampleVideo,'g');
  %  hold on
%     plot((1:size(SampleVideoR,2))/FrameRate,SampleVideoR,'r');
%     plot((1:size(SampleVideoB,2))/FrameRate,SampleVideoB,'b');
  %  average=mean(SampleVideo);
  %  StandardDev=std(SampleVideo);
 %   plot((1:length(Base(1))/FrameRate,Base1*StandardDev+average,'m')
   % legend('green','base');
    figure;%(101);
    plot(f,SampleVideoFFTRight)
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
end
end

