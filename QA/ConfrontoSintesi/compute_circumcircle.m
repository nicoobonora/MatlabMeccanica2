% Points deve essere matrice di 3 vettori colonna, ognuno di due elementi:
% (x,y) di ogni punti
function centre = compute_circumcircle(points)
x1 = points(1,1)
x2 = points(1,2)
x3 = points(1,3)

y1 = points(2,1)
y2 = points(2,2)
y3 = points(2,3)

common_term = 2*(x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2));
Cx = ((x1^2+y1^2)*(y2-y3)+(x2^2+y2^2)*(y3-y1)+(x3^2+y3^2)*(y1-y2))/common_term;
Cy = ((x1^2+y1^2)*(x3-x2)+(x2^2+y2^2)*(x1-x3)+(x3^2+y3^2)*(x2-x1))/common_term;

centre = [Cx;Cy];
end