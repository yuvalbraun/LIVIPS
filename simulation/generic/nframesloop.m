nlist = {50,100,150,200,250,300,350,400,450,500,550,600,650,700,750};
resav=zeros(length(nlist),1);
resmed=zeros(length(nlist),1);
for k=1:length(nlist)
    [Base,Freq,Location]  = FindFreqFromMovRaw(mov(:,:,:,1:nlist{k}),1,FPS,N,pre_freq);
    MovMeanRaw=mean(double(mov(:,:,1,:)*255),4);
    for i=1:N
    [ image,~] = ReconstructModulatedLightFastRaw( mov(:,:,:,1:nlist{k}),Base(i,:),0 );
        imwrite(image,imagesDir + "\image_0"+num2str(i)+".png");  
        imwrite(double(image/255),imagesDir + "\image_0"+num2str(i)+".tiff");
        save(imagesDir + "\image_0"+num2str(i),'image');
    
    end
    demoPSBox;
    
    GT=exrread(GT_file);
    degrees=calcDegreeError(flipud(GT),n);
    [H1,W1,D1]=size(degrees);
    figure
    %imagesc(flipud(degrees'));
    him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
    set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
    shading flat;
    set(gca, 'ydir', 'reverse');
    %title('angular error map');
    colorbar;   
    medianDegree=calcMedian(degrees);
    avDegree=calcSum(degrees);
    figure
    histogram(degrees);
    xlabel('angular error [degrees]');
    ylabel('number of points');
    title('angular error histogram');
    resav(k)= avDegree;
    resmed=medianDegree;
    if flicker==1
        save(resultsDir+"\LIVI "+datestr(now,'mm-dd-yyyy HH-MM'),'ambient_light','avDegree','degrees','directions','dutycycle','env_name','env_signal','flicker','flicker_frequency','flicker_phase','FPS','Freq','H','irradiance','medianDegree','MovMeanRaw','n','N','nFrames','noise_level','object_name','p','q','R','rho','samples_per_frame','W','Z')
    else
        save(resultsDir+"\LIVI "+datestr(now,'mm-dd-yyyy HH-MM'),'ambient_light','avDegree','degrees','directions','dutycycle','env_name','env_signal','extra_source_angular_motion','extra_source_irradiance','extra_source_radius','flicker','flicker_phase','FPS','Freq','H','irradiance','medianDegree','moving_source','MovMeanRaw','n','N','nFrames','noise_level','object_name','p','pn_interval','q','R','rho','randomsequence','samples_per_frame','W','Z')
    end
end
plot(cell2mat(nlist),resav)
