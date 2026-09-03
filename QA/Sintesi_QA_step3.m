%proviamo ad ottimizzare l'initial guess calcolando dei valori migliori per
%gli angoli 

clear all
close all
clc

%% definiamo dei punti di interesse
C = [0,35];
R1 = 25;
R2 = 10;

for i=1:9
    Points(i,1)=C(1)+R1*cosd(120*i/9);
    Points(i,2)=C(2)+R2*sind(120*i/9);
end

plot(Points(:,1),Points(:,2))


%% impostiamo la soluzione di primo tentativo del problema (l'initial guess)

% geometria QA
X(1) = 0;   %xa 
X(2) = 0;   %ya
X(3) = 130; %xd
X(4) = 0;   %yd
X(5) = 30;  %L1
X(6) = 90;  %L2
X(7) = 110; %L3
X(8) = 20;	%Lp
X(9) = 65;  %tk


% % angoli
% % data una geometria, trovo gli angoli calcolando la chiusura e cercando 
% % la posa che minimizza la disanza dai punti obiettivo


% sistemo gl input
l1 = X(5);
l2 = X(6);
l3 = X(7);
l4 = norm([X(1),X(2)]-[X(3),X(4)]);
Origin = [X(1),X(2)];
frame_angle = atan2d(X(4)-X(2),X(3)-X(1));
Lp = X(8);
tk = X(9);

% setto i limiti
lb = [-400];
ub = [400];

theta1 = 10; %initial guess

%ottimizzo la distanza per ciasun punto
[m,n] = size(Points);
for i=1:m
    %ottimizzatore
    f = @(theta1)closure_minimizing_initialpoint_distance(theta1,l1,l2,l3,l4,Origin,frame_angle,Lp,tk,Points(i,:),true);
    [theta1_opt_up,eval_up] = fmincon(f,theta1,[],[],[],[],lb,ub);
    f = @(theta1)closure_minimizing_initialpoint_distance(theta1,l1,l2,l3,l4,Origin,frame_angle,Lp,tk,Points(i,:),false);
    [theta1_opt1_down,eval_down] = fmincon(f,theta1,[],[],[],[],lb,ub);

    if eval_up < eval_down
        [theta2, theta3] = position_analysis_byth1(theta1_opt_up,l1,l2,l3,l4,true);
        theta1 = theta1_opt_up;
        err(i)=eval_up;
    else
        [theta2, theta3] = position_analysis_byth1(theta1_opt1_down,l1,l2,l3,l4,false);
        theta1 = theta1_opt1_down;
        err(i)=eval_up;
    end

    %salvo i risultati
    t1(i) = theta1+frame_angle; 
    t2(i) = theta2+frame_angle;
    t3(i) = theta3+frame_angle;
end

for j=1:9
    X(9+1 +(j-1)*3) = t1(j); 
	X(9+2 +(j-1)*3) = t2(j); 
	X(9+3 +(j-1)*3) = t3(j); 
end

%% risolvo il sistema di equazioni
options = optimoptions(@fsolve,'MaxIterations',5000,'MaxFunctionEvaluations',5000,'DiffMaxChange',150)
f = @(X)QA_by_9PT_noexp(X,Points);
[x,eval] = fsolve(f,X,options);

eval

x(1:9)'



%% visualizzo il meccanismo

% per semplicità, riposizione e rioriento il sistema di riferimento in modo
% che l'origine sia in A e che l'asse x coincida con il quarto membro

%trovo la matrice di rotazione per centrare il QA

v = [x(3),x(4)]-[x(1),x(2)];
v = v/norm(v);

R = [v(1),-v(2),x(1);
    v(2), v(1),x(2);
    0,0,1];
R = inv(R);

d = R* [x(3),x(4),1]'

% trasformo i punti nel nuovo riferimento
Points(:,3)=1;
Rotated_points = R*Points';


%plotto
R1 = norm(x(5)); 
R2 = norm(x(6)); 
R3 = norm(x(7)); 
R4 = norm(d(1)); 
Cu = norm(x(8))*cosd(x(9)); 
Cv = norm(x(8))*sind(x(9)); 

FourBar_plot(R1,R2,R3,R4,Cu,Cv,Rotated_points')