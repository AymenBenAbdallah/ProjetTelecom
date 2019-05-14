clear;
jpeg;

%Matrice de quantification JPEG
q = [ 16 11 10 16 24 40 51 61;
     12 12 14 19 26 58 60 55;
     14 13 16 24 40 57 69 56;
     14 17 22 29 51 87 80 62; 
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];

%On receptionne huffMsg et matProb et dict

%Decoder image huffman
msgDeco = huffmandeco(huffMsg,dict); 
%Retrouver imageDCT en vecteur
decoDCT = repelem(msgDeco,matProb);
%Remttre le DCT dans la bonne forme
decoDCT = reshape(decoDCT,64,[]);

imageDeco = zeros(512);
nbBlock = 4096; % Tricherie
% [~,nbBlock] = size(decoDCT);

for i=[1:nbBlock]
    block = imageDCT(:,i); % Tricherie
    %block = decoDCT(:,i);
    block = izigzag(block,8,8);
    block = block.*q;
    block = idct2(block);
    j = (floor((i-1)*8/512)+1);
    bascol = mod((i-1)*8,512)+1;
    hautcol = mod((i-1)*8 + 7,512)+1;
    baslin = mod((j-1)*8,512)+1;
    hautlin = mod((j-1)*8 + 7,512)+1;
    imageDeco(baslin:hautlin, bascol:hautcol) = block;
end

%Affiche image

imageDeco = mat2gray(imageDeco);

figure(2);
imshow(imageDeco);