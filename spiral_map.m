function    index_list     = spiral_map( xy_size , circle_size )
%
% This function was used to obtain the gaze visualizations in figure 3 of:
% Rothkopf, C. A., Ballard, D. H., & Hayhoe, M. M. (2007). Task and context
% determine where you look. Journal of vision, 7(14), 16-16.
% Given a square patch of an image with length
%               2*xy_size+1
% on each side, take centered circle with diameter 
%               2*circle_size+1
% and build the list of indices of this square point matrix by going
% counterclockwise outside from the center.
% These indices can be used to extract the pixels from the circular region
% within the square image patch to produce the linear pixel arrangements
% representing the fixation at one point in time. 

% n_patch         = 13;
% V8 HMD:  640 x 400 pix  =^  35.9999 x 47.9986 degrees
% 800 pixels              =^  60 degrees diagonally visual angle
% 26.6667 pixels          =^  2 degrees
% 13.3337 pixels          =^  1 degree
% n_patch                 = 13;%7;%radius of central circular patch from image
% n_ex_patch              = 13;%7;%radius of central circular patch we want to use 

% Usage:
% index_list      = spiral_map( 5,5 )
% OR 
% spiral_map_i    = spiral_map( n_patch , n_ex_patch );
% for i = 1 : n_images% loop over images
%   current_patch           = imread( ... );%get current image patch
%   c_p_r                   = current_patch( : , : , 1 );%separate r,g,b
%   c_p_g                   = current_patch( : , : , 2 );
%   c_p_b                   = current_patch( : , : , 3 );
%   %this extracts the pixels from the center spiraling outwards    
%   vis_patch( :,i,1 )      = c_p_r( spiral_map_i );
%   vis_patch( :,i,2 )      = c_p_g( spiral_map_i );
%   vis_patch( :,i,3 )      = c_p_b( spiral_map_i );
%   %now vis_patch contains the linear stripe of pixels from the patch
%
% MIT License Copyright (c) [2007] [Constantin Rothkopf]

index_list      = [];

[x,y]           = meshgrid(     -xy_size:xy_size   ,   -xy_size:xy_size     );
mask            = sqrt(   x.^2+y.^2   )   <=   circle_size;

mask_mem        = mask;

for r = 0:circle_size+0.5%+1
    %tmp_mask    = sqrt(   x.^2+y.^2   )   <   r;
    for theta = 0 : 2*pi/500 : 2*pi
        r_test          = round(     -r*sin(theta) + xy_size + 1     );        
        c_test          = round(      r*cos(theta) + xy_size + 1     );
        
        if mask_mem( r_test , c_test ) == 1    
            index_list = [ index_list ; r_test c_test ];
            mask_mem( r_test , c_test ) = 0;
        end
    end
   
%    %debug:
%    tmp_img      = double( mask );
%    for i=1:size(index_list,1)
%        tmp_img(  index_list(i,1) , index_list(i,2)   ) = i / size(   index_list,1  );
%    end
%    imshow(tmp_img,[0 1])
%    drawnow
%    pause(1)
    
end

%debug:
% tmp_img      = double( mask );
% for i=1:size(index_list,1)
%   tmp_img(  index_list(i,1) , index_list(i,2)   ) = i / size(   index_list,1  );
% end
% imshow(tmp_img,[0 1])
% drawnow
% pause(1)

index_list  = (2*xy_size+1).*(index_list(:,2)-1) + index_list(:,1);


