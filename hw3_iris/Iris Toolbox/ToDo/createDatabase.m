iris_init

folderPath = './my_iris_cropped/';
sides = 'LR';

my_iris_database = struct('L', struct('template', {}, 'mask', {}), ...
                          'R', struct('template', {}, 'mask', {}));

% Database creation
for side = 1:2
    for image = 1:10
        filename = strcat(folderPath, sides(side),num2str(image),".bmp");

        if ~isfile(filename)
            break;
        end
        disp(filename);

        [template mask] = createiristemplate(filename);

        my_iris_database(1).(sides(side))(image).template = template;
        my_iris_database(1).(sides(side))(image).mask = mask;
    end
end
save('my_iris_database.mat', 'my_iris_database');

% Load the values from walkDatabase
savefile = strcat(irisConfig.cachePath, 'threshold_selection.mat');
[stat,mess]=fileattrib(savefile);
if stat == 1
    load(savefile); 
    %'TPRs','FPRs', 'threshold_global', 'TPR_global','FPR_global', 'TNR_global', 'FNR_global');
end


%% All-against-all comparison
database = my_iris_database;

HDS_same_side = [];
HDS_different_eyes = [];
for subjectA = 1:length(database)
    for sideA = 1:2
        for imageA = 1:length(database(subjectA).(sides(sideA)))
            code_A = database(subjectA).(sides(sideA))(imageA).template;
            mask_A = database(subjectA).(sides(sideA))(imageA).mask;

            for subject = 1:length(database)
                for side = 1:2
                    for image = 1:length(database(subject).(sides(side)))
                        template = database(subject).(sides(side))(image).template;
                        mask_template = database(subject).(sides(side))(image).mask;

                        HD = irisHammingDistance(code_A, template, mask_A, mask_template);

                        if subjectA == subject && sideA == side
                            if imageA ~= image
                                HDS_same_side(end+1) = HD;
                            end
                        else
                            HDS_different_eyes(end+1) = HD;
                        end
                    end
                end
            end
        end
    end
end


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


labels = [zeros(size(HDS_same_side)) ones(size(HDS_different_eyes))];
scores = [HDS_same_side HDS_different_eyes];
predicted = scores > threshold_global;    
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

fprintf("Threshold = %f\nTPR = %f\nFPR = %f\nTNR = %f\nFNR = %f\n",threshold_global, TPR, FPR, TNR, FNR)