function [] = plot_nvm(camera_data, point_data, camera_size, camera_color, point_color)

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
    
    if ~exist('point_color', 'var')
        point_color = 'k';
    end
    
    hold on
    axis equal
    plot_cameras(camera_data, camera_size, camera_color);
    plot3(point_data.xyzs(1,:), point_data.xyzs(2,:), point_data.xyzs(3,:),...
        '.', 'MarkerSize', 1, 'Color', point_color);

end
