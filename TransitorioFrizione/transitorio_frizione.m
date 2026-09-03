% Per i dettagli su come derivare le equazioni si vedano le dispense
% relativi agli innesti a frizione
clear all
close all
clc

% Parametri del problema
data.ws = 2*pi*(2*50)/4; % rad/s , velocità angolare di sincronismo

data.Mf = 2*0.3*500*0.15; % Nm , momento trasmesso dalla frizione durante lo slittamento

data.Cn = 40; %Nm, coppia a regime
data.wn = 90; % rad/s, vlocità angolare a regime

data.Mr0 = 35; %Nm, momento resistente ad albero fermo

data.J1 = 0.319; % kg*m^2, momento d'inerzia dell'albero motore (test: 0.08)
data.J2 = 0.105; % kg*m^2, momento d'inerzia dell'albero condotto (test: 0.04)

data.k1 = data.Cn/(data.ws-data.wn);
data.k2 = (data.Cn-data.Mr0)/data.wn;

data.e = exp(1);


% troviamo il tempo e velcità di innesto numericamente
t0 = [1];
% Reference alla funzione Tempo_innesto, definita a fondo codice
fun = @(t)Tempo_innesto(t,data);
t_inn = fsolve(fun,t0)
w_inn = data.ws - (data.Mf/data.k1)*(1-data.e^(-(data.k1/data.J1)*t_inn))



% grafichiamo il moto

%prima dell'innesto
t_slide=[0:0.01:t_inn];
[m_inn,n_inn] = size(t_slide);
for i = 1:n_inn
    w1_inn(i)=data.ws - (data.Mf/data.k1)*(1-data.e^(-(data.k1/data.J1)*t_slide(i)));
    w2_inn(i)=( (data.Mf - data.Mr0)/data.k2 )*(1-data.e^((-data.k2/data.J2)*t_slide(i)));
end


%dopo l'innesto
t = [t_inn:0.01:4];
[m,n] = size(t);
for i=1:n
    w1(i)=data.ws - (data.Mf/data.k1)*(1-data.e^(-(data.k1/data.J1)*t(i)));
    w2(i)=( (data.Mf - data.Mr0)/data.k2 )*(1-data.e^((-data.k2/data.J2)*t(i)));
    w(i) = (w_inn - data.wn)*data.e^(- (t(i)-t_inn)*(data.k1 + data.k2)/(data.J1+data.J2))  + data.wn;
end

plot(t_slide,w1_inn,'b')
hold all
grid minor
plot(t_slide,w2_inn,'r')
plot(t,w,'k')
plot(t,w1,'-.b')
plot(t,w2,'-.r')

legend ('w_1','w_2','w')
xlabel('time [s]')
ylabel('angular velocity [rad/s]')


% calcoliamo il lavoro perduto per attrito
fun2bintegrated = @(t)Lavoro_innesto(t,data);
time = 0:t_inn/100:t_inn;
for i = 1:101
    L(i) = integral(fun2bintegrated,0,time(i),'ArrayValued', true);
end
L(101)

figure
plot(time,L)
legend ('work')
xlabel('time [s]')
ylabel('L [Nm]')

% ----------------------- funzioni------------------------
function T = Tempo_innesto(t,data)
    T = data.ws - (data.Mf/data.k1)*(1-data.e^(-(data.k1/data.J1)*t)) ...
       - ((data.Mf - data.Mr0)/data.k2 )*(1-data.e^(-(data.k2/data.J2)*t));
end

function dL = Lavoro_innesto(t,data)
    W1 = data.ws - (data.Mf/data.k1)*(1-data.e^(-(data.k1/data.J1)*t));
    W2 = ((data.Mf - data.Mr0)/data.k2 )*(1-data.e^(-(data.k2/data.J2)*t));
    
    dL = data.Mf*(W1-W2);
end



