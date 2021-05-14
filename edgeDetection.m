function [x, y] = edgeDetection(RGB, sigma)
% This function recieves an RGB image and a sigma value (double).
% It reads the image and detects its edges based on the given sigma.
% The function returns the x, y coordinates of the edges.
%% create binary image
    img = rgb2gray(RGB);
    img = imgaussfilt(img,sigma);
    [BW, thcanny] = edge(img,'canny');
%% improve binary image
    a = 5.5; % threshold adjustement
    BW1 = edge(img,'canny', thcanny * a);
%% get coordinates
    [y,x] = find(BW1); % find the points of the detected edges
    imgSize = size(BW1); % find the image's size
    % A4 page size
    A4x = 297;
    A4y = 210;
    scale = 1; % initial scale factor
    while((imgSize(1) > 0.8*A4y) || (imgSize(2) > (0.8*A4x - 30))) 
        % scale the image until it fits inside 80% of the page
        scale = scale + 0.5; % increase scale factor
        imgSize = size(BW1) / scale; 
    end

    % scale and reflect image so it plots properly
    % this is necessary fue to the vertical reflection of the image caused
    % by the fucntion find
    y = 200 + (-1 * y / scale);
    x = 60 +(x / scale);
end