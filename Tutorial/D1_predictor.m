% Test case(s):
% img = imread('cameraman', 'png'); imshow(img, []);
% [diff_im, entropy1, entropy2] = D1_predictor(img);

% This function takes an image, transforms it into gray image, then computes
% the first order prediction encoding of this image using the formula:
% F'(x,y) = round[ a * f(x, y-1)] , where a is of value 1.
% It returns the entropy of the image before compression as entropy1, and
% after compression as entropy2
function [diff_im, entropy1, entropy2] = D1_predictor( img )
    
    gray_im = rgb2gray(img);
    [row, col] = size(gray_im);
    diff_im = gray_im(2 : row, :) - gray_im(1:row-1, :);
    diff_im = [gray_im(1,:) ; diff_im];

    entropy1 = entropy(img);
    entropy2 = entropy(uint8(diff_im));

    figure, imhist(img), title('image histogram before compression');
    figure, imhist(diff_im), title('image histogram after compression');

end