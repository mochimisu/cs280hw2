function features = pyramid_features(images)
    new_size = 28*28 + calculateSize(4,28,28) + calculateSize(7,28,28);
    max = size(images, 3);
    %features = zeros(new_size , max);
    
    
    parfor i = 1:max
        features(:,i) = double(pyramid_feature(images(:,:,i)));
    end;
    %features = double(reshape(arrayfun(@(image) pyramid_feature(image, kernel_size), images), new_size*new_size, []));
end

function size=calculateSize(kernel_size, width, height)
    overlap_disp = floor(kernel_size/2);
    
    new_width = floor(width/overlap_disp) -1;
    new_height = floor(height/overlap_disp) -1;
    
    size = new_width * new_height;

end
