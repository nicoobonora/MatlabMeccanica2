%{
Completare l'esempio fornito assegnando un momento d'inerzia al bilanciere e calcolando la
corrispondente coppia inerziale per ogni posa della manovella. Calcolare quindi la coppia agente sulla
manovella per equilibrare tali coppie inerziali utilizzando il PLV. 
%}

function T = compute_inertial_momentum(I, th_ddot3)

T = I * th_ddot3;

end