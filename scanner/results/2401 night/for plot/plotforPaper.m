methods=["FNF","LIVI"];
conditions=["const","random"];
for i=1:length(methods)
    for j=1:length(conditions)
        data=load(methods(i)+"_"+conditions(j)+".mat");
        n= data.n(50:420,210:450,:);
        Z=data.Z;
        degrees=data.degrees(50:420,200:460,:);
        medianDegree=calcMedian(degrees);
        avDegree=calcSum(degrees);
        hAxis(1)= subplot(length(methods)*length(conditions),3,1+(i-1)*3*length(conditions)+(j-1)*3);
        pos = get( hAxis(1), 'Position' );
       % pos(3:4) =pos(3:4)*1.1 ; 
        pos(1)=pos(1)+ 0.05;
        pos(2)=pos(2)+ (2*i+j-3)*0.022;
        set( hAxis(1), 'Position', pos ) ;
        him=imshow(normalmap_to_RBG(flipud(n))); 
        set(him, 'AlphaData', ~isnan(flipud(n(:,:,1))))
        hAxis(2)= subplot(length(methods)*length(conditions),3,2+(i-1)*3*length(conditions)+(j-1)*3);
        pos = get( hAxis(2), 'Position' );
        %pos(3:4) =pos(3:4)*1.2 ;  
        pos(1)=pos(1)- 0.15;
        pos(2)=pos(2)+ (2*i+j-3)*0.022;
        set( hAxis(2), 'Position', pos ) ;
        [H1,W1,D1]=size(degrees);
        %imagesc(flipud(degrees'));
        him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
        set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
        shading flat;
        h = title  ( {"\fontname{Times New Roman}Mean: "+ num2str(round(avDegree,2))+ "°";"\fontname{Times New Roman}Median: "+ num2str(round(medianDegree,2))+ "°"} );
        pos = get ( h, 'position' );
        set ( h, 'position', pos+[0,470,0] )
        set(gca, 'ydir', 'reverse');
        hAxis(3)= subplot(length(methods)*length(conditions),3,3+(i-1)*3*length(conditions)+(j-1)*3);
        pos = get( hAxis(3), 'Position' );
        pos(1)=pos(1)- 0.29;
        pos(2)=pos(2)+ (2*i+j-3)*0.022;
        set( hAxis(3), 'Position', pos ) ;
        Z(isnan(n(:,:,1)) | isnan(n(:,:,2)) | isnan(n(:,:,3))) = NaN;
        surf(Z, 'EdgeColor', 'None', 'FaceColor', [0.5 0.5 0.5]);
        axis equal; camlight;
        view(100, 25);
        axis off
      
    end
end
