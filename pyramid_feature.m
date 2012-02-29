function features=pyramid_feature(image)
    k4 = pyramid_feature_helper(image,4);
    k7 = pyramid_feature_helper(image,7);
    pixels = double(reshape(image, [], 1));
    features = double([pixels; k4; k7]);
end


function features=pyramid_feature_helper(image,kernel_size)
    
    %lets use summed area tables!!
    overlap_disp = floor(kernel_size/2);
    padded_sum = padarray(cumsum(cumsum(double(image),1),2), [overlap_disp overlap_disp]);
    
    old_width = size(image,1);
    old_height = size(image,2);
    
    new_width = floor(old_width/overlap_disp) -1;
    new_height = floor(old_height/overlap_disp) -1;
    
    feat = zeros(new_width, new_height);
    
    parfor i = 1:new_width
        for j = 1:new_height
            effX = i*overlap_disp;
            effY = j*overlap_disp;
            feat(i,j) = padded_sum(effX+kernel_size, effY+kernel_size) + ...
                padded_sum(effX,effY) - padded_sum(effX+kernel_size, effY) - ...
                padded_sum(effX, effY+kernel_size);
        end
    end
    
    features = double(reshape(feat, [], 1));
        
end
