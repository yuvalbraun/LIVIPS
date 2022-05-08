noPadding=load('xyzfrac_nopadding.mat').Phasediff;
corrected=load('xyzfrac_nopadding.mat').Phasediffcorrect;
N=load('xyzfrac_nopadding.mat').x;
padded=load('xyzfrac_padding800.mat').Phasediff;
paddedcorrect=load('xyzfrac_nopadding.mat').Phasediffcorrect;
newcorrected


for i=N
    if sum(mod(abs(corrected),2*pi) <=pi
        newcorrected(i)=sum(mod(abs(corrected),2*pi)
    else
        




end
plot(N,sum(min(abs(noPadding),2*pi-abs(noPadding)),2));
hold on
plot(N,sum(min(abs(corrected),2*pi-abs(corrected)),2));
plot(N,sum(min(abs(padded),2*pi-abs(padded)),2));
plot(N,sum(min(abs(paddedcorrect),2*pi-abs(paddedcorrect)),2));

