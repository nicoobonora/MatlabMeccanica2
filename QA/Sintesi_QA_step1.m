% testiamo la soluzione partendo da punti casuali e da una geometria random

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

% % geometria QA
X(1) = 0;   %xa 
X(2) = 0;   %ya
X(3) = 30*rand; %xd
X(4) = 0;   %yd
X(5) = 30*rand;  %L1
X(6) = 60*rand;  %L2
X(7) = 60*rand;  %L3
X(8) = 30*rand;  %Lp
X(9) = 30*rand;  %tk

% % angoli

for i=1:9
    t1(i) = 90;
    t2(i) = 0;
    t3(i) = 90;
end

for j=1:9
    X(9+1 +(j-1)*3) = t1(j); 
	X(9+2 +(j-1)*3) = t2(j); 
	X(9+3 +(j-1)*3) = t3(j); 
end

%% risolvo il sistema di equazioni
options = optimoptions(@fsolve,'MaxIterations',300000,'MaxFunctionEvaluations',300000,'DiffMaxChange',150)
f = @(X)QA_by_9PT_noexp(X,Points);
[x,eval] = fsolve(f,X,options);

eval

x(1:9)'

% x = X;

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