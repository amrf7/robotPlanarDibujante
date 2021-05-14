function Animation_ik(photo, sigma)
    %% Link length definition
    l1 = 140;                          %link 1 length
    l2 = 190;                          %link 2 length
    l3 = 35;                           %link 3 length
    %% get image coordinates
    [xm,ym] = edgeDetection(photo, sigma);
    %% figure and vector creation
    L = length(xm);
    figure(2);
    clf(figure(2));
    P = [0 297 297 0; 0 0 210 210; 0 0 0 0];

    %% Inverse kinematics
    x3 = [xm(1)];   % Find the first x position of the image coordinates
    y3 = [ym(1)];   % first y position of the image coordinates
    phi = atan2(y3(1),x3(1));   % find phi
    x2 = [x3(1)-l3*cos(phi)];   % find first x2 value
    y2 = [y3(1)-l3*sin(phi)];   % find first y2 value
    th2 = acos (((x2(1))^2+(y2(1))^2-l1^2-l2^2)/(2*l1*l2)); % find first theta2 value
    c1 = real([(l1+l2*cos(th2))*x2(1) + l2*sin(th2)*y2(1)]);  
    s1 = real([(l1+l2*cos(th2))*y2(1) - l2*sin(th2)*x2(1)]);
    th1 = atan2(c1,s1); % find first theta1 value
    th3 = phi-th2-th1;  % solve for theta 3
    x1 = [l1*cos(th1)]; % find first x1 value
    y1 = [l1*sin(th1)]; % find first y1 value


    %% Animation
    for i = 1:L-1
        % Create the dynamic vectors to be used
        x3 = [x3,xm(i+1)];      % dynamic vector of the TCP x-position
        y3 = [y3,ym(i+1)];      % dynamic vector of the TCP y-position
        %Inverse kinematics
        phi = atan(y3(i+1)/x3(i+1));   % angle from the base to the TCP
        x2 = [x2,x3(i+1)-l3*cos(phi)];  % dynamic vector of the second link's x-position
        y2 = [y2,y3(i+1)-l3*sin(phi)];  % dynamic vector of the second link's y-position
        th2 = real(acos(((x2(i+1))^2+(y2(i+1))^2-l1^2-l2^2)/(2*l1*l2)));    % Angle between link 1 and 2 
        c1 = real([c1,(l1+l2*cos(th2))*x2(i+1) + l2*sin(th2)*y2(i+1)]);     % x component of theta 1
        s1 = real([s1,(l1+l2*cos(th2))*y2(i+1) - l2*sin(th2)*x2(i+1)]);     % y component of theta 1
        th1 = atan2(s1(i+1),c1(i+1));   % Angel between link 1 and the horizontal
        x1 = [x1,l1*cos(th1)];          % dynamic vector of the first link's x-position
        y1 = [y1,l1*sin(th1)];          % dynamic vector of the first link's y-position
        th3 = phi-th2-th1;              % Angle between the third and second links
        % xy positions to generate the links 
        xs1 = [0,x1(i+1)];  % link 1 position from 0 to x1
        ys1 = [0,y1(i+1)];  % link 1 position from 0 to y1
        xs2 = [x1(i+1),x2(i+1)];    % link 2 position from x1 to x2
        ys2 = [y1(i+1),y2(i+1)];    % link 2 position from y1 to y2
        xs3 = [x2(i+1),x3(i+1)];    % link 3 position from x2 to x3
        ys3 = [y2(i+1),y3(i+1)];    % link 3 position from y2 to y2
        % reference axis definition
        S0 = SE2(x1(i+1),y1(i+1),th1+th2);  % link 1 axis
        S1 = SE2(x2(i+1),y2(i+1),phi);      % link 2 axis
        S2 = SE2(x3(i+1),y3(i+1),phi);      % link 3 axis
        % In our design, the TCP is located at S2
        cla(figure(2))     % Clear figure
        plot_poly(P, 'LineWidth', 1, 'fillcolor', 'w', 'alpha', 1); % Drawing the A4
        hold on     % Hold the figure
        %trplot(S0, 'frame', 'S0', 'color', 'k', 'thick',1) % plot link 1 axis
        %trplot(S1, 'frame', 'S1', 'color', 'k', 'thick',1) % plot link 2 axis
        %trplot(S2, 'frame', 'S2', 'color', 'k', 'thick',1) % plot link 3 axis
        scatter(x3,y3,3,'filled','k') % plot the points/pencil
        e1 = plot(xs1,ys1,'-','Color','r','LineWidth',6);     % plot link 1
        e1.Color(4) = 0.4;
        e2 = plot(xs2,ys2,'-','Color','b','LineWidth',6);     % plot link 2
        e2.Color(4) = 0.4;
        e3 = plot(xs3,ys3,'-','Color','g','LineWidth',6);     % plot link 3
        e3.Color(4) = 0.4;
        xlim([-100,300]) % x-axis limits
        axis square % make figure squared
        ylim([-100,300]) % y-axis limits
        drawnow; % required function to animate
    end
end
