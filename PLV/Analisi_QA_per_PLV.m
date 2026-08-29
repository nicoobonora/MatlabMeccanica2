%% Studio del QA - biella manovella per applicazione del PLV
clc
clear all
close all

%%DATI
L1 = 20; %lunghezza del primo membro, conesso al telaio
L2 = 65; %lunghezza della biella
L3 = 65; %lunghezza del terzo membro, connesso al telaio
L4 = 80; %lunghezza del membro a telaio

%% Verifichiamo il QA in base alla formula di Grashof: in questo caso vogliamo un meccanismo biella-manovella

% - l -> lunghezza membro piu lungo (longest)
% - s -> lunghezza membro piu corto (shortest)
% - per avere un QA di Grashof, s+l<m1+m2 => s<(m1+m2)-l -> 20+80 < 130
% - per avere un QA chiudibile, s-l<m1+m2 => s>L-(m1+m2) -> 20-80 < 130
% - per avere la manovella in 1, L1 deve restare il più piccolo -> L1 = 20
% - per avere senso fisico L1>0 -> L1 = 20


%% Vari check per verificare se le lunghezze scelete vanno bene 
grashof_check(L1, L2, L3, L4)

% start:step:stop
theta1 = deg2rad(0:1:360); % -> vettore di 361 elementi [0, ..., 360]
[m,n]=size(theta1); % m = 1, n = 361

% ---------------- analisi di posizione

for i=1:n
    [theta2_up(i), theta3_up(i)] = position_analysis_byth1(theta1(i),L1,L2,L3,L4,true);
    [theta2_down(i), theta3_down(i)] = position_analysis_byth1(theta1(i),L1,L2,L3,L4,false);
end


% ---------------- analisi di velocità

%supponiamo w1 = 10 rmp. In gradi al secondo diventa
%w1 = 360*rpm/60

rpm = 10;

for i=1:n
    th_dot1(i) = (2*pi*rpm)/60; % rad/s
end

for i=1:n
    [th_dot2(i), th_dot3(i)] = velocity_analysis_by_th1(th_dot1(i), theta1(i), theta2_up(i), theta3_up(i), L1,L2,L3);
end


% --------------- analisi di accelerazione
%supponiamo che il membro 1 ruoti a velocità costante
for i=1:n
    th_ddot1 (i) = 0; % rad/s
end

for i=1:n
    [th_ddot2(i), th_ddot3(i)] = acceleration_analysis_by_th1(th_ddot1 (i), th_dot1(i), th_dot2(i), th_dot3(i), theta1(i), theta2_up(i), theta3_up(i), L1,L2,L3,L4);
end


%calcolo rapporto di trasmissione ingresso/uscita
for i=1:n
    t_31(i) = th_dot3(i)/th_dot1 (i);
end

% grafico i risultati
figure
% posizione
subplot(3,2,1)
hold on
grid minor
plot(theta1,theta2_up,'b')
xlabel('th_1')
ylabel('th_2')
xlim([theta1(1) theta1(n)]);

subplot(3,2,2)
hold on
grid minor
plot(theta1,theta3_up,'r')
xlabel('th_1')
ylabel('th_3')
xlim([theta1(1) theta1(n)]);

% velocità
subplot(3,2,3)
hold on
grid minor
plot(theta1,th_dot2,'b')
xlim([theta1(1) theta1(n)]);
xlabel('th_1')
ylabel('th_2 dot')
xL = xlim;
line(xL, [0 0],'Color','k');  %y-axis

subplot(3,2,4)
hold on
grid minor
plot(theta1,th_dot3,'r')
xlim([theta1(1) theta1(n)]);
xlabel('th_1')
ylabel('th_3 dot')
xL = xlim;
line(xL, [0 0],'Color','k');  %y-axis

%accelerazione
subplot(3,2,5)
hold on
grid minor
plot(theta1,th_ddot2,'b')
xlim([theta1(1) theta1(n)]);
xlabel('th_1')
ylabel('th_2 ddot')
xL = xlim;
line(xL, [0 0],'Color','k');  %y-axis

subplot(3,2,6)
hold on
grid minor
plot(theta1,th_ddot3,'r')
xlim([theta1(1) theta1(n)]);
xlabel('th_1')
ylabel('th_3 ddot')
xL = xlim;
line(xL, [0 0],'Color','k');  %y-axis


% rapporto di trasmissione
figure
hold on
grid minor
plot(theta1,t_31,'r')
xlabel('th_1')
ylabel('t_{31}')
xL = xlim;
line(xL, [0 0],'Color','k');  %y-axis

figure
% FourBar_plot(L1,L2,L3,L4,L2,0,[0 0])


%% Es2
I = 2;
% PLV potenze: Mm * dtheta1 + T * dtheta3 = 0 -> Mm = -T * dtheta3 / dtheta1
Mm = - I * th_ddot3 .* th_dot3 ./ th_dot1

