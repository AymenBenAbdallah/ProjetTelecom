clear all;
close all;

% Durée symbole
Ts = 4;
nb_bits = 30000;
Ns_NRZ= 5;
Te_NRZ = Ts/Ns_NRZ;
Eb_N0 = 0:0.2:6;
rolloff = 0.35;



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


%% Suréchantillonnage de la chaine de transmission
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
signal_NRZ = kron(map_NRZ,ones(1,Ns_NRZ));


%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%



%% Filtrage
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%
signal_filtre_NRZ = filter(ones(1,Ts),1,signal_NRZ);


%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%



%% chaine de transmission AWGN
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%



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