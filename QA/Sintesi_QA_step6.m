% proviamo a semplificare il problema: gli angoli del meccanismo
% appartengono ad un sottoproblema, la chiusura del meccanismo. Proviamo
% quindi ad eseguire i calcoli internamente alla funzione obiettivo
% 
% in questo caso però, minimizziamo il problema complessivo

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

%% impostiamo la soluzione di primo tentativo del problema (l'initial guess)
DL = 10;
% geometria QA
X(1) = 0 + DL*rand;   %xa -4.81
X(2) = 0 + DL*rand;   %ya -1.35
X(3) = 130 + DL*rand; %xd 144.35
X(4) = 0 + DL*rand;   %yd 10.83
X(5) = 30 + DL*rand;  %L1 44.27	
X(6) = 90 + DL*rand;  %L2 91.29	
X(7) = 110 + DL*rand;  %L3 124.166488067079	
X(8) = 20 + DL*rand;  %Lp 8.69410524696036	
X(9) = 65 + DL*rand;  %tk 79.8904570530259

clear lb ub

%inizializzo
for i = 1:9
    lb(i)=-10000;
    ub(i)=10000;
end

%limiti geometria
lb(5) = 5;
lb(6) = 5;
lb(7) = 5;
lb(8) = 5;
lb(9) = -180;

ub(5) = 500;
ub(6) = 500;
ub(7) = 500;
ub(8) = 500;
ub(9) = 180;


%% risolvo il sistema di equazioni
options = optimset('TolFun', 1e-5);
f = @(X)QA_by_9PT_for_fmincon_noangles(X,Points);
[x,eval] = fmincon(f,X,[],[],[],[],lb,ub,[],options);

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