function model = make_model(mode, input)
% model = make_model(mode, input)
%   funkce pro tvorbu modelu podpisu
%   vstupy: 
%       MODE je string oznacujici typ modelu
%           'GMM' znaci model GMM
%
%       INPUT je struktura obsahujici vstupni parametry
%               vstupni parametry pro GMM:
%                   INPUT.learnDataIdx jsou indexy dat, ze kterych se bude model ucit
%                   INPUT.learnNum je alternativa k leanDataIdn oznacuje
%                      pocet prvnich podpisu, ze kterych se bude model ucit
%
%                   INPUT.data program pouzije primo tato data pro
%                      zpracovani
%                   nebo
%                   INPUT.id, INPUT.dataMode, INPUT.preMode, INPUT.featMode
%                       urcuje id cloveka (cislo), zdroj nacitani dat
%                       ('SVC'), zdroj predzpracovani ('xyp'), zdroj
%                       extrakce priznaku ('xyp')
%                   
%                   INPUT.compNum je cislo urcujici pocet gausovych krivek
%                      v GMM

if isfield(input, 'data') % pokud jsou vstupem data
    data = input.data;
else
    id = input.id; % pokud se data nacitaji
    dataMode = input.dataMode;
    preMode = input.preMode;
    featMode = input.featMode;
    
    data = load_data(dataMode, id); % nacteni dat
    data = preprocess(preMode, data);
    data = extract_features(featMode, data);
end
        
switch mode
    case 'GMM'
        compNum = input.compNum; %urcuje pocet gausovych krivek v GMM
        if isfield(input, 'learnDataIdx') % rozhoduje, ktera data se budou pouzivat pro tvorbu modelu
            learnIdx = input.learnDataIdx;
        else
            learnIdx = 1 : input.learnNum;
        end
        
        data = data(learnIdx); % vezme pouze data, ktera jsou urcena pro uceni
        data = cell2mat(data);
        
        for m = 1 : size(data, 2)
            opt = statset; 
            %opt = statset('MaxIter',1000);
            %opt.MaxIter = 1000; %nastaveni poctu iteraci pro fitting
            model{m} = gmdistribution.fit(data(:,m), compNum, 'options', opt); %samotne uceni modelu
        end
        
    case 'DTW'
        if isfield(input, 'learnDataIdx') % rozhoduje, ktera data se budou pouzivat pro tvorbu modelu
            learnIdx = input.learnDataIdx;
        else
            learnIdx = 1 : input.learnNum;
        end
        
        train_data = data(learnIdx); % vezme pouze data, ktera jsou urcena pro uceni
        model = train_data;
        
end


