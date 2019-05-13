clear all;
close all;

% Durée symbole
Ts = 4;
nb_bits = 30000;
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



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
%Mapping binaire à moyenne nulle: 0->-1, 1->1
Symboles_CRRC = 2*bits_CRRC-1;



%% Suréchantillonnage de la chaine de transmission
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%

%Génération de la suite de Diracs pondérés
Suite_diracs_CRRC = kron(Symboles_CRRC, [1 zeros(1,Ts-1)]); 

%% Filtrage
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%
%réponse impulsionnelle 

h_CRRC = rcosdesign(rolloff,NS_CRRC,Ts,'sqrt');

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
p = 10^(Eb_N0(length(Eb_N0)/2)/10);
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



%% Calcul du TEB
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%