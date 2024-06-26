vstupni_data = 'SVC';
persons = [1 2 4 7 8 10 13 18 26 27 29 31 32 34 38];

persons_amount = 12;
test_persons = persons(1:persons_amount);

global_thr = 0;
iterations = 1;
max_FN = 0.1; % maximum False Negative Rate is 10%

% Finding threshhold
for global_iteration=1:(iterations+1)
    iteration_thr = 0;
    iteration_FP = [];
    iteration_FN = [];
    iteration_sc = [];
    iteration_clss = [];
    
    for person_index=1:persons_amount 
        subjekt.id = test_persons(person_index);
    
        [data clss] = load_data(vstupni_data, subjekt); %nacteni vstupnich dat
    
        % ukazka podpisu a padelku
        % figure; subplot(121)
        % plot(data{1}(:, 1), data{1}(:, 2)); title('pravy podpis');
        % subplot(122)
        % plot(data{21}(:, 1), data{21}(:, 2)); title('padelek')
    
        % Preprocess
        data = preprocess('xyp', data); %preprocess
        % data = preprocess('norm', data);
        % data = extract_features('dt', data); %extrakce priznaku, zatim nic nedela
    
        % GMM
        lNum = 3; %pocet podpisu, ktere budou pozity na tvorbu modelu
        input.data = data;
        input.learnNum = lNum;
        input.compNum = 3; %pocet gausianu pouzitych pro GMM
        model = make_model('GMM', input); %tvorba modelu
        
        testSignatures = data(lNum+1:end); %testovaci data budou ta, ze kterych nebyl model tvoren
        scores = score('GMM', testSignatures, model);    

        %vykresleni vyslednych score pro obe skupiny podpisu, mozne pomoci
        %boxplotu, nebo histogramu, pripadne ROC krivky
        % figure; 
        % boxplot(scores, clss(lNum+1:end))
        % xlabel('tridy, 0 = prave podpisy, 1 = falsifikaty');
        % ylabel('hodnota score = mira podobnosti podpisu s modelem');
    
        %ROC krivka
        % plotroc(abs(clss(lNum+1:end)'-1), scores)
    
        %vykresleni pomoci histogramu
        % figure
        % hist(scores(clss(lNum+1:end)==0))
        % hold on
        % [b, bs] = hist(scores(clss(lNum+1:end)==1));
        % bar(bs, b, 'r')
        % xlabel('score = mira podobnosti s modelem'); ylabel('cetnost')
        % legend({'prave podpisy', 'falsifikaty'})
    
        % vypocet chyby EER
        [eer FP FN thresh] = get_eer(clss(lNum+1:end), scores);
        %figure; plot(thresh, [FP' FN']);
        %xlabel('score'); ylabel('pomerna chyba')
        %legend({'false positive rate', 'false negative rate'});
        

        opt_score = scores(end);
        thr_scores = scores( FN <= max_FN);
        if ~isempty(thr_scores) 
            opt_score = thr_scores(1);
        end
        
        iteration_thr = iteration_thr + opt_score;
    
        iteration_FP = cat(2,iteration_FP, FP);
        iteration_FN = cat(2,iteration_FN, FN);
        iteration_sc = cat(2,iteration_sc, thresh);
        iteration_clss = cat(1,iteration_clss, clss(lNum+1:end));
    end
    iteration_thr = iteration_thr / persons_amount;
    
    
    if global_iteration < iterations+1
        global_thr = global_thr + iteration_thr;
    end
    if global_iteration == iterations
        global_thr = global_thr / iterations;
        disp(global_thr)
    end
    if global_iteration == (iterations+1)
        thr_scores = iteration_sc <= global_thr;

        FP = sum(iteration_clss == 0 & thr_scores' == 1);
        FN = sum(iteration_clss == 1 & thr_scores' == 0);
           
        scLen = length(iteration_sc);
        
        fprintf('Threshold fog GMM is %.0f.\n',global_thr);
        fprintf('Amount of test cases is %d.\n', scLen);
        fprintf('Amount of False Negatives is %d.\n', FN);
        fprintf('Amount of False Positives is %d.\n', FP);
        fprintf('Error is: %.3f.\n',(FN + FP) / scLen)
        fprintf('False Negative error: %.3f.\n',FN / scLen)
        fprintf('False Positive error: %.3f.\n',FP / scLen)


        % sort scores
        [iteration_sc_sorted, iteration_sc_sorted_indices] = sort(iteration_sc);

        % show original plot
        % figure; 
        % xlim([min(iteration_sc) max(iteration_sc)])
        % plot(iteration_sc_sorted, [iteration_FP(iteration_sc_sorted_indices)' iteration_FN(iteration_sc_sorted_indices)'])
        % hold on; plot([global_thr, global_thr], [0 0.7], "k", 'LineWidth', 2); hold off;
        % xlabel('score'); ylabel('proportional error')
        % legend({'False positive rate', 'False negative rate', 'Threshold'});
        
        % Make FN and FP data smoothier
        smoothed_FP = smoothdata(iteration_FP(iteration_sc_sorted_indices), 'movmean', 50); % Adjust the window size as needed
        smoothed_FN = smoothdata(iteration_FN(iteration_sc_sorted_indices), 'movmean', 50); % Adjust the window size as needed

        % show smoothed plot
        figure; 
        xlim([min(iteration_sc) max(iteration_sc)])
        plot(iteration_sc_sorted, [smoothed_FP' smoothed_FN'])
        hold on; plot([global_thr, global_thr], ylim, "k", 'LineWidth', 2); hold off;
        xlabel('score'); ylabel('proportional error')
        legend({'False positive rate', 'False negative rate', 'Threshold'});
    end
end

% FNR system incorrectly rejects original signatures
% FPR system 
% FPR should be max 10%