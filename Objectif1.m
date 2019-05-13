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

%% Filtrage
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
signal_filtre_NRZ = filter(ones(1,Ts),1,signal_NRZ);


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



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
M=2;
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
y_CRRC = filter(h_CRRC_adapte, 1, y_CRRC);
y_CRRC = y_CRRC(Ns_CRRC*Ts+1:end);
%Diagramme de l'oeil
eyediagram(y_CRRC,2*Ts,2*Ts);
title("Diagramme de l'oeil du signal SRRCF");



%% Calcul du TEB
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%