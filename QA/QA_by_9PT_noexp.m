
function F = QA_by_9PT_noexp (X,Points)

%points
OE = Points;

%assing the variable X
xa = X(1);
ya = X(2);
xd = X(3);
yd = X(4);
L1 = X(5);
L2 = X(6);
L3 = X(7);
Lp = X(8);
tk = X(9);

for j=1:9
   t1(j) = X(9+1 +(j-1)*3); 
   t2(j) = X(9+2 +(j-1)*3); 
   t3(j) = X(9+3 +(j-1)*3); 
end

OA = [xa,ya];
OD = [xd,yd];

for i=1:9
    AB(i,1:2) = [L1*cosd(t1(i)),L1*sind(t1(i))];
    BC(i,1:2) = [L2*cosd(t2(i)),L2*sind(t2(i))];
    DC(i,1:2) = [L3*cosd(t3(i)),L3*sind(t3(i))];
    BE(i,1:2) = [Lp*cosd(t2(i)+tk),Lp*sind(t2(i)+tk)];
end

for i=1:9
    F(1+4*(i-1)) = OA(1) + AB(i,1) + BC(i,1) - OD(1) - DC(i,1);
    F(2+4*(i-1)) = OA(2) + AB(i,2) + BC(i,2) - OD(2) - DC(i,2);
    F(3+4*(i-1)) = OA(1) + AB(i,1) + BE(i,1) - OE(i,1);
    F(4+4*(i-1)) = OA(2) + AB(i,2) + BE(i,2) - OE(i,2);
end

end