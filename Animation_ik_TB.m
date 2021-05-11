% clear all
% close all
% clc
function Animation_ik_TB(photo, sigma)
    %% Simulacion del robot usando el Toolbox de Peter Corke
    l1 = 140;
    l2 = 190;
    l3 = 35;
    d2 = 40;
    d3 = -40;

    L(1) = Link([0 0 l1 0], 'revolute'); %theta1, d1, a1, alpha1, rot
    L(2) = Link([0 d2 l2 0], 'revolute'); %theta2, d2, a2, alpha2, rot
    L(3) = Link([0 d3 l3 0], 'revolute'); %theta3, d3, a3, alpha3, rot
    R1 = SerialLink(L, 'name', 'Robot dibujante');
    q1 = [0 0 0];

    %% crear img binaria
    [xm,ym] = edgeDetection(photo, sigma);
    %% Creacion de los vectores y de la figura
    L = length(xm);
    f2 = figure('name','Drawing');
    clf(f2)
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
    th1 = (atan2(c1,s1)); %Calculamos el primer valor de theta 1
    th3 = phi-th2-th1;  %Despejamos el primer valor de theta 3
    x1 = [l1*cos(th1)]; %Calculamos el primer valor de x1
    y1 = [l1*sin(th1)]; %Calculamos el primer valor de y1


    %% Animacion
    plot_poly(P, 'LineWidth', 1, 'fillcolor', 'w', 'alpha', 1); %Ploteo de la hoja
    for i = 1:L-1
        %Creacion de los vectores dinamicos para emplearlos como funciones
        x3 = [x3,xm(i+1)];      %Vector dinamico de posicion del TCP en x
        y3 = [y3,ym(i+1)];      %Vector dinamico de posicion del TCP en y
        %Cinematica inversa
        phi = atan2(y3(i+1),x3(i+1));   %Angulo desde el origen hasta el TCP
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
        %Para el diseño de nuestro robot, el eje del TCP es el mismo que el S2
        hold all     %Reten las figuras
        q = [th1,th2,th3];
        figure(f2)
        scatter(x3,y3,3,'filled','k') %Ploteo del trazo del lapiz (linea negra) punto por punto
        R1.plot(q,'top','jointdiam',1,'jointcolor','k','linkcolor','g')
        axis square %Ejes iguales y figura en cuadrado
    end
end