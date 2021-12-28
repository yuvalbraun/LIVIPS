function [ Table,FrequencyDelta ] = FindGoodLightFrequencies(CameraFPS, NumberOfCapturedFrames )
% this function checks if the NumberOfCapturedFrames is a precise multiplications
% to get the precise frequency of reconstruction
% FrequencyDelta=(CameraFPS)/(NumberOfCapturedFrames);
% MinFreqOfLight=1;
% Kstart=floor(MinFreqOfLight/FrequencyDelta); % multplier of the frequency
% PossibleFreq=(Kstart:Kstart+20)*FrequencyDelta;
%PossibleFreqRound=PossibleFreq(PossibleFreq==floor(PossibleFreq));
% K=floor(PossibleFreqRound/(CameraFPS/2)); % multplier of the frequency
% FrequencyWithoutAliasing=PossibleFreqRound-CameraFPS*K/2;
% MeasuredFrequencyWithoutAliasing=round(round(FrequencyWithoutAliasing/FrequencyDelta)*FrequencyDelta); % frequency measured by the camera 
% Table(1,:)=PossibleFreqRound;
% Table(2,:)=MeasuredFrequencyWithoutAliasing;

FrequencyDelta=(CameraFPS)/(NumberOfCapturedFrames);
PossibleFreq=(0:50)*FrequencyDelta;
Table(1,:)=PossibleFreq;
Table(2,:)=rem(PossibleFreq,(CameraFPS/2));

end

