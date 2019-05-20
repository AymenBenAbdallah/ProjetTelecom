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

%On receptionne huffMsg et dict

%Decoder image huffman
tripleDeco = huffmandeco(huffMsg,dict);
msgDeco = tripleDeco(1:2:end);
matRepet = tripleDeco(2:2:end);
%Retrouver imageDCT en vecteur
decoDCT = repelem(msgDeco,matRepet);
%Remttre le DCT dans la bonne forme
decoDCT = reshape(decoDCT,64,[]);

tailleDeco = size(decoDCT);
tailleImg = floor(sqrt(tailleDeco(1)*tailleDeco(2)));

imageDeco = zeros(tailleImg);
nbBlock = tailleDeco(2);

for i=[1:nbBlock]
    %Ouvre un block
    block = decoDCT(:,i);
    %zigzag inverse
    block = izigzag(block,8,8);
    %Quantification inverse
    block = block.*q;
    %DCT inverse
    block = idct2(block);
    %Calcul de la bonne position du block
    j = (floor((i-1)*8/tailleImg)+1);
    bascol = mod((i-1)*8,tailleImg)+1;
    hautcol = mod((i-1)*8 + 7,tailleImg)+1;
    baslin = mod((j-1)*8,tailleImg)+1;
    hautlin = mod((j-1)*8 + 7,tailleImg)+1;
    %Mise en position du block
    imageDeco(baslin:hautlin, bascol:hautcol) = block;
end

%Affiche image
imageDeco = mat2gray(imageDeco);

figure(2);
imshow(imageDeco);
title("Image JPEG");