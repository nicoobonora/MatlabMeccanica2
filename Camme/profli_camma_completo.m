clear all
close all
clc
%{
Completare l'esempio fornito, generalizzando il codice ad un numero generico di tratti da specificare
all'inizio del calcolo. Definire le funzioni per le leggi di moto parabolico, polinomiale di grado quinto e
cicloidale e rendere il tipo di moto selezionabile all'inizio del codice per ogni tratto. Infine, aggiungere il
calcolo e il grafico dell'angolo di spinta per la camma con punteria centrata ed eccentrica.
%}

% Nel codice viene definitio il profilo della camma, noto che sia l'alzata
% e il corrispondente passo angolare, assumendo legge di moto di tipo
% cicloidale

% Ogni Hi, bethai definisce quanto una porzione bethai di rotazione della
% camma causa una variazioni di altezza Hi della punteria:
% - Primi 90 gradi -> Alzata di H1
% - 45 gradi -> Abbassa di H2 (fino ad H = 5)
% - 45 gradi -> Mantiene di H3 (Fino a 
% - 180 gradi -> rialza fino a H4

% Struttura tratti: matrice 3xn con ogni colonna avente beta gradi,
% corrispettiva H e funzione scelta.

Tratti = [ 90, 45, 45, 180; ...
            10, -5, 0, -5 ];

Functions = ["ci", "poli", "para", "ci"];

% n = numero di tratti
[m, n] = size(Tratti);
step = 0.1;

starting_point = 0;
h_tot = 0;
Theta = [];
Y = [];

for i=1:n
    betha_i = Tratti(1, i);
    theta_i = 0:step:Tratti(1, i);
    [k, n_i] = size(theta_i);
    h_i = Tratti(2, i);
    choice_i = Functions(i);

    y_i = zeros(1, n_i);
    translated_theta_i = zeros(1, n_i);
    
    
    for j=1:n_i
        y_i(j) = h_tot + select_function(choice_i, h_i, theta_i(j), betha_i);
        translated_theta_i(j) = theta_i(j) + starting_point;
    end

    Theta = [Theta, translated_theta_i];
    Y = [Y, y_i];

    h_tot = h_tot + h_i;

    starting_point = starting_point + betha_i;
end

% Grafichiamo lo spostamento della punteria
figure
plot(Theta, Y)
grid on

c = 0;
for i=1:n
    amp = Tratti(1, i);
    line([amp, amp],[min(Y),max(Y)],'Color','k');
    c = c + amp;
end

xlabel('angular position')
ylabel('displacement')


% -------- Parte non modificata ---------


% Disegnamo il profilo della camma
% Camma centrata
R_base = 10;
R_rotella = 8; 

[m,n] = size(Theta);

for i = 1:n
    P_primitivo(i,1) = (R_base+R_rotella+Y(i))*sind(Theta(i));
    P_primitivo(i,2) = (R_base+R_rotella+Y(i))*cosd(Theta(i));
    P(i,1) = (R_base+Y(i))*sind(Theta(i));
    P(i,2) = (R_base+Y(i))*cosd(Theta(i));
end

figure
plot(P_primitivo(:,1),P_primitivo(:,2),'-.b')
hold all
plot(P(:,1),P(:,2),'b')
plot(0, 0, 'ro', 'MarkerSize', 5,'LineWidth',2);
Max = max([max(P_primitivo(:,1)),max(P_primitivo(:,2))]);
Min = min([min(P_primitivo(:,1)),min(P_primitivo(:,2))]);

viscircles([0,0], R_base,'Color','black','LineWidth',.5);

legend('profilo primitivo','profilo reale','centro di rotazione','circonferenza primitiva')

xlim([1.2*Min 1.2*Max])
ylim([1.2*Min 1.2*Max])


% Camma eccentrica
R_base = 10;
R_rotella = 8; 
e = 5;

[m,n] = size(Theta)

% Equazioni per tracciare il profilo della camma con eccentricità e (pagina
% 444)
for i = 1:n
    P_primitivo(i,1) = e*sind(Theta(i)-90) + (sqrt((R_base+R_rotella)^2 - e^2) + Y(i))*sind(Theta(i));
    P_primitivo(i,2) = e*cosd(Theta(i)-90) + (sqrt((R_base+R_rotella)^2 - e^2) + Y(i))*cosd(Theta(i));

    theta_c2c = atan2d(P_primitivo(i,2),P_primitivo(i,1));
    R = norm(P_primitivo(i,:))-R_rotella;
    P(i,1) = R*cosd(theta_c2c);
    P(i,2) = R*sind(theta_c2c);
end

figure
plot(P_primitivo(:,1),P_primitivo(:,2),'-.b')
hold all
plot(P(:,1),P(:,2),'b')
plot(0, 0, 'ro', 'MarkerSize', 5,'LineWidth',2);

Max = max([max(P_primitivo(:,1)),max(P_primitivo(:,2))]);
Min = min([min(P_primitivo(:,1)),min(P_primitivo(:,2))]);

line([e,e],[1.2*Min,1.2*Max],'Color','k')
viscircles([0,0], R_base,'Color','black','LineWidth',.5);
xlim([1.2*Min 1.2*Max])
ylim([1.2*Min 1.2*Max])
legend('profilo primitivo','profilo reale','centro di rotazione','circonferenza primitiva')


% -------- FIne parte non modificata ---------


%% Calcolo angolo di spinta punteria centrata

c = 1; % <- usato per prendere elementi di Theta e Y
[m,n] = size(Tratti);
starting_point = 0; % <- per tener conto dell'angolo assoluto a cui "piazzare" tan_alpha
for i=1:n
    
    betha_i = Tratti(1, i);
    h_i = Tratti(2, i);
    function_i = Functions(i);
    n_i = betha_i / step + 1;

    % y e y' vanno calcolati con l'angolo theta "relativo" (che riparte da
    % 0 a ogni blocco), mentre tan(alpha) per poter essere graficato ha
    % bisogno di essere indicizzato tramite l'angolo "progressivo"
    for j=1:n_i
        indx = c + j - 1 % <- Indice "globale" che serve per definire in sequenza tan_alpha
        theta_i = Theta(indx) - starting_point;
        dy = select_derivative_function(function_i, h_i, theta_i, betha_i);
        tan_alpha_cen(indx) = dy/(R_base + R_rotella + Y(indx));
        tan_alpha_ecc(indx) = (dy - e)/(sqrt((R_base+R_rotella)^2 - e^2) + Y(indx));
    end

    c = c + n_i;
    starting_point = starting_point + betha_i;
end

[m,n] = size(tan_alpha_ecc)
for i=1:n
    alpha_cen(i) = atand(tan_alpha_cen(i));
    alpha_ecc(i) = atand(tan_alpha_ecc(i));
end

% Plot
figure;
plot(Theta, alpha_cen);
hold on;
plot(Theta, alpha_ecc);
legend("Centrata", "Eccentrica")
hold off;