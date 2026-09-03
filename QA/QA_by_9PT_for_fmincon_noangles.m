
function Fval = QA_by_9PT_for_fmincon_noangles (X,Points)

%points
OE = Points;

%assing the variable X
xa = X(1);
ya = X(2);
xd = X(3);
yd = X(4);
L1 = X(5);
L2 = X(6);
L3 = X(7);
Lp = X(8);
tk = X(9);

%ottimizzo la distanza per ciasun punto

% sistemo gl input

L4 = norm([X(1),X(2)]-[X(3),X(4)]);
Origin = [X(1),X(2)];
frame_angle = atan2d(X(4)-X(2),X(3)-X(1));

lb = [-400];
ub = [400];
theta1 = 10; %initial guess

options = optimset('display','off');

[m,n] = size(Points);
for i=1:m
    %ottimizzatore
    f = @(theta1)closure_minimizing_initialpoint_distance(theta1,L1,L2,L3,L4,Origin,frame_angle,Lp,tk,Points(i,:),true);
    [theta1_opt_up,eval_up] = fmincon(f,theta1,[],[],[],[],lb,ub,[],options);
    f = @(theta1)closure_minimizing_initialpoint_distance(theta1,L1,L2,L3,L4,Origin,frame_angle,Lp,tk,Points(i,:),false);
    [theta1_opt1_down,eval_down] = fmincon(f,theta1,[],[],[],[],lb,ub,[],options);

    if eval_up < eval_down
        [theta2, theta3] = position_analysis_byth1(theta1_opt_up,L1,L2,L3,L4,true);
        theta1 = theta1_opt_up;
        err(i)=eval_up;
    else
        [theta2, theta3] = position_analysis_byth1(theta1_opt1_down,L1,L2,L3,L4,false);
        theta1 = theta1_opt1_down;
        err(i)=eval_up;
    end

    %salvo i risultati
    t1(i) = theta1+frame_angle; 
    t2(i) = theta2+frame_angle;
    t3(i) = theta3+frame_angle;
end


OA = [xa,ya];
OD = [xd,yd];

AB = zeros(9,2);
BC = zeros(9,2);
DC = zeros(9,2);
BE = zeros(9,2);
F = zeros(36);

for i=1:9
    AB(i,1:2) = [L1*cosd(t1(i)),L1*sind(t1(i))];
    BC(i,1:2) = [L2*cosd(t2(i)),L2*sind(t2(i))];
    DC(i,1:2) = [L3*cosd(t3(i)),L3*sind(t3(i))];
    BE(i,1:2) = [Lp*cosd(t2(i)+tk),Lp*sind(t2(i)+tk)];
end

for i=1:9
    F(1+4*(i-1)) = OA(1) + AB(i,1) + BC(i,1) - OD(1) - DC(i,1);
    F(2+4*(i-1)) = OA(2) + AB(i,2) + BC(i,2) - OD(2) - DC(i,2);
    F(3+4*(i-1)) = OA(1) + AB(i,1) + BE(i,1) - OE(i,1);
    F(4+4*(i-1)) = OA(2) + AB(i,2) + BE(i,2) - OE(i,2);
end

FF = 0;
for j=1:36
    FF = FF + sqrt(F(j)^2);
end

Fval = FF
end