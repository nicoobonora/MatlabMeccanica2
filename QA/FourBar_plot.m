function [err] = FourBar_plot_new(R1,R2,R3,R4,cx,cy,points)

% X =   [180 100 185 220 55 0];
X = [R1  R2  R3  R4];
% r1: Crank (make sure its always the smallest, also r3+r4>=r1+r2)
% r2: Coupler
% r3: Lever (Rocker)
% r4: Frame
% cx: x coordinate for coupler point wrt crank-coupler point
% cy: y coordinate for coupler point wrt crank-coupler point

step = 200;% divide the range of motion of the main link by this number
%% check the 4Bar geometry based on Grashof formula
P = [R1,R2,R3,R4];
check = P;
% find max lenght member, then remove it from the list
[L locL] = max(check);
check(locL) = [];
% find the min lenght member, then remove it from the list
[S locS] = min(check);
check(locS) = [];

% verify the 4Bar type based on Grashof formula and the location of the shortest member and set the figure title
% accordingly
if sum(check)<(L-S) %it not possible to assemble the mechanism
    error('This is not a valid linkage');
end

if sum(check)<(L+S) %non-Grashof QA
    TITLE = 'This is a non Grashof Double-Rocker Mechanism';
    QA_rm = 0;
elseif sum(check)==(L+S) %transition among Grashof and non-Grashof
    TITLE = 'Limit case';
    QA_rm = 1;
    %--------- from here on we have Grashof QA, for which sum(check)>(L+S)
elseif (S==X(1)||S==X(3))
    TITLE = 'This is a Rocker-Crank Mechanism';
    QA_rm = 1;
elseif S==X(2)
    TITLE = 'This is a Double-Rocker Mechanism';
    QA_rm = 2;
elseif S==X(4)
    TITLE = 'This is a Double-Crank Mechanism';
    QA_rm = 1;
end
%% position analysis for the mechanism
switch QA_rm
    case 0 %non Grashof Double-Crank Mechanism
        %find the excursion of the first rocker by the Carnot th

        if (R2+R3 < R1 + R4) %
            th1_max = acos( ( R1^2+R4^2 - (R2+R3)^2)/(2*(R1*R4)) )*180/pi;
            th1_min = -th1_max;
        elseif (norm(R2-R3) < R1 + R4)
            th1_min = acos( ( R1^2+R4^2 - (R2-R3)^2)/(2*(R1*R4)) )*180/pi;
            th1_max = 360-th1_min;
        else
            error('missing case');
        end

        %build the range of interesting motion
        quarter_of_cycle1 = [th1_min:(th1_max-th1_min)/(step/4):th1_max]';
        quarter_of_cycle2 = flipud(quarter_of_cycle1);
        th1 = [quarter_of_cycle1;quarter_of_cycle2;quarter_of_cycle1;quarter_of_cycle2];

        [m,n] = size(th1);
        for i=1:m
            if i<=m/2
                [th2(i), th3(i)]= position_analysis_byth1(th1(i),X(1),X(2),X(3),X(4),true);
            else
                [th2(i), th3(i)]= position_analysis_byth1(th1(i),X(1),X(2),X(3),X(4),false);
            end
        end

    case 1
        %build the range of interesting motion

        if(X(1)<=X(3) || X(4)<X(3)) % if the first member is a crank
            th1 = [90:(360*2)/step:(90+360*2)]';

            [m,n] = size(th1);
            for i=1:m
                if i<=m/2
                    [th2(i), th3(i)]= position_analysis_byth1(th1(i),X(1),X(2),X(3),X(4),true);
                else
                    [th2(i), th3(i)]= position_analysis_byth1(th1(i),X(1),X(2),X(3),X(4),false);
                end
            end
        else % if the third member is a crank
            th3 = [90:(360*2)/step:(90+360*2)]';

            [m,n] = size(th3);
            for i=1:m
                if i<=m/2
                    [th1(i), th2(i)]= position_analysis_byth3(th3(i),X(1),X(2),X(3),X(4),true);
                else
                    [th1(i), th2(i)]= position_analysis_byth3(th3(i),X(1),X(2),X(3),X(4),false);
                end
            end
        end

    case 2
        %build the range of interesting motion
        th2 = [90:(360*2)/step:(90+360*2)]';

        [m,n] = size(th2);
        for i=1:m
            if i<=m/2
                [th1(i), th3(i)]= position_analysis_byth2(th2(i),X(1),X(2),X(3),X(4),true);
            else
                [th1(i), th3(i)]= position_analysis_byth2(th2(i),X(1),X(2),X(3),X(4),false);
            end
        end


end


%%
increments = length(th1);
for i=1:increments
    Ax(i) = R1*cosd(th1(i));% x coordinate of point A
    Ay(i) = R1*sind(th1(i));% y coordinate of point A
    
    Bx(i) = R4+R3*cosd(th3(i));% x coordinate of point B
    By(i) = R3*sind(th3(i));% y coordinate of point B
    
    Cx(i) = R1*cosd(th1(i)) + cx*cosd(th2(i)) - cy*sind(th2(i));% horizontal projection of coupler point wrt coupler
    Cy(i) = R1*sind(th1(i)) + cx*sind(th2(i)) + cy*cosd(th2(i));% vertical projection of coupler point wrt coupler
end
%calculate display (figure) limits
xmin = floor(1.2*min([min(Cx) -R1 -R3]));
xmax = ceil(1.2*max([max(Cx) R4+R3]));
ymin = floor(1.2*min([min(Cy) -R1 -R3]));
ymax = ceil(1.2*max([max(Cy) max([R1 R3 R3+cy])]));

Dx = xmax-xmin;
Dy = ymax-ymin;

if(Dx >= Dy)
    D = Dx-Dy;
    ymin = ymin - D/2;
    ymax = ymax + D/2;
else
    D = Dy-Dx;
    xmin = xmin - D/2;
    xmax = xmax + D/2;
end
%%
increments = length(th1);
for i=1:increments
    link1x(i,:) = [0,Ax(i)];
    link1y(i,:) = [0,Ay(i)];
    link2x(i,:) = [Ax(i),Bx(i)];
    link2y(i,:) = [Ay(i),By(i)];
    link3x(i,:) = [R4,Bx(i)];
    link3y(i,:) = [0,By(i)];
    Couplx1(i,:) = [Ax(i),Cx(i)];
    Couply1(i,:) = [Ay(i),Cy(i)];
    Couplx2(i,:) = [Cx(i),Bx(i)];
    Couply2(i,:) = [Cy(i),By(i)];
end

for i = 1:increments
    plot(link1x(i,:),link1y(i,:),'b',link2x(i,:),link2y(i,:),'r',...
        link3x(i,:),link3y(i,:),'k',Couplx1(i,:),Couply1(i,:),'r',...
        Couplx2(i,:),Couply2(i,:),'r')
    hold on
    axis equal
    grid on
    plot([link2x(i,:) ;Couplx1(i,:)],[link2y(i,:); Couply1(i,:)],'g','linewidth',2)
    plot([link2x(i,:) ;Couplx2(i,:)],[link2y(i,:); Couply2(i,:)],'g','linewidth',2)
    plot(0,0,'sk',R4,0,'sk','MarkerSize',12)
    plot(0,0,'ok',R4,0,'ok')
    plot(Couplx1(i,end),Couply1(i,end),'ok','MarkerSize',6,...
        'MarkerFaceColor','g')

    if i<=increments/2
        plot(Couplx1(1:i,end),Couply1(1:i,end),'*b','MarkerSize',2)
    else
        plot(Couplx1(1:increments/2,end),Couply1(1:increments/2,end),'*b','MarkerSize',2)
        plot(Couplx1(increments/2+1:i,end),Couply1(increments/2+1:i,end),'*r','MarkerSize',2)
    end
    axis([xmin xmax ymin ymax])
    plot(points(:,1),points(:,2),'Or','MarkerSize',4)
    clc
    title(['\bf',TITLE])
    fprintf('Th1 = %f, th2 = %f, th3 = %f, step = %f\n',th1(i),th2(i),th3(i),i)
    YY = input('Hit Enter    ');
    hold off
end
end