clear all
close all
clc

% Nel codice viene definitio il profilo della camma, noto che sia l'alzata
% e il corrispondente passo angolare, assumendo legge di moto di tipo
% cicloidale

% Ogni Hi, bethai definisce quanto una porzione bethai di rotazione della
% camma causa una variazioni di altezza Hi della punteria:
% - Primi 90 gradi -> Alzata di H1
% - 45 gradi -> Abbassa di H2 (fino ad H = 5)
% - 45 gradi -> Mantiene di H3 (Fino a 
% - 180 gradi -> rialza fino a H4

H1 = 10;
betha1 = 90;

H2 = -5;
betha2 = 45;

H3 = 0;
betha3 = 45;

H4 = -5;
betha4 = 180;

step = 0.1


%primo tratto
theta1 = 0:step:betha1; % array di 911 elementi: [0 0.1 0.2 .... 90]
[m1,n1] = size(theta1); % m1 = 1, n1 = 911


for i=1:n1
        % Legge di moto cicloidale per portare y ad H1 dopo 90 gradi
        % Useremo sempre la legge di moto cicloidale per ridurre le
        % vibrazioni, vedi pag.441 libro di Meccanica 2.
        y1(i) = H1*( (theta1(i)/betha1) - (1/(2*pi))*sin(2*pi*theta1(i)/betha1) ); % <- Y sarà tipo [0 0.2 0.5 ... 10]
end

% secondo tratto
theta2 = 0:step:betha2;
[m2,n2] = size(theta2);

for i=1:n2
        y2(i) = H1 + H2*( (theta2(i)/betha2) - (1/(2*pi))*sin(2*pi*theta2(i)/betha2) );
        theta2(i) = theta2(i)+theta1(n1);
end

% terzo tratto
theta3 = 0:step:betha3;
[m3,n3] = size(theta3);

for i=1:n3
        y3(i) = H1 + H2 + H3*( (theta3(i)/betha3) - (1/(2*pi))*sin(2*pi*theta3(i)/betha3) );
        theta3(i) = theta3(i)+theta2(n2);
end

% quarto tratto
theta4 = 0:step:betha4;
[m4,n4] = size(theta4);

for i=1:n4
        y4(i) = H1 + H2 + H3 + H4*( (theta4(i)/betha4) - (1/(2*pi))*sin(2*pi*theta4(i)/betha4) );
        theta4(i) = theta4(i)+theta3(n3);
end

% Theta = insieme di tutti gli angoli
Theta = [theta1,theta2,theta3,theta4];
% Y = insieme di tutte le posizioni
Y = [y1,y2,y3,y4];

% grafichiamo lo spostamento della punteria
figure
plot(Theta, Y)
grid on
line([theta1(n1),theta1(n1)],[min(Y),max(Y)],'Color','k')
line([theta2(n2),theta2(n2)],[min(Y),max(Y)],'Color','k')
line([theta3(n3),theta3(n3)],[min(Y),max(Y)],'Color','k')
line([theta4(n4),theta4(n4)],[min(Y),max(Y)],'Color','k')

xlabel('angular position')
ylabel('displacement')

% Disegnamo il profilo della camma
% Camma centrata
R_base = 10;
R_rotella = 8; 

[m,n] = size(Theta)

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