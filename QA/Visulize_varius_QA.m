%% visualizzo il meccanismo
load .\solutions\QA_new_planet

%QA_01-4 7 9 11

%QA_06_approx
% QA_08_approx


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