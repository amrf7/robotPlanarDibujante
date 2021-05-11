function [x, y] = edgeDetection(RGB, sigma)
    %% crear img binaria
%     RGB = imread(filepath);
    img = rgb2gray(RGB);
    img = imgaussfilt(img,sigma);
    [BW, thcanny] = edge(img,'canny');
    %% procesamiento de la imagen binaria
    a = 5.5; % Modificación del threshold
    BW1 = edge(img,'canny', thcanny * a);
    %% get coordinates
    [y,x] = find(BW1); % Encuentra los puntos definidos en la imagen binaria
    imgSize = size(BW1); % Encuentra el tamaño de la imagen
    A4x = 297;
    A4y = 210;
    scale = 1;
    while((imgSize(1) > 0.8*A4y) || (imgSize(2) > (0.8*A4x - 60))) 
        % Escala la imagen hasta que esta entre en la página A4
        scale = scale + 0.5;
        imgSize = size(BW1) / scale;
    end

    % Volteamos y escalamos la imagen para que se coloque en la posición correcta
    y = 200 + (-1 * y / scale);
    x = 60 +(x / scale);
end