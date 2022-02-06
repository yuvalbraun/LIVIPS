
x=100:1:100;
k=1;
currentDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currentDir,"scanner");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");
resultsDir=currentDir+"\results";

for number_of_frames=100:1:100


            %% take the average frame
            img1=mean(mov1(:,:,:,1:number_of_frames),4);
            img2=mean(mov2(:,:,:,1:number_of_frames),4);
            img3=mean(mov3(:,:,:,1:number_of_frames),4);
            img4=mean(mov4(:,:,:,1:number_of_frames),4);

            f=figure(1);
            %% substruct the no flash image


            if flash_no_flash==1
              no_flash=mean(no_flash_mov(:,:,:,1:number_of_frames),4);
              img_sub1=img1-no_flash;
              img_sub2=img2-no_flash; 
              img_sub3=img3-no_flash;  
            else
                img_sub1=img1;
                img_sub2=img2;
                img_sub3=img3;
            end
             %% perform demoasic for color images   
             FilteredLightDemosaic1=double(demosaic(uint8(img_sub1),'bggr'))./255;
             FilteredLightDemosaic2=double(demosaic(uint8(img_sub2),'bggr'))./255;
             FilteredLightDemosaic3=double(demosaic(uint8(img_sub3),'bggr'))./255;
             FilteredLightDemosaic4=double(demosaic(uint8(img4),'bggr'))./255;
               
             %% create new mask if needed
             I=zeros(size(FilteredLightDemosaic1,1),size(FilteredLightDemosaic1,2),size(FilteredLightDemosaic1,3),3);
             I(:,:,:,1)=FilteredLightDemosaic1.*BW;
             I(:,:,:,2)=FilteredLightDemosaic2.*BW;
             I(:,:,:,3)=FilteredLightDemosaic3.*BW;
             I4=FilteredLightDemosaic4.*BW; %% I4 is only for evaluation
             imwrite(I(:,:,:,1),imagesDir+'\image_01.png');    
             imwrite(I(:,:,:,2),imagesDir+'\image_02.png');    
             imwrite(I(:,:,:,3),imagesDir+'\image_03.png');
             imwrite(I4,imagesDir+'\forGT.png');
             for i=1:3
                 image=I(:,:,:,i);
                 save(imagesDir + "\image_0"+num2str(i),'image');
             end


            demoPSBox;

            %% evaluate with GT
            n_GT=load(currentDir+"\GT_face").n;
            Z_GT=load(currentDir+"\GT_face").Z;

            degrees=calcDegreeError(n_GT,n);
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
            y(k)=avDegree;
            k=k+1;
            close all
 end
 plot(x,y)

