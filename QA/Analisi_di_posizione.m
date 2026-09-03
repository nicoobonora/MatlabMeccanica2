%% analisi di posizione del QA: Dimensione -> Movimento
clc
clear all
close all

%%DATI
X =   [16 20  14 7 ];

%possibili esempi alternativi:  X = [L1, L2, L3, L4]
% not assemblable               X =   [14 50  16 7 ];
% non Grashof Double-Rocker     X =   [14 30  16 7 ];
% Limit case    X =   [15 20  15 20];
% Double-Crank  X =   [16 20  14 7];
% Rocker-Crank  X =   [7 20  14 16]; X =   [14 20  7 16];
% Double-Rocker X =   [ 14 7 16 20];

L1 = X(1); %lunghezza del primo membro, conesso al telaio
L2 = X(2); %lunghezza della biella
L3 = X(3); %lunghezza del terzo membro, connesso al telaio
L4 = X(4); %lunghezza del membro a telaio

% %---------ANALISI PARAMETRICA QA
% %per avere un QA di Grashof, s+l<m1+m2 => s<(m1+m2)-l
% %per avere un QA chiudibile, s-l<m1+m2 => s>L-(m1+m2)
% %per avere la manovella in 1, L1 deve restare il più piccolo
% %per avere senso fisico L1 >0


%% Verifichiamo il QA in base alla formula di Grashof

check = [L1,L2,L3,L4];
% trova la massima lunghezza e rimuovila dalla lista
[L locL] = max(check);
check(locL) = [];
% trova la minima lunghezza e rimuovila dalla lista
[S locS] = min(check);
check(locS) = [];


if sum(check)<(L-S) %non è possibile assemblare il meccanismo
    error('This is not a valid linkage');
end
NG = false;
if sum(check)<(L+S) %non-Grashof QA
    disp('This is a non Grashof Double-Rocker Mechanism');
    NG = true;
    %---------------transizione tra Grashof e non-Grashof
elseif sum(check)==(L+S)
    disp ('Limit case');
elseif (S==L1|S==L3)
    disp ('This is a Rocker-Crank Mechanism');
elseif S==L2
    disp ('This is a Double-Rocker Mechanism');
elseif S==L4
    disp ('This is a Double-Crank Mechanism');
end

%% stabilisto il passo di analisi
theta = -180:1:180;
[m,n]=size(theta);

if NG == true % non-Grashof QA
    if (L2+L3 < L1 + L4) %
        th1_max = acos( ( L1^2+L4^2 - (L2+L3)^2)/(2*(L1*L4)) )*180/pi;
        th1_min = -th1_max;
    else
        th1_min = acos( ( L1^2+L4^2 - (L2-L3)^2)/(2*(L1*L4)) )*180/pi;
        th1_max = 360-th1_min;
    end

    clear theta;
    theta = th1_min:(th1_max-th1_min)/360:th1_max;

    theta1_up = theta;
    theta1_down = theta;

    [m,n]=size(theta1_up);

    for i=1:n
        [theta2_up(i), theta3_up(i)] = position_analysis_byth1(theta(i),L1,L2,L3,L4,true);
        [theta2_down(i), theta3_down(i)] = position_analysis_byth1(theta(i),L1,L2,L3,L4,false);
    end
else %Grashof QA
    if S == L1 || S==L4 %il primo membro compie rotazioni complete
        theta1_up = theta;
        theta1_down = theta;
        for i=1:n
            [theta2_up(i), theta3_up(i)] = position_analysis_byth1(theta(i),L1,L2,L3,L4,true);
            [theta2_down(i), theta3_down(i)] = position_analysis_byth1(theta(i),L1,L2,L3,L4,false);
        end
    elseif S == L3 % il terzo membro compie rotazioni complete
        theta3_up = theta;
        theta3_down = theta;
        for i=1:n
            [theta1_up(i), theta2_up(i)] = position_analysis_byth3(theta(i),L1,L2,L3,L4,true);
            [theta1_down(i), theta2_down(i)] = position_analysis_byth3(theta(i),L1,L2,L3,L4,false);
        end
    else % la biella compie rotazioni complete
        theta2_up = theta;
        theta2_down = theta;
        for i=1:n
            [theta1_up(i), theta3_up(i)] = position_analysis_byth2(theta(i),L1,L2,L3,L4,true);
            [theta1_down(i), theta3_down(i)] = position_analysis_byth2(theta(i),L1,L2,L3,L4,false);
        end
    end
end

% Analisi di velocità
rpm = 10;

for i=1:n
    th_dot1(i) = (2*pi*rpm)/60; % rad/s
end

for i=1:n
    [th_dot2(i), th_dot3(i)] = velocity_analysis_by_th1(th_dot1(i), theta1_up(i), theta2_up(i), theta3_up(i), L1,L2,L3);
end

hold on
grid minor

plot(theta1_up,theta3_up,'*b')
plot(theta1_down,theta3_down,'*r')
xlabel('theta_1')
ylabel('theta_3')

xL = xlim;
yL = ylim;
line([0 0], yL,'Color','k');  %x-axis
line(xL, [0 0],'Color','k');  %y-axis

legend('first solution','second solution')

hold off

figure;
plot(theta1_up, th_dot2);
plot(theta1_up, th_dot3);