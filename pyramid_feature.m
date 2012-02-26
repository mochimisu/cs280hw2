

function features=pyramid_feature(image,kernel_size)
    
    %lets use summed area tables!!
    %image
    padded_sum = padarray(cumsum(cumsum(double(image),1),2), [1 1]);
    
    old_width = size(image,1);
    old_height = size(image,2);
    
    new_width = old_width-(kernel_size-1);
    new_height = old_height-(kernel_size-1);
    
    
    feat = zeros(new_width, new_height);
    
    for i = 1:new_width
        for j = 1:new_height
            feat(i,j) = padded_sum(i+kernel_size, j+kernel_size) + ...
                padded_sum(i,j) - padded_sum(i+kernel_size, j) - ...
                padded_sum(i, j+kernel_size);
        end
    end
    
   
    features = double(reshape(feat, [], 1));
           
    
end
