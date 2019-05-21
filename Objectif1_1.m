close all;
clear all;
%% Chaine passe bas

%Durée symbole en nombre d’échantillons
Rs = 1000;
Ts = 1/Rs;

%Nombre de bits générés
nb_bits = 100000; 
Fe = 10000;
fp = 2000;
M = 2; %nb bits par symboles
span = 5;
sps = Fe/Rs;
Eb_N0 = 0:0.2:6;

%% QPSK
ordre_mod = 4;
bits = randi([0,1], 1, nb_bits);
%Mapping
bits_I = bits(1:2:end);
bits_Q = bits(2:2:end);
Symboles_I = 2*bits_I-1;
Symboles_Q = 2*bits_Q-1;  
Symboles = Symboles_I + 1i*Symboles_Q;

% Constellation émise
scatterplot(Symboles);
title("Constellation QPSK émise");

%Génération suites de Diracs pondérés
Suite_diracs = kron(Symboles, [1 zeros(1,sps-1)]); 
%Réponse impulsionnelle
h = rcosdesign(0.35, span, sps, 'sqrt'); 
t = 0:1/Fe:Ts*nb_bits/2-1/Fe;

%Filtrage mise en forme
y_qpsk = filter(h, 1, [Suite_diracs, zeros(1, span*sps/2)]);
y_qpsk = y_qpsk(span*sps/2 + 1:end);

%Canal de transmission AWGN (ajout bruit blanc gaussien)
var_symboles = var(Symboles);
p = 10^(Eb_N0(1)/10);
var_bruit_carre = var_symboles * sum(abs(h).^2)/ (2 * log2(ordre_mod) * p);
bruit = sqrt(var_bruit_carre) * randn(1, length(y_qpsk)) + 1i * sqrt(var_bruit_carre) * randn(1, length(y_qpsk));

y_qpsk_bruit = y_qpsk + bruit;

%Filtre de reception SANS bruit
h_adapte = conj(fliplr(h));
%fvtool(h_adapte, 'impulse');
y_qpsk_filt = filter(h_adapte, 1, [y_qpsk,zeros(1,span*sps/2)]);
y_qpsk_filt=y_qpsk_filt(span*sps/2+1:end);
%Diagramme de l'oeil
%eyediagram(y_qpsk_filt,2*sps, 2*sps);

%Filtre de reception AVEC bruit
y_qpsk_bruit = [y_qpsk_bruit,zeros(1,span*sps/2)];
y_qpsk_bruit_filt = filter(h_adapte, 1, y_qpsk_bruit);
y_qpsk_bruit_filt=y_qpsk_bruit_filt(span*sps/2+1:end);

%Echantillonnage
y_qpsk_bruit_filt_ech = y_qpsk_bruit_filt(1:sps:end);

%Détecteur à seuil & Demapping
y_qpsk_I = real(y_qpsk_bruit_filt_ech) > 0;
y_qpsk_Q = imag(y_qpsk_bruit_filt_ech) > 0;

y_total = zeros(1,2*length(y_qpsk_I));
y_total(1:2:end) = y_qpsk_I;
y_total(2:2:end) = y_qpsk_Q;

%TEB
TEB_QPSK = sum(abs(bits-y_total))/length(y_total)

% Tracé TEB simulé
TEB_QPSK =[];

for i= 1:length(Eb_N0)
    p = 10^(Eb_N0(i)/10);
    var_bruit_carre = var_symboles * sum(abs(h).^2) ./ (2 * log2(ordre_mod) * p);
    bruit = sqrt(var_bruit_carre) * randn(1, length(y_qpsk)) + 1i * sqrt(var_bruit_carre) * randn(1, length(y_qpsk));
    y_qpsk_bruit = y_qpsk + bruit;
    %Filtrage de reception du signal avec bruit
    h_adapte = conj(fliplr(h));
    y_qpsk_bruit_filt = filter(h_adapte, 1, [y_qpsk_bruit,zeros(1,span*sps/2)]);
    y_qpsk_bruit_filt = y_qpsk_bruit_filt(span*sps/2+1:end);
    %Echantillonnage
    y_qpsk_bruit_filt_ech = y_qpsk_bruit_filt(1:sps:end);
    %Détecteur à seuil & Demapping
    y_qpsk_I = real(y_qpsk_bruit_filt_ech) > 0;
    y_qpsk_Q = imag(y_qpsk_bruit_filt_ech) > 0;
    
    y_total = zeros(1,2*length(y_qpsk_I));
    y_total(1:2:end) = y_qpsk_I;
    y_total(2:2:end) = y_qpsk_Q;

    %TEB
    TEB_QPSK(i) = sum(abs(bits-y_total))/length(y_total);
end
%Tracé TEB théorique 
TEB_theorique = [];
for i= 1:length(Eb_N0)
    p = 10^(Eb_N0(i)/10);
    TEB_theorique(i) = qfunc(sqrt(2*p));
end
%figure();
%semilogy(Eb_N0, TEB_QPSK); grid on
% title(" TEB simulé du signal QPSK en fonction de EB/N0");
% ylabel("TEB");
% xlabel("Eb/N0 (dB)");

% Constellation en sortie de l'échantillonneur
%scatterplot(y_qpsk_bruit_filt_ech);
%title("Constellation QPSK en sortie de l'échantillonneur");
%Constellation en sortie du bloc de décision
%scatterplot(y_total);
%title("Constellation QPSK en sortie du bloc de décision");

%Comparaison TEB
figure();
semilogy(Eb_N0, TEB_QPSK); hold on
semilogy(Eb_N0, TEB_theorique); grid on
title("TEB theorique VS TEB simule signal QPSK");
legend("TEB simulé", "TEB theorique");
ylabel("TEB");
xlabel("Eb/N0 (dB)");

%% DVB-S equivalent low pass channel with Forward Error Correction
K=7;
g1=171;
g2=133;
Eb_N0 = -4:0.2:6;
bits_avant = randi([0,1], 1, nb_bits);
puncpat=[1 1];
%Ajout d'un code correcteur d'erreur convolutionnel
treillis = poly2trellis(K,[g1 g2]); 
bits = convenc(bits_avant, treillis);
%Mapping
bits_I = bits(1:2:end);
bits_Q = bits(2:2:end);
Symboles_I = 2*bits_I-1;
Symboles_Q = 2*bits_Q-1;  
Symboles = Symboles_I + 1i*Symboles_Q;

%Génération suites de Diracs pondérés
Suite_diracs = kron(Symboles, [1 zeros(1,sps-1)]); 
%Réponse impulsionnelle
h = rcosdesign(0.35, span, sps, 'sqrt'); 
t = 0:1/Fe:Ts*nb_bits/2-1/Fe;

%Filtrage mise en forme
y_qpsk = filter(h, 1, [Suite_diracs, zeros(1, span*sps/2)]);
y_qpsk = y_qpsk(span*sps/2 + 1:end);


% Tracé TEB simulé
TEB_QPSK =[];

for i= 1:length(Eb_N0)
    p = 10^(Eb_N0(i)/10);
    var_bruit_carre = var_symboles * sum(abs(h).^2) ./ (2 * log2(ordre_mod) * p);
    bruit = sqrt(var_bruit_carre) * randn(1, length(y_qpsk)) + 1i * sqrt(var_bruit_carre) * randn(1, length(y_qpsk));
    y_qpsk_bruit = y_qpsk + bruit;
    %Filtrage de reception du signal avec bruit
    h_adapte = conj(fliplr(h));
    y_qpsk_bruit_filt = filter(h_adapte, 1, [y_qpsk_bruit,zeros(1,span*sps/2)]);
    y_qpsk_bruit_filt = y_qpsk_bruit_filt(span*sps/2+1:end);
    
    %Echantillonnage
    y_qpsk_bruit_filt_ech = y_qpsk_bruit_filt(1:sps:end);
    
    %Détecteur à seuil & Demapping
    y_qpsk_I = real(y_qpsk_bruit_filt_ech) > 0;
    y_qpsk_Q = imag(y_qpsk_bruit_filt_ech) > 0;
    
    y_total = zeros(1,2*length(y_qpsk_I));
    y_total(1:2:end) = y_qpsk_I;
    y_total(2:2:end) = y_qpsk_Q;

    %décodage viterbi
    tblen = 5*K;
    y_decode_hard = vitdec(y_total,treillis,tblen,'trunc','hard');
    
    
    %TEB
    %TEB_QPSK(i) = sum(abs(bits-y_total))/length(y_total);
    TEB_QPSK_hard(i) = sum(abs(bits_avant-y_decode_hard))/length(y_decode_hard);
    
end
%Tracé TEB théorique 
TEB_theorique = [];
for i= 1:length(Eb_N0)
    p = 10^(Eb_N0(i)/10);
    TEB_theorique(i) = qfunc(sqrt(2*p));
end
%Comparaison TEB
figure();
semilogy(Eb_N0, TEB_theorique); hold on
semilogy(Eb_N0, TEB_QPSK_hard); grid on
title("TEB theorique VS TEB simule signal QPSK");
legend( "TEB theorique","TEB simulé");
ylabel("TEB");
xlabel("Eb/N0 (dB)");