%{
Considerando il glifo oscillante di figura, calcolare il rapporto di trasmissione tra la rotazione della
manovella 1 e del bilanciere 3 (tramite analisi di posizione e di velocità del meccanismo). Si scelgano
arbitrariamente le dimensioni del meccanismo, verificando che la manovella possa compiere un giro
completo
%}

% Affinchè si chiuda semplicemente L1 < l
L1 = 0.5 %m
l = 1 %m

% Dalle tre eq. di chiusura, definendo Y come il vettore delle incognite di
% posizione, Y = [sin(th3) cos(th3) s23] [3x361], scriviamo le eq di chiusura

theta1 = deg2rad(0:1:360); % -> vettore di 361 elementi [0, ..., 360]
[m,n]=size(theta1); % m = 1, n = 361mi mo

Y = [ (l+L1*sin(theta1))./sqrt(l^2 + L1^2 + 2*L1*l*sin(theta1));
      (L1*cos(theta1))./sqrt(l^2 + L1^2 + 2*L1*l*sin(theta1));
      sqrt(l^2 + L1^2 + 2*L1*l*sin(theta1)) ];

% Analisi di velocità
rpm=10;
for i=1:n
    theta1_dot(i) = (2*pi*rpm)/60
end

s23_dot = L1*l*(theta1_dot.*cos(theta1))./Y(3)

% Ricaviamo theta3 dai rispettivi seni e coseni
theta3 = atan2(Y(1, :), Y(2, :));
disp(size(theta3))
theta3_dot = L1 * theta1_dot .* (Y(3, :) .* sin(theta1) + l * cos(theta1) .* cos(theta3)) ./ (Y(3, :) .* Y(1, :));

% Rapporto di trasmissione
tau = theta3_dot ./ theta1_dot

% La componente utile della forza F è quella perpendicolare alla
% congiungente A-03. Di conseguenza è F * sin(theta3). Per PLV,
%  F * sin(theta3) * va + Mm * th1_dot = 0, dove va = theta3_dot * 03-A

% velocità del punto A
AO3 = 2 %m <- distanza in metri tra o3 e A
va = theta3_dot * AO3
Mm = 1 %N*m
F = - (Mm * theta1_dot) ./ (sin(theta3) .* theta3_dot * AO3)

% Plots
figure
plot(theta1, F)
ylim([-20, 20])