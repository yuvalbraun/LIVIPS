close all;
clear;
clc;
%% define parameters
ambient_light=0;
N=8;
R=10;
H=512;
W=512;
nFrames=398;
FPS=398;
T=1/FPS;
lower_freq=70;
upper_freq=180;
intensity=2500;

addpath('_lib\openexr-matlab-windows\x64');
addpath('_lib\struct2xml');
objects_dir=pwd+"\objects\";
objects_names= ["bunny","face"];
object_number=1;
object_name=objects_names(object_number)+'.obj';
object= convertStringsToChars(objects_dir+object_name);

GT_dir=pwd+"\GT\";
GT_name=objects_names(object_number)+'_GT.exr';
GT_file= convertStringsToChars(GT_dir+GT_name);

env_dir=pwd+"\env\";
env_names=["pisa_diffuse","pisa","glacier_diffuse","glacier"];
env_number=1;
env_name=env_names(env_number)+'.hdr';
env=convertStringsToChars(env_dir+env_name);
% set the dir. to your Mitsuba renderer
mitsubaDir = 'C:\mitsuba-win64\';
xmlDir = [pwd, '\'];
xmlName = 'simulation.xml';



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


%% sources
xml = xml2struct(pwd+"\"+xmlName);
camVec = mitsubaViewMatrix';
%% set resolution
xml.scene.sensor.film.integer{1, 1}.Attributes.value=H;
xml.scene.sensor.film.integer{1, 2}.Attributes.value=W; 
%xml.scene.sensor.transform.matrix.Attributes.value = num2str(camVec(:)');
%% camrea location
camera_locations_str = split(xml.scene.sensor.transform.lookat.Attributes.origin,',');
x=str2num(camera_locations_str{1});
y=str2num(camera_locations_str{2});
z=-str2num(camera_locations_str{3});
points = createCirclePoints(N,R,x,y);
sources_location=zeros(N,3);
directions=sources_location';
for i=1:N
    sources_location(i,:)=[points{i}(1),points{i}(2),-z];
    directions(:,i)=(sources_location(i,:)-[x,y,0])/norm(sources_location(i,:));
end
%% crate sources
if ambient_light==1
    sources_cell =cell(1,N+1);
else
    sources_cell =cell(1,N);
end
%create sources
for i=1:N   
    sources_cell{1,i} = xml.scene.emitter{1,1};
    sources_cell{1,i}.Attributes.type = 'point';
    sources_cell{1,i}.spectrum.Attributes.name = 'intensity';
    sources_cell{1,i}.spectrum.Attributes.value = num2str(intensity);
    sources_cell{1,i}.point.Attributes.x = num2str(sources_location(i,1));
    sources_cell{1,i}.point.Attributes.y = num2str(sources_location(i,2));
    sources_cell{1,i}.point.Attributes.z = num2str(sources_location(i,3));
    sources_cell{1,i}.float.Attributes.name = 'scale';
    sources_cell{1,i}.float.Attributes.value = '1';%num2str(normrnd(1,0.1));
end
%create enviorment light
if ambient_light==1
    sources_cell{1,N+1}.Attributes.type = 'envmap';
    sources_cell{1,N+1}.string.Attributes.name = 'filename';
    sources_cell{1,N+1}.string.Attributes.value = env;
    sources_cell{1,N+1}.float.Attributes.name = 'scale';
    sources_cell{1,N+1}.float.Attributes.value = '0';
end
xml.scene.emitter=sources_cell;
%% create object
xml.scene.shape.string.Attributes.value=object;
%% crate mask
struct2xml(xml, xmlName);
system([mitsubaDir, 'mitsuba', ' ','-s',mitsubaDir, '\servers.txt',' ', [xmlDir, xmlName],' -q']);
mask=exrread('simulation.exr');
mask=rgb2gray(mask);
mask=mask~=0;
if ambient_light==1
    xml.scene.emitter{1,N+1}.float.Attributes.name = 'scale';
    xml.scene.emitter{1,N+1}.float.Attributes.value ='1';% num2str(normrnd(1,0.1));
end
%% modulation
pre_freq=round([upper_freq:-(upper_freq-lower_freq)/N:lower_freq]);
StopTime = nFrames*T;    % seconds
t = (0:T:StopTime-T)';  % seconds
Phase=2*pi*rand([1,10]);
Base=zeros([N,nFrames]);
for i=1:N
    Base(i,:) = 1/2+(1/2)*cos(2*pi*pre_freq(i)*t+Phase(i));
end
mov=zeros(H,W,1,nFrames);


for i=1:nFrames
    for j=1:N
        xml.scene.emitter{1,j}.spectrum.Attributes.name = 'intensity';
        xml.scene.emitter{1,j}.spectrum.Attributes.value = num2str(intensity*Base(j,i));
    end
    struct2xml(xml, xmlName);
    system([mitsubaDir, 'mitsuba', ' ','-s',mitsubaDir, '\servers.txt',' ', [xmlDir, xmlName],' -q']);
    image=exrread('simulation.exr');
    image=rgb2gray(image);
    image=mask.*image;
    mov(:,:,:,i)=image;
end
dlmwrite('C:\Users\yuval\Documents\meitar\LIVIPS\PSBox-v0.3.1\data\light_directions.txt', directions, ...
        'delimiter', ' ', 'precision', '%20.16f');
save('mov','mov');
%% perform Livi
[Base,Freq,Location]  = FindFreqFromMovRaw( mov,1,FPS,N);
MovMeanRaw=mean(double(mov(:,:,1,:)*255),4);
for i=1:N
[ image,~] = ReconstructModulatedLightFastRaw( mov,Base(i,:),0 );
 imwrite(image,"C:\Users\yuval\Documents\meitar\LIVIPS\PSBox-v0.3.1\data\Objects\image_"+num2str(i,'%02.f')+".png");    
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

