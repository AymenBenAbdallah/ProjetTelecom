clear;
close all;


%%CODAGE

%Lecture image (RVB)
image = imread('barbara.png');
%En noir et blanc
image = rgb2gray(image);

%Taille de l'image
[row col]= size(image);

%Matrice de quantification JPEG
q = [ 16 11 10 16 24 40 51 61;
     12 12 14 19 26 58 60 55;
     14 13 16 24 40 57 69 56;
     14 17 22 29 51 87 80 62; 
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];

%Affiche image
figure(1);
imshow(image);

% %Transformation image en un flux binaire
% y=de2bi(image);
% binImgPng = reshape(y.',1,size(y,1)*size(y,2));

%imageDCT = zeros(8*8,row/8*col/8);
imageDCT = [];

%Compression en JPEG
%Lis de bas en haut, de gauche a droite
for i1=[1:8:row]
    for i2=[1:8:col]
        %Division en matrice 8 par 8
        block=image(i1:i1+7,i2:i2+7);
        %DCT
        block = dct2(block);
        %Quantification qualitee 50
        block = round(block./q);
        %Lecture en zigzag
        block = zigzag(block);
        %Pb a 568
        imageDCT = [imageDCT;block];
    end
end

imageDCT = transpose(imageDCT);
imageDCT2 = imageDCT(:);

%RLE

imageRLE = rle(imageDCT2);

%Huffman

[nbVal, val] = hist(imageRLE, unique(imageRLE));
prob = nbVal./length(imageRLE);

dict = huffmandict(val,prob);
huffMsg = huffmanenco(imageRLE,dict);
