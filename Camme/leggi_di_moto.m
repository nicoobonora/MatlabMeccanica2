clear all
close all
clc

% Confronto fra leggi di moto a parità di spostamento.
% Obiettivo: simuliamo lo stesso movimento (rotazione camma di 90 gradi ->
% alzata di +10) sfruttando tre possibili leggi di moto differenti
% (nell'esempio del profilo di camma abbiamo usato la
% cicloidale)

H = 10;
betha = 90;
step = 0.1

theta = 0:step:betha;
[m,n] = size(theta);


% moto parabolico
for i=1:n
    if(i<=n/2)
        yp(i) = 2*H*(theta(i)/betha)^2;
        vp(i) = 4*H*(theta(i)/betha);
        ap(i) = 4*H;
    else
        yp(i) = H*(1 -2*(1-(theta(i)/betha))^2);
        vp(i) = H*4*(1-(theta(i)/betha));
        ap(i) = -H*4;
    end
end



% polinomiale di quinto grado
for i=1:n
        y5(i) = H*( 10*(theta(i)/betha)^3 - 15*(theta(i)/betha)^4 + 6*(theta(i)/betha)^5);
        v5(i) = H*( 30*(theta(i)/betha)^2 - 60*(theta(i)/betha)^3 + 30*(theta(i)/betha)^4 );
        a5(i) = H*( 60*(theta(i)/betha)  - 180*(theta(i)/betha)^2 + 120*(theta(i)/betha)^3 );
end


%cicloidale
for i=1:n
        yc(i) = H*( (theta(i)/betha) - (1/(2*pi))*sin(2*pi*theta(i)/betha) );
        vc(i) = H*( 1 - cos(2*pi*theta(i)/betha) );
        ac(i) = H*( 2*pi*sin(2*pi*theta(i)/betha) );
end

figure
subplot(3,1,1)
plot(theta, yp)
hold all
grid minor
plot(theta, y5)
plot(theta, yc)
ylabel('position')
legend('y_p','y_5','y_c')

subplot(3,1,2)
plot(theta, vp)
hold all
grid minor
plot(theta, v5)
plot(theta, vc)
ylabel('velocity')
legend('v_p','v_5','v_c')

subplot(3,1,3)
plot(theta, ap)
hold all
grid minor
plot(theta, a5)
plot(theta, ac)
xlabel('angular position')
ylabel('acceleration')
legend('a_p','a_5','a_c')


% Conclusioni:
% Si nota come polinomiale di quinto grado e cicloidale garantiscano una
% accelerazione più bassa e decisamente piu fluida rispetto alla
% parabolica, oltre al fatto che parte e finisce a 0. Non presentando
% quindi salti o grossi cambiamenti istantanei, le forze d'inerzia sono
% ridotte "al minimo" e non sono presenti urti