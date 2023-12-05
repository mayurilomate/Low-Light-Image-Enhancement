clc;
clear all;
close all;
% Load the RGB image
I = imread('LowLight_captured.jpeg');
% Plotting original image and its histogram
figure(1);
subplot(1, 2, 1);
imshow(I);
title('Original Image');
subplot(1, 2, 2);
imhist(I);
title('Histogram of Original Image');
%%
% HE(histogram equalization) on Original image
histImg = histeq(I);
% Plotting HE image and its histogram
figure(2);
subplot(1, 2, 1);
imshow(histImg);
title('Histogram Equalisation');
subplot(1, 2, 2);
imhist(histImg);
title('Histogram of Histogram Equalisation');
% Convert the RGB image to HSV
hsvImage = rgb2hsv(I);
% Display the entire HSV image
figure(3);
subplot(2,2,1);
imshow(hsvImage);
title('HSV Image');
hChannel = hsvImage(:, :, 1); % Hue channel
subplot(2,2,2);
imshow(hChannel);
title('hChannel');
sChannel = hsvImage(:, :, 2); % Saturation channel
subplot(2,2,3);
imshow(sChannel);
title('sChannel');
vChannel = hsvImage(:, :, 3); % Brightness channel
subplot(2,2,4);
imshow(vChannel);
title('vChannel');
% Perform histogram equalization on the V channel
equalizedVChannel = histeq(vChannel);
% Create a new HSV image with the equalized V channel
equalizedHSVImage = hsvImage;
equalizedHSVImage(:, :, 3) = equalizedVChannel;
% Convert the equalized HSV image back to RGB
equalizedRGBImage = hsv2rgb(equalizedHSVImage);
figure(4);
imshow(equalizedRGBImage);
title('HE on V channel');
% Define a threshold to identify low-light areas
threshold = 0.6;
% Create a binary mask where low-light areas are 1
lowLightMask = vChannel < threshold;
% Visualize the low-light areas on the original HSV image
lowLightAreas = hsvImage;
lowLightAreas(lowLightMask) = 0; % Set low-light areas to black
% Convert the modified HSV image back to RGB for visualization
resultRGBImage = hsv2rgb(lowLightAreas);
figure(5);
imshow(lowLightAreas);
title('HSV to RGB image');
gamma = 0.4; % Increase gamma for TypeA (enhance brightness)
% Apply gamma correction to the V channel
gammaCorrectedV = vChannel.^gamma;
% Create a new HSV image with the adjusted V channel
adjustedHSVImage = hsvImage;
adjustedHSVImage(:, :, 3) = gammaCorrectedV;
% Convert the adjusted HSV image back to RGB
adjustedRGBImage_4 = hsv2rgb(adjustedHSVImage);
gamma = 0.3;
gammaCorrectedV_3 = vChannel.^gamma;
adjustedHSVImage = hsvImage;
adjustedHSVImage(:, :, 3) = gammaCorrectedV_3;
adjustedRGBImage_3 = hsv2rgb(adjustedHSVImage);
gamma = 0.5;
gammaCorrectedV_5 = vChannel.^gamma;
adjustedHSVImage = hsvImage;
adjustedHSVImage(:, :, 3) = gammaCorrectedV_5;
adjustedRGBImage_5 = hsv2rgb(adjustedHSVImage);
%%
% figure(6);
% montage({I,histImg,equalizedRGBImage,adjustedRGBImage_3,adjustedRGBImage_4,adjustedRGBImage_5},Size=[1 6],BorderSize=5,BackgroundColor="w")
figure(6);
subplot(2, 3, 1);
imshow(I);
subplot(2, 3, 2);
imshow(histImg);
subplot(2, 3, 3);
imshow(equalizedRGBImage);
subplot(2, 3, 4);
imshow(adjustedRGBImage_3);
subplot(2, 3, 5);
imshow(adjustedRGBImage_4);
subplot(2, 3, 6);
imshow(adjustedRGBImage_5);
figure(7);
subplot(2, 3, 1);
imhist(I);
subplot(2, 3, 2);
imhist(histImg);
subplot(2, 3, 3);
imhist(equalizedRGBImage);
subplot(2, 3, 4);
imhist(adjustedRGBImage_3);
subplot(2, 3, 5);
imhist(adjustedRGBImage_4);
subplot(2, 3, 6);
imhist(adjustedRGBImage_5);
%%
I_grd = imread('Bright_captured.jpeg');
I_grd = im2uint8(I_grd);
equalizedRGBImage = im2uint8(equalizedRGBImage);
adjustedRGBImage_3 = im2uint8(adjustedRGBImage_3);
adjustedRGBImage_4 = im2uint8(adjustedRGBImage_4);
adjustedRGBImage_5 = im2uint8(adjustedRGBImage_5);
%%
%Calculate SSIM
ssimVal = ssim(equalizedRGBImage,I_grd);
ssimValue_3 = ssim(adjustedRGBImage_3, I_grd);
ssimValue_4 = ssim(adjustedRGBImage_4, I_grd);
ssimValue_5 = ssim(adjustedRGBImage_5, I_grd);
fprintf('SSIM of equalized Image: %.2f\n', ssimVal);
fprintf('SSIM of 0.3 gamma: %.2f\n', ssimValue_3);
fprintf('SSIM of 0.4 gamma: %.2f\n', ssimValue_4);
fprintf('SSIM of 0.5 gamma: %.2f\n', ssimValue_5);
% Calculate PSNR
psnrVal = psnr(equalizedRGBImage,I_grd);
psnrValue_3 = psnr(adjustedRGBImage_3, I_grd);
psnrValue_4 = psnr(adjustedRGBImage_4, I_grd);
psnrValue_5 = psnr(adjustedRGBImage_5, I_grd);
fprintf('PSNR of equalized Image: %.2f\n', psnrVal);
fprintf('PSNR of 0.3 gamma: %.2f\n', psnrValue_3);
fprintf('PSNR of 0.4 gamma: %.2f\n', psnrValue_4);
fprintf('PSNR of 0.5 gamma: %.2f\n', psnrValue_5);
%%
fprintf('NIQE Score of original image: %.2f\n', niqe(I_grd));
fprintf('NIQE Score of equalized image: %.2f\n', niqe(equalizedRGBImage));
fprintf('NIQE Score of gamma corrected(0.3) image: %.2f\n', niqe(adjustedRGBImage_3));
fprintf('NIQE Score of gamma corrected(0.4) image: %.2f\n', niqe(adjustedRGBImage_4));
fprintf('NIQE Score of gamma corrected(0.5) image: %.2f\n', niqe(adjustedRGBImage_5));
