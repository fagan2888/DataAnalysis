%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate position of target scatter
% f_raw - input solved f
% indices, imgDomain, domainGrid - refer to scene setup
% Threshold - thresholding if using filtering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [maxVal_position, small_imgDomain, subIndices] = filterScatterers(f_raw,...
                                             indices, ...
                                             imgDomain, ...
                                             domainGrid,...
                                             threshold,...
                                             numPoints, ...
                                             lookWithinRadius...
                                             )

maxVal_position=[];

f = zeros(size(imgDomain, 1), 1);
f(indices) = abs(f_raw).^2/max(max(max(abs(f_raw).^2)));
f_plot=reshape(f, domainGrid);
% f_db       = 20*log10(abs(f_plot));
% thresh     = max(max(max(f_db))) -parser.Results.Threshold;
% f_db(f_db  <thresh)= thresh;

for i=1:numPoints
    
    [~,index_max(i)]=max(f_plot(:));
 
    %find distance
    pt_distance=sum(bsxfun(@minus,imgDomain,imgDomain(index_max(i),:)).^2,2).^(1/2);
    %values for f of small region (log)
    f_smallImgDomain{i}=f_plot(pt_distance<lookWithinRadius);
    small_imgDomain{i}=imgDomain(pt_distance<lookWithinRadius,:);
    indexer=1:length(imgDomain);
    subIndices{i}=indexer(pt_distance<lookWithinRadius);
    %solve for max position using centroid
    x_centroid=sum(small_imgDomain{i}(:,1).*abs(f_smallImgDomain{i}))/sum(abs(f_smallImgDomain{i}));
    y_centroid=sum(small_imgDomain{i}(:,2).*abs(f_smallImgDomain{i}))/sum(abs(f_smallImgDomain{i}));
    z_centroid=sum(small_imgDomain{i}(:,3).*abs(f_smallImgDomain{i}))/sum(abs(f_smallImgDomain{i}));
    maxVal_position(i,:)=[x_centroid,y_centroid,z_centroid];
   
%     f_plot(pt_distance<lookWithinRadius)=-inf;
    f_plot(pt_distance<lookWithinRadius)=0;
    
    %determine sub reconstruction zones
    % smallReconstructionRegionPlot(29,imgDomain(index_max(i),:), lookWithinRadius,num2str(i));
end


% x_centroid=sum(imgDomain(indices,1).*abs(f_raw(:)).^2)/sum(abs(f_raw).^2);
% y_centroid=sum(imgDomain(indices,2).*abs(f_raw(:)).^2)/sum(abs(f_raw).^2);
% z_centroid=sum(imgDomain(indices,3).*abs(f_raw(:)).^2)/sum(abs(f_raw).^2);
% maxVal_position=[x_centroid, y_centroid,z_centroid];

% %         f = zeros(size(imgDomain, 1), 1);
% %         f(indices) = abs(f_raw).^2;
% %         f_plot=reshape(f,domainGrid);
% %         f_db       = 20*log10(abs(f_plot));
% %         thresh     = max(max(max(f_db))) -threshold;
% % %         f          = ones(size(f_plot))*thresh;
% % %         f_plot = 20*log10(abs(f_plot));
% %         f_db  (f_db  <thresh)= thresh;

%         %upsample to determine max position
%         if ~isnan(R_fine)
%             X_subImgDomain=[min(imgDomain(indices,1)):R_fine:max(imgDomain(indices,1))];
%             Y_subImgDomain=[min(imgDomain(indices,2)):R_fine:max(imgDomain(indices,2))];
%             Z_subImgDomain=[min(imgDomain(indices,3)):R_fine:max(imgDomain(indices,3))];
%
%
%             %convert to log scale and correct indexing
%             f2_db       = 20*log10(abs(f_raw));
%             thresh     = max(max(max(f2_db))) -threshold;
%             %         f2          = ones(size(f_raw))*thresh;
%             %         db = 20*log10(abs(f_raw));
%             f2_db(f2_db<thresh)= thresh;
%
%             %define fine grid for interpolation
%             [Xf, Yf, Zf]=meshgrid(X_subImgDomain,Y_subImgDomain,Z_subImgDomain);
%             XI=[Xf(:),Yf(:),Zf(:)];
%             XYZf=[imgDomain(indices,1),imgDomain(indices,2),imgDomain(indices,3)];
%             f_up=griddatan(XYZf, f2_db, XI);
%
%             [f_max, f_I]=max(f_up);
%             maxVal_position=[Xf(f_I),Yf(f_I),Zf(f_I)];
%         else
%             [max_value,index_max]=max(f_plot(:));
%             maxVal_position=imgDomain(index_max,:);
%         end
end