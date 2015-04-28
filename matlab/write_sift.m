function [] = write_sift(sift_filepath, keypoints, descriptors)

    % keypoints   = 4   x N, single, (x, y, scale, orientation)
    % descriptors = 128 x N, uint8
    
    validateattributes(keypoints, {'single'}, {'nrows',4})
    validateattributes(descriptors, {'uint8'}, {'nrows',128})
    
    if size(keypoints,2) ~= size(descriptors,2)
        disp('ERROR: the number of keypoints and descriptors must be equal')
        return
    end
    
    % Attempt to open the file for writing.
    file = fopen(sift_filepath, 'wb');
    if file == -1
        disp(['ERROR: failed to open file: ' sift_filepath])
        return
    end
    
    % Write the SIFT file header.
    header = 'SIFTV4.0';
    fwrite(file, header, 'char');
    
    num_features = size(features, 2);
    num_feature_dims = 5;
    num_descriptor_dims = 128;
    
    % Write the file's specifications.
    fwrite(file, num_features, 'int');
    fwrite(file, num_feature_dims, 'int');
    fwrite(file, num_descriptor_dims, 'int');
    
    % Add empty color information embedded in the 3rd dimension of the
    % keypoints vector.
    keypoints = [keypoints(1:2,:); zeros(1,num_features,'single'); keypoints(3:4,:)];
    
    % Write the file's contents.
    fwrite(file, features, 'single');
    fwrite(file, descriptors, 'uint8');
    
    % Write the SIFT file footer.
    footer = '_EOF';
    footer(1) = 255;
    fwrite(file, footer, 'char');
    
    fclose(file);

end % function
