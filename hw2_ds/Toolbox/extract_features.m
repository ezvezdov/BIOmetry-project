function data = extract_features(mode, data)
% data = extract_features(mode, data)
% funkce pro extrakci priznaku z dat

switch mode
    case 'xyp'
        data = data;
        % mozne doplnit pridani dalsich priznaku k datum
    case 'va'
        for m = 1 : length(data)
            x_coordinates = data{m}(:, 1);
            y_coordinates = data{m}(:,2);
            
            % Time step
            dt = 1.0;
            
            % Compute velocity
            vx = diff(x_coordinates) / dt;
            vy = diff(y_coordinates) / dt;
            vx = vertcat(0, vx);
            vy = vertcat(0, vy);
            
            vt = sqrt(vx.^2 + vy.^2); % Magnitude of velocity
            
            
            % Compute acceleration
            ax = diff(vx) / dt;
            ay = diff(vy) / dt;
            ax = vertcat(0, ax);
            ay = vertcat(0, ay);
            
            at = sqrt(ax.^2 + ay.^2); % Magnitude of acceleration

            data{m} = [ data{m}, vt, at];
        end
end
