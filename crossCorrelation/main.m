clear all;
clc;

[src_path, user_cance] = imgetfile();
if user_cance
    msgbox(sprintf('You should pick image'), 'Error', 'Error');
    return
end

[tmp_path, user_cance] = imgetfile();
if user_cance
    msgbox(sprintf('You should pick image'), 'Error', 'Error');
    return
end

Src = rgb2gray(imread(src_path));
Tmp = rgb2gray(imread(tmp_path));


SrcEntropy = entropyfilt(Src, true(3));
TmpEntropy = entropyfilt(Tmp, true(3));


corrOrigins = normxcorr2(Tmp, Src);
corrEntropyes = normxcorr2(TmpEntropy, SrcEntropy);


figure;
subplot(2,3,1), imshow(Src);
subplot(2,3,2), imshow(Tmp);
subplot(2,3,3), mesh(corrOrigins);
subplot(2,3,4), imshow(SrcEntropy);
subplot(2,3,5), imshow(TmpEntropy);
subplot(2,3,6), mesh(corrEntropyes);
