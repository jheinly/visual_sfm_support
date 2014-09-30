function [] = plot_cameras(camera_data, camera_size, camera_color)

    if ~exist('camera_size', 'var')
        camera_size = -1;
    end
    
    if camera_size <= 0
        min_center = min(camera_data.centers, [], 2);
        max_center = max(camera_data.centers, [], 2);
        camera_size = 0.04 * norm([min_center max_center]);
    end
    
    if ~exist('camera_color', 'var')
        camera_color = 'k';
    end
    
    num_cameras = camera_data.num_cameras;
    centers = camera_data.centers;
    orientations = camera_data.orientations;
    
    cam_corners = zeros(4*3, num_cameras);
    for i = 1:num_cameras
        cam_corners(1:3,i) = centers(:,i) + orientations{i} * camera_size * [0.4 0.4 1]';
        cam_corners(4:6,i) = centers(:,i) + orientations{i} * camera_size * [0.4 -0.4 1]';
        cam_corners(7:9,i) = centers(:,i) + orientations{i} * camera_size * [-0.4 -0.4 1]';
        cam_corners(10:12,i) = centers(:,i) + orientations{i} * camera_size * [-0.4 0.4 1]';
    end
    
    hold on
    axis equal
    line(...
        [cam_corners(10,:); cam_corners(1,:); centers(1,:); cam_corners(4,:); cam_corners(1,:)],...
        [cam_corners(11,:); cam_corners(2,:); centers(2,:); cam_corners(5,:); cam_corners(2,:)],...
        [cam_corners(12,:); cam_corners(3,:); centers(3,:); cam_corners(6,:); cam_corners(3,:)],...
        'LineWidth', 1, 'Color', camera_color);
    line(...
        [cam_corners(4,:); cam_corners(7,:); centers(1,:); cam_corners(10,:); cam_corners(7,:)],...
        [cam_corners(5,:); cam_corners(8,:); centers(2,:); cam_corners(11,:); cam_corners(8,:)],...
        [cam_corners(6,:); cam_corners(9,:); centers(3,:); cam_corners(12,:); cam_corners(9,:)],...
        'LineWidth', 1, 'Color', camera_color);

end
