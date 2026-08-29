% Definiamo la funzione che calcola effettivamente dY

function dY = unforced_1dof_vib(t,Y)

k = 100; % N/m
m = 1; % kg
zeta = 0.1;
c = 2*zeta*sqrt(m*k); % Ns/m

% Definizione di dY = A * Y. Y(2) è il secondo elementi del vettore Y,
% ovvero v.
dY = [Y(2);(-((c/m)*Y(2))-((k/m)*Y(1)))]; 


% A = [   0       1
%     -(k/m) -(c/m)];
% 
% dY = M*Y;
