path_to_dir = fullfile("..", "Own_Signatures", "Yauheni_Zviazdou");
files_list = dir('../Own_Signatures/Yauheni_Zviazdou/*.csv');


n = numel(files_list);
clss = zeros(n, 1);

for i=1:n
    
    file = files_list(i);
    fullPath = fullfile(path_to_dir, file.name);
    data{i} = readmatrix(fullPath);

    if contains(file.name, "Fals")
        clss(i) = 1;
    end

end

clss = flipud(clss);
data = flip(data);

global_thr = -114529;


% Finding threshhold
iteration_FP = [];
iteration_FN = [];
iteration_sc = [];
iteration_clss = [];


% ukazka podpisu a padelku
figure; subplot(121)
plot(data{1}(:, 1), data{1}(:, 2));
set(gca, 'XDir','reverse')
camroll(-180)
subplot(122)
plot(data{end}(:, 1), data{end}(:, 2));
set(gca, 'XDir','reverse')
camroll(-180)



% Preprocess
% data = preprocess('xyp', data); %preprocess
% data = preprocess('norm', data);
data = extract_features('va', data); %extrakce priznaku

% DTW
lNum = 3; %pocet podpisu, ktere budou pozity na tvorbu modelu
input.data = data;
input.learnNum = lNum;
model = make_model('DTW', input); %tvorba modelu

testSignatures = data(lNum+1:end); %testovaci data budou ta, ze kterych nebyl model tvoren
scores = score('DTW', testSignatures, model);

%vykresleni vyslednych score pro obe skupiny podpisu, mozne pomoci
%boxplotu, nebo histogramu, pripadne ROC krivky
% figure; 
% boxplot(scores, clss(lNum+1:end))
% xlabel('tridy, 0 = real signatures, 1 = forgeries');
% ylabel('score value = degree of similarity signtature and model');

%ROC krivka
% plotroc(abs(clss(lNum+1:end)'-1), scores)

%vykresleni pomoci histogramu
figure
hist(scores(clss(lNum+1:end)==0))
hold on
[b, bs] = hist(scores(clss(lNum+1:end)==1));
bar(bs, b, 'r')
hold on; plot([global_thr, global_thr], [0 3], "k", 'LineWidth', 5); hold off;
xlabel('score = degree of similarity with model'); ylabel('quantity')
legend({'Real signatures', 'Forgeries', 'Threshold'});

% vypocet chyby EER
[eer FP FN thresh] = get_eer(clss(lNum+1:end), scores);
% figure; plot(thresh, [FP' FN']);
% xlabel('score'); ylabel('pomerna chyba')
% legend({'false positive rate', 'false negative rate'});

iteration_FP = cat(2,iteration_FP, FP);
iteration_FN = cat(2,iteration_FN, FN);
iteration_sc = cat(2,iteration_sc, thresh);
iteration_clss = cat(1,iteration_clss, clss(lNum+1:end));



thr_scores = iteration_sc <= global_thr;

scLen = length(iteration_sc);

FP = sum(iteration_clss == 0 & thr_scores' == 1);
FN = sum(iteration_clss == 1 & thr_scores' == 0);

fprintf('Threshold fog DTW is %.0f.\n',global_thr);
fprintf('Amount of test cases is %d.\n', scLen);
fprintf('Amount of False Negatives is %d.\n', FN);
fprintf('Amount of False Positives is %d.\n', FP);
fprintf('Error is: %.3f.\n',(FN + FP) / scLen)
fprintf('False Negative error: %.3f.\n',FN / scLen)
fprintf('False Positive error: %.3f.\n',FP / scLen)


% sort scores
[iteration_sc_sorted, iteration_sc_sorted_indices] = sort(iteration_sc);

% show plot
figure; 
xlim([min(iteration_sc) max(iteration_sc)])
plot(iteration_sc_sorted, [iteration_FP(iteration_sc_sorted_indices)' iteration_FN(iteration_sc_sorted_indices)'])
hold on; plot([global_thr, global_thr], [0 0.7], "k", 'LineWidth', 2); hold off;
xlabel('score'); ylabel('proportional error')
legend({'False positive rate', 'False negative rate', 'Threshold'});

% Make FN and FP data smoothier
% smoothed_FP = smoothdata(iteration_FP(iteration_sc_sorted_indices), 'movmean', 50); % Adjust the window size as needed
% smoothed_FN = smoothdata(iteration_FN(iteration_sc_sorted_indices), 'movmean', 50); % Adjust the window size as needed

% show smoothed plot
% figure; 
% xlim([min(iteration_sc) max(iteration_sc)])
% plot(iteration_sc_sorted, [smoothed_FP' smoothed_FN'])
% hold on; plot([global_thr, global_thr], ylim, "k", 'LineWidth', 2); hold off;
% xlabel('score'); ylabel('proportional error')
% legend({'False positive rate', 'False negative rate', 'Threshold'});


% Show missclassified signature
% ukazka podpisu a padelku
figure; subplot(121)
plot(data{5}(:, 1), data{5}(:, 2));
set(gca, 'XDir','reverse')
camroll(-180)
subplot(122)
plot(data{end-5}(:, 1), data{end-5}(:, 2));
set(gca, 'XDir','reverse')
camroll(-180)