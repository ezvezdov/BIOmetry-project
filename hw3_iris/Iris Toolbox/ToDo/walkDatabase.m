% walkDatabase.m - load irisCode database and iterate through it
% E. Bakstein 21.11.2011

% initialize iris toolbox
iris_init;

% the database, containing calculated irisCode images
load database.mat
sides = 'LR';

% % Comparing images to the database entries
% folderPath = 'Images';
% files = dir(fullfile(folderPath, '*.*'));
% fileNames = {files.name};
% fid = fopen('images_database.txt', 'w');
% for i = 3:numel(fileNames)
%     [codeA, maskA]= createiristemplate(strcat("./Images/", fileNames{i}));
% 
%     min_HD = +inf;
%     min_HD_subject = 0;
%     min_HD_side = 0;
% 
%     for subject = 1:length(database)
%         for side = 1:2
%             for image = 1:length(database(subject).(sides(side)))
%                 template = database(subject).(sides(side))(image).template;
%                 mask_template = ~database(subject).(sides(side))(image).mask;
% 
%                 % display current progress
%                 % disp([num2str(subject) ' > ' sides(side) num2str(image)])
% 
%                 HD = irisHammingDistance(codeA,template, maskA, mask_template);
%                 if HD < min_HD && HD ~= 0
%                     min_HD = HD;
%                     min_HD_subject = subject;
%                     min_HD_side = sides(side);
%                 end
%             end
%         end
%     end
% 
%    % Latex table format 
%    fprintf(fid, '%s & %d & %s & %.3f \\\\ \n',fileNames{i}, min_HD_subject, min_HD_side, min_HD);
% end
% fclose(fid);

%% Comparing all-against-all int the database

savefile = strcat(irisConfig.cachePath, 'same_different_distributions.mat');
[stat,mess]=fileattrib(savefile);

if stat == 1
    load(savefile); 
else
    HDS_same_side = [];
    HDS_different_eyes = [];
    for subjectA = 1:length(database)
        for sideA = 1:2
            for imageA = 1:length(database(subjectA).(sides(sideA)))
                code_A = database(subjectA).(sides(sideA))(imageA).template;
                mask_A = ~database(subjectA).(sides(sideA))(imageA).mask;
    
                for subject = 1:length(database)
                    for side = 1:2
                        for image = 1:length(database(subject).(sides(side)))
                            template = database(subject).(sides(side))(image).template;
                            mask_template = ~database(subject).(sides(side))(image).mask;
    
                            % display current progress
                            % disp([num2str(subject) ' > ' sides(side) num2str(image)])
    
                            HD = irisHammingDistance(code_A, template, mask_A, mask_template);
    
                            if subjectA == subject && sideA == side
                                if imageA ~= image
                                    HDS_same_side(end+1) = HD;
                                end
                                % fprintf("%d %d - %s %s - %d %d - %d\n",subjectA, subject, sides(sideA), sides(side), imageA, image, HD)
                            else
                                HDS_different_eyes(end+1) = HD;
                            end
                        end
                    end
                end
            end
        end
    end
    save(savefile,'HDS_same_side','HDS_different_eyes');
end

if irisConfig.showImages == 1
    % Plotting the histogram
    figure;
    histogram(HDS_same_side, 'BinEdges', linspace(min(HDS_same_side), max(HDS_same_side), 20), 'Normalization', 'probability', 'FaceColor', 'blue', 'EdgeColor', 'none','LineWidth', 2);
    hold on;
    histogram(HDS_different_eyes, 'BinEdges', linspace(min(HDS_different_eyes), max(HDS_different_eyes), 20), 'Normalization', 'probability', 'FaceColor', 'red', 'EdgeColor', 'none', 'LineWidth', 2);
    xlabel('Hamming Distance');
    ylabel('Probability');
    legend('Same eye', 'Different eyes');
    grid on;
    hold off;
end


labels = [zeros(size(HDS_same_side)) ones(size(HDS_different_eyes))];
scores = [HDS_same_side HDS_different_eyes];

savefile = strcat(irisConfig.cachePath, 'threshold_selection.mat');
[stat,mess]=fileattrib(savefile);

if stat == 1
    load(savefile); 
else
    threshold_global = inf;
    FPR_global = inf;
    TPR_global = inf; 
    TNR_global = inf;
    FNR_global = inf;
    
    TPRs = zeros(size(scores(:)));
    FPRs = zeros(size(scores(:)));

    for i=1:numel(scores)
        threshold = scores(i);
        predicted = scores > threshold;
    
        P = sum(labels == 0);
        N = sum(labels == 1);
    
        TP = sum(labels == 0 & predicted == 0);
        FP = sum(labels == 1 & predicted == 0);
        TN = sum(labels == 1 & predicted == 1);
        FN = sum(labels == 0 & predicted == 1);
    
        TPR = TP / P;
        FPR = FP / N;
        TNR = TN / N;
        FNR = FN / P;
    
        TPRs(i) = TPR;
        FPRs(i) = FPR;
    
        if TPR > 0.96 && FPR < FPR_global
            threshold_global = threshold;
            TPR_global = TPR; 
            FPR_global = FPR;
            TNR_global = TNR;
            FNR_global = FNR;
        end
    end
    save(savefile,'TPRs','FPRs', 'threshold_global', 'TPR_global','FPR_global', 'TNR_global', 'FNR_global');
    
end

fprintf("Threshold = %f\nTPR = %f\nFPR = %f\nTNR = %f\nFNR = %f\n",threshold_global, TPR_global, FPR_global, TNR_global, FNR_global)


if irisConfig.showImages == 1
    % Plot  the ROC curve
    [FPRs_sorted, indexes_sorted] = sort(FPRs);
    TPRs_sorted = TPRs(indexes_sorted);
    figure;
    plot(FPRs_sorted, TPRs_sorted, 'b.-', 'LineWidth', 2);
    title('Receiver Operating Characteristic (ROC) Curve');
    xlabel('False Positive Rate (FPR)');
    ylabel('True Positive Rate (TPR)');
    grid on;
    axis([0 1 0 1]); % Set axis limits.
    hold on;
    plot([0, 1], [0, 1], 'k--'); % Add diagonal line representing random chance
    scatter(FPR_global, TPR_global,"filled","r"); % Plot choosed threshold
    legend('ROC Curve', 'Random Chance', 'Chosen Threshold', 'Location', 'southeast');
    hold off;
end


if irisConfig.showImages == 1
    % Plotting the histogram with threshold
    figure;
    histogram(HDS_same_side, 'BinEdges', linspace(min(HDS_same_side), max(HDS_same_side), 20), 'Normalization', 'probability', 'FaceColor', 'blue', 'EdgeColor', 'none','LineWidth', 2);
    hold on;
    histogram(HDS_different_eyes, 'BinEdges', linspace(min(HDS_different_eyes), max(HDS_different_eyes), 20), 'Normalization', 'probability', 'FaceColor', 'red', 'EdgeColor', 'none', 'LineWidth', 2);
    line([threshold_global, threshold_global], ylim, 'Color', 'g', 'LineWidth', 2);
    xlabel('Hamming Distance');
    ylabel('Probability');
    legend('Same eye', 'Different eyes', 'Thereshold');
    grid on;
    hold off;
end