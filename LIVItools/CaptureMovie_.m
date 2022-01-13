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
%     stop(vid);
%     set(vid,'FramesPerTrigger',NumberOfSamples)
%     start(vid);
    % preview(vid);
    trigger(vid);
%     mov=double(getdata(vid))./256;
      mov=getdata(vid);

end
nFrames=size(mov,4);
vidHeight=size(mov,1);
vidWidth=size(mov,2);

% Transfer to the structre movie
% for k = 1 : nFrames
% %     mov(k) = im2double(capture(:,:,k));
%             mov(k).cdata = im2double(capture(:,:,:,k));
% end


end

