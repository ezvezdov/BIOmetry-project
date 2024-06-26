%ukazkovy skript
vstupni_data = 'SVC';
subjekt.id = 36;
[data clss] = load_data(vstupni_data, subjekt); %nacteni vstupnich dat

%% ukazka podpisu a padelku
figure; subplot(121)
plot(data{1}(:, 1), data{1}(:, 2)); title('pravy podpis');
subplot(122)
plot(data{21}(:, 1), data{21}(:, 2)); title('padelek')

%% Preprocess
data = preprocess('xyp', data); %preprocess
% data = preprocess('norm', data);
data = extract_features('dt', data); %extrakce priznaku, zatim nic
% nedela

%% GMM
lNum = 3; %pocet podpisu, ktere budou pozity na tvorbu modelu
input.data = data;
input.learnNum = lNum;
input.compNum = 3; %pocet gausianu pouzitych pro GMM
model = make_model('GMM', input); %tvorba modelu

testSignatures = data(lNum+1:end); %testovaci data budou ta, ze kterych nebyl model tvoren

%vykresleni vyslednych score pro obe skupiny podpisu, mozne pomoci
%boxplotu, nebo histogramu, pripadne ROC krivky
figure; 
scores = score('GMM', testSignatures, model);
boxplot(scores, clss(lNum+1:end))
xlabel('tridy, 0 = prave podpisy, 1 = falsifikaty');
ylabel('hodnota score = mira podobnosti podpisu s modelem');

%ROC krivka
plotroc(abs(clss(lNum+1:end)'-1), scores)

%vykresleni pomoci histogramu
figure
hist(scores(clss(lNum+1:end)==0))
hold on
[b, bs] = hist(scores(clss(lNum+1:end)==1));
bar(bs, b, 'r')
xlabel('score = mira podobnosti s modelem'); ylabel('cetnost')
legend({'prave podpisy', 'falsifikaty'})

%% vypocet chyby EER
[eer FP FR thresh] = get_eer(clss(lNum+1:end), scores);
figure; plot(thresh, [FP' FR']);
xlabel('score'); ylabel('pomerna chyba')
legend({'false positive rate', 'false negative rate'});