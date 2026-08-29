clear all
clc

% Obiettivo: risolvere l'equazioni delle vibrazioni smorzate senza forzante
% m*ddx+c*dx+k*x = 0

% ODE45 è la funzione di matlab per risolvere eq. diff. ordinare di primo ordine non
% rigide.
% Siccome l'eq è di secondo grado, poniamo come variabile v = dx, in modo
% che l'eq diventi un sistema di eq del primo ordine:
% dx = v
% dv = -k/m * x - c/m * v

% Definiamo Y = [x, v]' il vettore di stato. Il sistema sopracitato può
% quindi essere scritto come dY = A * Y, con A matrice dipendente da k,m,c.

% Definiamo poi delle condizioni iniziali (x(0) = 0.02m e v0 = 0m/s) e un
% intervallo da considerare
tspan=[0 4];
Y0=[0.02;0];

% 
tStart = cputime;
for K = 1:100
    % In matlab si passa una funzione a una funzione tramite le '' come
    % fatto qua oppure facendo @nomefunzione. Gli argomenti vengono dati
    % dopo come argomenti opzionali (,tspan, YO). Passare direttamente
    % unforced_1dof_vib(tspan, YO) avrebbe fatto si che tale funzione
    % venisse chiamata subito.
    % Per calcolare la eq diff basta una sola iterazione (ode45 ci da gia
    % la soluzione), iteriamo 100 volte solo per poter misurare quanto ci
    % mette la CPU a calcolarlo 100 volte
    [t,Y]=ode45('unforced_1dof_vib',tspan,Y0);
end
tEnd_num = cputime - tStart

% plot
figure
subplot(2,1,1)
plot(t,Y(:,1));
legend('numerical')
grid minor
ylabel('Displacement')
title('Displacement Vs Time')


% --------------------------

% ODE45 risolveva l'equazione tramite approssimazioni date dal metodo
% Runge-Kutta. Dal momento però che conosciamo la soluzione analitica
% esatta, misuriamo il tempo che ci mette invece usando la soluzione

[nr,nc] = size(t);
tStart = cputime;
for K = 1:100

    k = 100; % N/m
    m = 1; % kg
    zeta = 0.1;
    c = 2*zeta*sqrt(m*k);
    wn = sqrt(k/m);
    wd = wn*sqrt(1-zeta^2);
    
    A = sqrt(Y0(1)^2 + ((Y0(2) + zeta*wn*Y0(1))/wd )^2 );
    Phi = atan( (Y0(2) + zeta*wn*Y0(1))/(wd*Y0(1)) );
    E = exp(1);

    for i=1:nr
        x(i)=E^(-zeta*wn*t(i))*A*cos(wd*t(i)-Phi);
    end
end


tEnd_ana = cputime - tStart


subplot(2,1,2)
plot(t,x,'r');
grid minor
legend('analytical')
xlabel('time')
ylabel('Displacement')

% Conclusioni:
% Il metodo analitico (soluzione gia nota) è estremamente piu veloce.
% ode45 -> 0.64s
% metodo analitico -> 0.02s

% Chiaramente il metodo analitico è attuabile solo quando si conosce la
% soluzione dell'equazione differenziale