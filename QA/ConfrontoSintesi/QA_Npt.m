
% Data una configurazione X che descrive completamente la geometria del
% QA, calcola l'errore (F) (come una funzione di costo) dalla geometria
% desiderata, ovvero da Points
function F = QA_Npt(X, Points, N)

% Punti (posizioni) per cui si vuol passare (rispetto all'origine)
OE = Points;

% X = Array dei parametri da testare (Coordinate del telaio, lunghezze dei
% membri, angoli di rotazione). Questi sono i parametri che dobbiamo
% trovare. Inizialmente daremo in pasto alla funzione un array X
% completamente random.
xa = X(1);
ya = X(2);
xd = X(3);
yd = X(4); % da X(1) a X(4): coordinate telaio
L1 = X(5);
L2 = X(6);
L3 = X(7);
Lp = X(8); % da X(5) a X(8): Lunghezze fisiche dei bracci
tk = X(9); % <- Angolo biella

% Calcoliamo i nuovi angoli incogniti a ogni posizione
% da X(10) a X(36): tre angoli "incogniti" di ogni posizione (27 angoli (9
% posizione)). Questi angoli vengono passati direttamente da X e poi
% assegnati a nuove variabili t_i, ognuno un vettore di 9 elementi
% contenente il proprio angolo t_i ad ogni posizione (fatto solo per
% comodità di scrittura nel prossimo loop)
for j=1:N
   t1(j) = X(9+1 +(j-1)*3); 
   t2(j) = X(9+2 +(j-1)*3); 
   t3(j) = X(9+3 +(j-1)*3); 
end

% Definiamo i vettori posizione degli estremi del telaio
OA = [xa,ya];
OD = [xd,yd];

% Sulla base della X passata vengono elaborati i vettori in ogni posizione
for i=1:N
    AB(i,1:2) = [L1*cosd(t1(i)),L1*sind(t1(i))];
    BC(i,1:2) = [L2*cosd(t2(i)),L2*sind(t2(i))];
    DC(i,1:2) = [L3*cosd(t3(i)),L3*sind(t3(i))];
    BE(i,1:2) = [Lp*cosd(t2(i)+tk),Lp*sind(t2(i)+tk)];
end

% F contiene l'errore della configurazione X passata rispetto al risultato
% atteso (rispetto ad ogni punto OE che avrebbe dovuto coprire il QA).
% F avrà 36 elementi, 4*9, in cui primo, secondo, terzo e quarto elemento
% di ogno blocco da 4 sarà l'errore x, y in termini cinematici e in termini
% di traiettoria
for i=1:N
    % Scarto cinematico x, vale a dire: se la punta della biella (tratto OA
    % -> AB -> BC) non coincide con la punta del bilanciere (tratto OD ->
    % DC) allora signiffica che il meccanismo non è chiuso
    F(1+4*(i-1)) = OA(1) + AB(i,1) + BC(i,1) - OD(1) - DC(i,1);
    % Scarto cinematico y
    F(2+4*(i-1)) = OA(2) + AB(i,2) + BC(i,2) - OD(2) - DC(i,2);
    % Scarto di traiettoria x, vale a dire quanto il punto E della biella è
    % effettivamente distante (sulle x) dal punto e desiderato
    F(3+4*(i-1)) = OA(1) + AB(i,1) + BE(i,1) - OE(i,1);
    % Come il precedente ma sulle y
    F(4+4*(i-1)) = OA(2) + AB(i,2) + BE(i,2) - OE(i,2);
end

end