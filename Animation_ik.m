% close all 
% clear all
% clc
function Animation_ik(photo, sigma)
    %% Valores de longitud y rotacion nula inicial de los elementos
    l1 = 140;                          %longitud del eslabon 1
    l2 = 190;                          %longitud del eslabon 2
    l3 = 35;                           %longitud del eslabon 3

    %% 
    %% crear img binaria
    [xm,ym] = edgeDetection(photo, sigma);
    %% Creacion de los vectores y de la figura
    L = length(xm);
    f1 = figure('name','Drawing');
    P = [0 297 297 0; 0 0 210 210; 0 0 0 0];

    %% Cinematica inversa
    x3 = [xm(1)];   %Comenzamos la cinematica inversa con la primer posicion en x del vector generado por la imagen
    y3 = [ym(1)];   %Lo mismo pero con la primer posicion en y
    phi = atan2(y3(1),x3(1));   %Calculamos el primer valor de phi
    x2 = [x3(1)-l3*cos(phi)];   %Calculamos el primer valor de x2
    y2 = [y3(1)-l3*sin(phi)];   %Calculamos el primer valor de y2
    th2 = acos (((x2(1))^2+(y2(1))^2-l1^2-l2^2)/(2*l1*l2)); %Calculamos el primer valor de theta 2
    c1 = real([(l1+l2*cos(th2))*x2(1) + l2*sin(th2)*y2(1)]);  
    s1 = real([(l1+l2*cos(th2))*y2(1) - l2*sin(th2)*x2(1)]);
    th1 = atan2(c1,s1); %Calculamos el primer valor de theta 1
    th3 = phi-th2-th1;  %Despejamos el primer valor de theta 3
    x1 = [l1*cos(th1)]; %Calculamos el primer valor de x1
    y1 = [l1*sin(th1)]; %Calculamos el primer valor de y1


    %% Animacion
    for i = 1:L-1
        %Creacion de los vectores dinamicos para emplearlos como funciones
        x3 = [x3,xm(i+1)];      %Vector dinamico de posicion del TCP en x
        y3 = [y3,ym(i+1)];      %Vector dinamico de posicion del TCP en y
        %Cinematica inversa
        phi = atan(y3(i+1)/x3(i+1));   %Angulo desde el origen hasta el TCP
        x2 = [x2,x3(i+1)-l3*cos(phi)];  %Vector dinamico de posicion final en x del segundo eslabon 
        y2 = [y2,y3(i+1)-l3*sin(phi)];  %Vector dinamico de posicion final en y del segundo eslabon 
        th2 = real(acos(((x2(i+1))^2+(y2(i+1))^2-l1^2-l2^2)/(2*l1*l2)));    %Angulo entre el estabon 2 y en eje del primero
        c1 = real([c1,(l1+l2*cos(th2))*x2(i+1) + l2*sin(th2)*y2(i+1)]);     %Componente en x de theta 1
        s1 = real([s1,(l1+l2*cos(th2))*y2(i+1) - l2*sin(th2)*x2(i+1)]);     %Componente en y de theta 1
        th1 = atan2(s1(i+1),c1(i+1));   %Angulo que se genera entre el estabon 1 y la horizontal
        x1 = [x1,l1*cos(th1)];          %Vector dinamido de posicion final en x del primer eslabon
        y1 = [y1,l1*sin(th1)];          %Vector dinamico de posicion final en y del primer eslabon
        th3 = phi-th2-th1;              %Angulo que se genera entre el tercer eslabo con el eje del segundo
        %Posiciones en x y desde para generar los eslabones
        xs1 = [0,x1(i+1)];  %Posiciones del eslabon 1 desde 0 hasta x1
        ys1 = [0,y1(i+1)];  %Posiciones del eslabon 1 desde 0 hasta y1
        xs2 = [x1(i+1),x2(i+1)];    %Posiciones del eslabon 1 desde x1 hasta x2
        ys2 = [y1(i+1),y2(i+1)];    %Posiciones del eslabon 1 desde y1 hasta y2
        xs3 = [x2(i+1),x3(i+1)];    %Posiciones del eslabon 1 desde x2 hasta x3
        ys3 = [y2(i+1),y3(i+1)];    %Posiciones del eslabon 1 desde y2 hasta y3
        %Creacion del eje de refencia
        S0 = SE2(x1(i+1),y1(i+1),th1+th2);  %Eje de referencia al final del eslabon 1
        S1 = SE2(x2(i+1),y2(i+1),phi);      %Eje de referencia al final del eslabon 2
        S2 = SE2(x3(i+1),y3(i+1),phi);      %Eje de referencia al final del eslabon 3
        %Para el diseño de nuestro robot, el eje del TCP es el mismo que el S2
        clf(f1)     %Limpiar la figura
        plot_poly(P, 'LineWidth', 1, 'fillcolor', 'w', 'alpha', 1); %Ploteo de la hoja
        hold on     %Reten las figuras
        %trplot(S0, 'frame', 'S0', 'color', 'k', 'thick',1) %Ploteo del eje de referencia S0
        %trplot(S1, 'frame', 'S1', 'color', 'k', 'thick',1) %Ploteo del eje de referencia S1
        %trplot(S2, 'frame', 'S2', 'color', 'k', 'thick',1) %Ploteo del eje de referencia S2
        scatter(x3,y3,3,'filled','k') %Ploteo del trazo del lapiz (linea negra)
        e1 = plot(xs1,ys1,'-','Color','r','LineWidth',6);     %ploteo eslabon 1
        e1.Color(4) = 0.4;
        e2 = plot(xs2,ys2,'-','Color','b','LineWidth',6);     %ploteo eslabon 2
        e2.Color(4) = 0.4;
        e3 = plot(xs3,ys3,'-','Color','g','LineWidth',6);     %ploteo eslabon 3
        e3.Color(4) = 0.4;
        xlim([-100,300]) %Limites del eje x
        axis square %Ejes iguales y figura en cuadrado
        ylim([-100,300]) %Limites del eje y
        drawnow; %Funcion necesaria para la animacion
    end
end
