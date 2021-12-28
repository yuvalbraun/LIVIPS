function FilteredLightTmp=FilterMovie(movB,movG,movR)

% [Base,~,~]  = FindFreqFromMovRaw( movB(iirow,1,1,:),0,0,100 );
[Base,~,~]  = FindLineFreqFromMovRaw( movR,0,0,100 );
[ FilteredLightTmp(:,:,1),~] = ReconstructModulatedLightFastRawManyPhases( movR,Base,0 );

[Base,~,~]  = FindLineFreqFromMovRaw( movG,0,0,100 );
[ FilteredLightTmp(:,:,2),~] = ReconstructModulatedLightFastRawManyPhases( movG,Base,0 );

[Base,~,~]  = FindLineFreqFromMovRaw( movB,0,0,100 );
[ FilteredLightTmp(:,:,3),~] = ReconstructModulatedLightFastRawManyPhases( movB,Base,0 );
