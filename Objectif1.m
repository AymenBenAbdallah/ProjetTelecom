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
bits = randi([0,1],1,nb_bits);



%% Mapping du code binaire
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%


%% Suréchantillonnage de la chaine de transmission
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%        CRRC        %
%%%%%%%%%%%%%%%%%%%%%%



%% Filtrage
%%%%%%%%%%%%%%%%%%%%%%
%       NRZ          %
%%%%%%%%%%%%%%%%%%%%%%



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