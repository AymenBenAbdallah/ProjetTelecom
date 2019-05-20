clear all;
close all;

% Durée symbole
Ts = 4;
nb_bits = 10000;
Ns_NRZ= 5;
Te_NRZ = Ts/Ns_NRZ;
Eb_N0 = 0:0.2:6;
rolloff = 0.35;
Ns_CRRC =4;
M=2;


%% Génération de l'information binaire à transmettre
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
bits_NRZ = randi([0,1],1,nb_bits);


%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
bits_CRRC = randi([0,1],1,nb_bits);



%% Mapping du code binaire
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
map_NRZ = 2*bits_NRZ-1;


%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
%Mapping binaire à moyenne nulle: 0->-1, 1->1
Symboles_CRRC = 2*bits_CRRC-1;



%% Suréchantillonnage de la chaine de transmission
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
signal_NRZ = kron(map_NRZ,ones(1,Ns_NRZ));


%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%

%Génération de la suite de Diracs pondérés
Suite_diracs_CRRC = kron(Symboles_CRRC, [1 zeros(1,Ts-1)]); 
Suite_diracs_CRRC = [Suite_diracs_CRRC,zeros(1,Ns_CRRC*Ts)]; %ajout de zeros à la fin
%% Filtrage
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
%réponse impulsionnelle
h_NRZ = ones(1,Ts);

%filtrage de mise en forme
signal_filtre_NRZ = filter(h_NRZ,1,signal_NRZ);


%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
%réponse impulsionnelle 

h_CRRC = rcosdesign(rolloff,Ns_CRRC,Ts,'sqrt');

%filtrage de mise en forme
y_CRRC = filter(h_CRRC,1,Suite_diracs_CRRC);
%% chaine de transmission AWGN
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
var_symbole_NRZ = var(map_NRZ);
<<<<<<< HEAD

=======
>>>>>>> 0d680f00415cadbd98668a53f35909ebe7814c9e


%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
var_symboles = var(Symboles_CRRC);
p = 10^(Eb_N0(floor(length(Eb_N0)/2))/10);
var_bruit_carre = var_symboles * sum(abs(h_CRRC).^2) ./ (2 * log2(M) * p); 
bruit = sqrt(var_bruit_carre) * randn(1, length(y_CRRC));

y_CRRC_bruit = y_CRRC + bruit;



%% Démodulation bande de base
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
%Filtrage de réception du signal sans bruit
h_CRRC_adapte = conj(fliplr(h_CRRC));
y_CRRC_filt = filter(h_CRRC_adapte, 1, y_CRRC);
y_CRRC_filt = y_CRRC(Ns_CRRC*Ts+1:end); %on retire les premiers 0
%Diagramme de l'oeil
eyediagram(y_CRRC_filt,2*Ts,2*Ts);
title("Diagramme de l'oeil du signal SRRCF");

%on choisit t0 = Ts avec un seuil de détection à 0
%Filtrage de reception du signal avec bruit
y_CRRC_bruit_filt = filter(h_CRRC_adapte, 1, y_CRRC_bruit);
y_CRRC_bruit_filt = y_CRRC_bruit_filt(Ns_CRRC*Ts+1:end);

%%Echantillonage
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
y_CRRC_bruit_filt_ech = y_CRRC_bruit_filt(1:Ts:end);
%%

%% Calcul du TEB
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
%%% Tracé TEB simulé %%%
TEB_CRRC =[];

for i= 1:length(Eb_N0)
    p = 10^(Eb_N0(i)/10);
Puissance = mean(abs(y_CRRC).^2);
var_bruit_carre = (Puissance * Ns_CRRC) / (2 * log2(M)* p);
    bruit = sqrt(var_bruit_carre) * randn(1, length(y_CRRC));
    y_CRRC_bruit = y_CRRC + bruit;
    %filtrage de reception du signal avec bruit
    h_CRRC_adapte = conj(fliplr(h_CRRC));
    y_CRRC_bruit_filt = filter(h_CRRC_adapte, 1, y_CRRC_bruit);
    y_CRRC_bruit_filt = y_CRRC_bruit_filt(Ns_CRRC*Ts+1:end);
    %Echantillonnage
    y_CRRC_bruit_filt_ech = y_CRRC_bruit_filt(1:Ts:end);
    %Détecteur à seuil & Demapping
    y_CRRC_recu = (y_CRRC_bruit_filt_ech > 0)*1.0;

    %TEB
    TEB_CRRC(i) = length(find(abs(bits_CRRC - y_CRRC_recu))) / length(bits_CRRC);
end

%Tracé TEB théorique 
TEB_theorique = [];
for i= 1:length(Eb_N0)
    p = 10^(Eb_N0(i)/10);
    TEB_theorique(i) = qfunc(sqrt(2*p));
end

%Comparaison TEB
figure();
semilogy(Eb_N0, TEB_CRRC); hold on
semilogy(Eb_N0, TEB_theorique); grid on
title("TEB theorique VS TEB simulé signal CRRC");
legend("TEB simulé", "TEB théorique");
ylabel("TEB");
xlabel("Eb/N0 (dB)");

