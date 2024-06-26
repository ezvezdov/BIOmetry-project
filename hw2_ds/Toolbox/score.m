function sc = score(mode, signatures, model)
% sc = score(mode, signatures, model)
% funkce pocitajici score daneho modelu

switch mode
    case'GMM'
        sc = zeros(1, numel(signatures)); % ulozime pravdepodobnosti ze dany podpis (z test) odpovida modelu
        for m = 1 : numel(signatures)
            for n = 1 : numel(model)
                p = pdf(model{n}, signatures{m}(:, n)); % vypocet pdf pro kazdy bod podpisu
                sc(m) = sc(m) + sum(log(p)); % zlogaritmujeme a secteme
            end
        end
    case 'DTW'

        sc = zeros(1, numel(signatures));

        for test_i = 1:numel(signatures)
            dists_ls = zeros(numel(model),1);
            for model_i = 1:numel(model)
                s1 = model{model_i};
                s2 = signatures{test_i};

                t = size(s1,1);
                s = size(s2,1);
                D = zeros(t+1,s+1);
                
                D(1,:) = inf;
                D(:,1) = inf;
                D(1,1) = 0;

                for t_i = 2:(t+1)
                    for s_j = 2:(s+1)
                        D(t_i, s_j) = norm(s1(t_i-1,:) - s2(s_j-1,:)) + min( [D(t_i, s_j-1), D(t_i-1, s_j), D(t_i-1, s_j-1)] );
                    end
                end

                dists_ls(model_i,1) = -D(t+1, s+1);
            end
            sc(1,test_i) = mean(dists_ls);
        end
end