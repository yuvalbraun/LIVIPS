%% simulate Light Invariant PS in dark or alight enviorment and evaluate the result with GT.
% created by Yuval Braun
%% set dir and path
currnetDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currnetDir,"simulation");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
resultsDir=currnetDir+"\results2";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate");
addpath('_lib\openexr-matlab-windows\x64');
addpath('_lib\struct2xml');
addpath(genpath(topDir+"PSBox-v0.3.1"));
objects_dir=currnetDir+"\objects\";
xmlDir = [currnetDir, '\'];
xmlName = 'simulation.xml';
% choose object: 1 for "bunny", 2 for "buddha", 3 for "Caligula", 4 for
% "face"
object_number=3; 
objects_names= ["bunny","buddha","Caligula","face"];
scales=[10,9,0.004,0.1]; %% object scales for sutiable sizes
GT_dir=currnetDir+"\GT\";
GT_name=objects_names(object_number)+'_GT.exr';
GT_file= convertStringsToChars(GT_dir+GT_name);
env_dir=currnetDir+"\env\";

%% choose parameters for simulation
%% system parameters
% set number of sources. minimum 3, maximum 9.
N=8;
% set the distance of the sources from the camera 
% (the sources are placed on a circle with radius R around the camera).
R=10;
% set the irradiance per image. more frames
irradiance=0.5;
lower_freq=60;
upper_freq=185;

%% camera parameters
% set the number of frames 
nFrames=45;
%set image dimentions
H=512;
W=512;
% set the STD of a gaussian noise (sensor noise)
noise_level=0.008;
%set camera frame rate [frames per seconds]
FPS=400;
T=1/FPS;
camera_locs= [-0.2 1 50; 0 1.3 50; 0 0.9 50; 0 0 50]; % camera location is 
camera_loc = camera_locs(object_number,:);

%% enviorment parameters
% set ambient_light to 1 to add ambient light to the simulation
ambient_light=0;
%set 1 for flickering ambient light
flicker=0;
% flicker duty cycle
dutycycle=50;
% set flicker frequency [Hz]
flicker_frequency=10;
%set to 1 for pseudo random sequence ambient light
randomsequence=0;
% pseudo random sequence intervals [seconds]
pn_interval=0.1;
%generate pseudo random sequence
pnSequence = comm.PNSequence('Polynomial',[9 5 0],'InitialConditions',[0,0,0,0,0,0,0,0,1],'SamplesPerFrame',1/pn_interval);
pnSequence(); %% to skip the first 10 items
%set 1 to use an extra moving source as ambient light
moving_source=0;
%set moving source distance from the camera (the source is moving in a circular
%path around the camera)
extra_source_radius=20;
%set angular displacement of the movig source
extra_source_angular_motion=pi;
%set moving source irradiance
extra_source_irradiance=0.5;
%initial angular location
teta=0;
delta_teta=extra_source_angular_motion/(nFrames-1);
env_names=["pisa_diffuse","pisa","glacier_diffuse","glacier"];
% choose enviorment map: 1 for "pisa_diffuse", 2 for "pisa", 3 for
% "glacier_diffuse", 4 for "glacier"
env_number=3;
env_name=env_names(env_number)+'.hdr';
env=convertStringsToChars(env_dir+env_name);

%% mitsuba settings
% set the path to your Mitsuba renderer
mitsubaDir = 'C:\mitsuba-win64\';
% set the number of samples taken per frame by mitsuba
samples_per_frame=512;
% set to 1 only when "servers.txt" exsists in mitsuba path
servers=0; 
if servers==1
    serversString=['-s',mitsubaDir, '\servers.txt',' ',];
else
    serversString='';
end

object_name=objects_names(object_number)+'.obj';
object= convertStringsToChars(objects_dir+object_name);

mov=[];


%% meshlab coordinate to mitsuba coordinate
T_vec =[0 ,0, 0,1];
rotY180 = [
-1 0 0 0;
0 1 0 0;
0 0 -1 0;
0 0 0 1
];

M = eye(4);
M(:,4) = T_vec;
world2cam =  M;
cam2world = inv(world2cam);

mitsubaViewMatrix = cam2world * rotY180;

%% use simulation.xml as skeleton
xml = xml2struct('simulation.xml');
camVec = mitsubaViewMatrix';
%xml.scene.sensor.transform.matrix.Attributes.value = num2str(camVec(:)');
%% set resolution
xml.scene.sensor.film.integer{1, 1}.Attributes.value=H;
xml.scene.sensor.film.integer{1, 2}.Attributes.value=W;

%% set number of samples per frame
xml.scene.sensor.sampler.integer.Attributes.value = samples_per_frame;

%% camrea location
xml.scene.sensor.transform.lookat.Attributes.origin = char(string(camera_loc(1))+", "+ string(camera_loc(2))+", " +string(camera_loc(3)));
xml.scene.sensor.transform.lookat.Attributes.target = char(string(camera_loc(1))+", "+ string(camera_loc(2))+", " +string(camera_loc(3)-1));

camera_locations_str = split(xml.scene.sensor.transform.lookat.Attributes.origin,',');
x=str2num(camera_locations_str{1});
y=str2num(camera_locations_str{2});
z=-str2num(camera_locations_str{3});
%% sources locations
points = createCirclePoints(N,R,x,y);
sources_location=zeros(N,3);
directions=sources_location';
for i=1:N
    sources_location(i,:)=[points{i}(1),points{i}(2),-z];
    directions(:,i)=(sources_location(i,:)-[x,y,0])/norm(sources_location(i,:)-[x,y,0]);
end

%% create sources
if ambient_light==1
    sources_cell =cell(1,N+1);
else
    sources_cell =cell(1,N);
end
for i=1:N   
    sources_cell{1,i} = xml.scene.emitter{1,1};
    sources_cell{1,i}.Attributes.type = 'directional';
    sources_cell{1,i}.spectrum.Attributes.name = 'irradiance';
    sources_cell{1,i}.spectrum.Attributes.value = num2str(irradiance);
    sources_cell{1,i}.vector.Attributes.x = num2str(-directions(1,i));
    sources_cell{1,i}.vector.Attributes.y = num2str(-directions(2,i));
    sources_cell{1,i}.vector.Attributes.z = num2str(-directions(3,i));
    sources_cell{1,i}.float.Attributes.name = 'scale';
    sources_cell{1,i}.float.Attributes.value = '1';%num2str(normrnd(1,0.1));
end
%% create enviorment light
if ambient_light==1
    if moving_source==0 %% enviorment map
        sources_cell{1,N+1}.Attributes.type = 'envmap';
        sources_cell{1,N+1}.string.Attributes.name = 'filename';
        sources_cell{1,N+1}.string.Attributes.value = env;
        sources_cell{1,N+1}.float.Attributes.name = 'scale';
        sources_cell{1,N+1}.float.Attributes.value = '0'; %% zero for mask
    
    else %%% moving source
        moving_source_loc= [x+extra_source_radius*cos(teta),y+extra_source_radius*sin(teta),50];
        moving_source_direction= [x,y,0]-moving_source_loc;
        sources_cell{1,N+1} = xml.scene.emitter{1,1};
        sources_cell{1,N+1}.Attributes.type = 'directional';
        sources_cell{1,N+1}.spectrum.Attributes.name = 'irradiance';
        sources_cell{1,N+1}.spectrum.Attributes.value = num2str(extra_source_irradiance);
        sources_cell{1,N+1}.vector.Attributes.x = num2str(moving_source_direction(1));
        sources_cell{1,N+1}.vector.Attributes.y = num2str(moving_source_direction(2));
        sources_cell{1,N+1}.vector.Attributes.z = num2str(moving_source_direction(3));
        sources_cell{1,N+1}.float.Attributes.name = 'scale';
        sources_cell{1,N+1}.float.Attributes.value = '0';%% zero for mask
    end

end
xml.scene.emitter=sources_cell;



%% create object
xml.scene.shape.string.Attributes.value=object;
xml.scene.shape.transform.scale.Attributes.value=scales(object_number);
%% crate mask
struct2xml(xml, xmlName);
system([mitsubaDir, 'mitsuba', ' ',serversString, [xmlDir, xmlName],' -q']);
mask=exrread('simulation.exr');
mask=rgb2gray(mask);
mask=mask~=0;
if ambient_light==1
    xml.scene.emitter{1,N+1}.float.Attributes.name = 'scale';
    xml.scene.emitter{1,N+1}.float.Attributes.value ='1';% num2str(normrnd(1,0.1));
end
%% modulation
pre_freq=round([upper_freq:-(upper_freq-lower_freq)/N:lower_freq]);
StopTime = nFrames*T;    % [seconds]
t = (0:T:StopTime-T)';  % [seconds]
Phase=2*pi*rand([1,N]); %random phases
Base=zeros([N,nFrames]); 
for i=1:N
    Base(i,:) = 1/2+(1/2)*cos(2*pi*pre_freq(i)*t+Phase(i));
end
%% ambient light signal
flicker_phase=2*pi*rand(); %random phase of the ambient flicker
if flicker==1
    env_signal= 1/2+1/2*square(2*pi*flicker_frequency*t+flicker_phase,dutycycle);
elseif randomsequence==1
    env_signal=repelem(pnSequence(),FPS*pn_interval);
else
    env_signal=ones(nFrames,1);
end
%% take N framew with the modulated sources 
k=1; %%index for the enviorment signal
 for i=1:nFrames
    for j=1:N
        xml.scene.emitter{1,j}.spectrum.Attributes.name = 'irradiance';
        xml.scene.emitter{1,j}.spectrum.Attributes.value = num2str(irradiance*Base(j,i));
    end
    if ambient_light==1
                if moving_source==0
                    xml.scene.emitter{1,N+1}.float.Attributes.name = 'scale';
                    xml.scene.emitter{1,N+1}.float.Attributes.value =num2str(env_signal(k));% num2str(normrnd(1,0.1));
                    k=k+1;
                else %% for moving source
                    moving_source_loc= [x+extra_source_radius*cos(teta),y+extra_source_radius*sin(teta),50];
                    moving_source_direction= [x,y,0]-moving_source_loc;
                    xml.scene.emitter{1,N+1}.vector.Attributes.x = num2str(moving_source_direction(1));
                    xml.scene.emitter{1,N+1}.vector.Attributes.y = num2str(moving_source_direction(2));
                    xml.scene.emitter{1,N+1}.vector.Attributes.z = num2str(moving_source_direction(3));
                    teta=teta+delta_teta;
                end
    end
    struct2xml(xml, xmlName);
    system([mitsubaDir, 'mitsuba', ' ',serversString, [xmlDir, xmlName],' -q']);
    image=exrread('simulation.exr');
    image=rgb2gray(image);
    image=imnoise(image,'gaussian',0,noise_level^2); %add sensor noise
    image=mask.*image; %mask without background
    mov(:,:,:,i)=uint8(image*255); % 8 bit representation
    fprintf('finished: %d %%\n',uint8(i/nFrames*100)); % for display
end
dlmwrite(topDir + "PSBox-v0.3.1\data\light_directions.txt", directions, ...
        'delimiter', ' ', 'precision', '%20.16f');
%% perform Livi
[Base,Freq,Location]  = FindFreqFromMovRaw( mov,1,FPS,N,pre_freq);
MovMeanRaw=mean(double(mov(:,:,1,:)*255),4);
for i=1:N
[ image,~] = ReconstructModulatedLightFastRaw( mov,Base(i,:),0 );
    imwrite(image,imagesDir + "\image_0"+num2str(i)+".png");  
    imwrite(double(image/255),imagesDir + "\image_0"+num2str(i)+".tiff");
    save(imagesDir + "\image_0"+num2str(i),'image');

end
%% perform PS
demoPSBox;
%% evaluate with GT
GT=exrread(GT_file);
degrees=calcDegreeError(flipud(GT),n);
[H1,W1,D1]=size(degrees);
figure
him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
shading flat;
set(gca, 'ydir', 'reverse');
title('angular error map');
colorbar;   
medianDegree=calcMedian(degrees);
avDegree=calcSum(degrees);
figure
histogram(degrees);
xlabel('angular error [degrees]');
ylabel('number of points');
title('angular error histogram');
%% save results to results dir
if flicker==1
    save(resultsDir+"\LIVI "+datestr(now,'mm-dd-yyyy HH-MM'),'ambient_light','avDegree','degrees','directions','dutycycle','env_name','env_signal','flicker','flicker_frequency','flicker_phase','FPS','Freq','H','irradiance','medianDegree','mov','MovMeanRaw','n','N','nFrames','noise_level','object_name','p','Phase','q','R','rho','samples_per_frame','W','Z')
else
    save(resultsDir+"\LIVI "+datestr(now,'mm-dd-yyyy HH-MM'),'ambient_light','avDegree','degrees','directions','dutycycle','env_name','env_signal','extra_source_angular_motion','extra_source_irradiance','extra_source_radius','flicker','flicker_phase','FPS','Freq','H','irradiance','medianDegree','mov','moving_source','MovMeanRaw','n','N','nFrames','noise_level','object_name','p','Phase','pn_interval','q','R','rho','randomsequence','samples_per_frame','W','Z')
end
