function [ mov ] = CaptureMovie( vid,NumberOfSamples,FramesToSkip )
%UNTITLED2 Summary of this function goes here
%   capture sequance of frames using the camera
% Input : vid is the videoinput object, NumberOfSamples is the number of
% the required frames.
%created by Amir Kolaman, edited by Yuval Braun
%% capture the movie
if FramesToSkip>1
    stop(vid);
    set(vid,'FrameGrabInterval',FramesToSkip);
    set(vid,'FramesPerTrigger',NumberOfSamples)
    start(vid);
    for ii=1:NumberOfSamples
        trigger(vid);
        capture(:,:,ii)=(getdata(vid));
    end
else
      trigger(vid);
      mov=getdata(vid);

end
nFrames=size(mov,4);
vidHeight=size(mov,1);
vidWidth=size(mov,2);


end

