
function F = QA_by_9PT (X,Points)

%po1ints
OE(1) = [Points(1,1)+1i*Points(1,2)];
OE(2) = [Points(2,1)+1i*Points(2,2)];
OE(3) = [Points(3,1)+1i*Points(3,2)];
OE(4) = [Points(4,1)+1i*Points(4,2)];
OE(5) = [Points(5,1)+1i*Points(5,2)];
OE(6) = [Points(6,1)+1i*Points(6,2)];
OE(7) = [Points(7,1)+1i*Points(7,2)];
OE(8) = [Points(8,1)+1i*Points(8,2)];
OE(9) = [Points(9,1)+1i*Points(9,2)];

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

OA = [xa+1i*ya];
DO = -[xd+1i*yd];

AB_1 = L1*exp(1i*(t1(1)*pi/180));
BC_1 = L2*exp(1i*(t2(1)*pi/180));
CD_1 = L3*exp(1i*(t3(1)*pi/180));
BE_1 = Lp*exp(1i*((t2(1)+tk)*pi/180));

AB_2 = L1*exp(1i*(t1(2)*pi/180));
BC_2 = L2*exp(1i*(t2(2)*pi/180));
CD_2 = L3*exp(1i*(t3(2)*pi/180));
BE_2 = Lp*exp(1i*((t2(2)+tk)*pi/180));

AB_3 = L1*exp(1i*(t1(3)*pi/180));
BC_3 = L2*exp(1i*(t2(3)*pi/180));
CD_3 = L3*exp(1i*(t3(3)*pi/180));
BE_3 = Lp*exp(1i*((t2(3)+tk)*pi/180));

AB_4 = L1*exp(1i*(t1(4)*pi/180));
BC_4 = L2*exp(1i*(t2(4)*pi/180));
CD_4 = L3*exp(1i*(t3(4)*pi/180));
BE_4 = Lp*exp(1i*((t2(4)+tk)*pi/180));

AB_5 = L1*exp(1i*(t1(5)*pi/180));
BC_5 = L2*exp(1i*(t2(5)*pi/180));
CD_5 = L3*exp(1i*(t3(5)*pi/180));
BE_5 = Lp*exp(1i*((t2(5)+tk)*pi/180));

AB_6 = L1*exp(1i*(t1(6)*pi/180));
BC_6 = L2*exp(1i*(t2(6)*pi/180));
CD_6 = L3*exp(1i*(t3(6)*pi/180));
BE_6 = Lp*exp(1i*((t2(6)+tk)*pi/180));

AB_7 = L1*exp(1i*(t1(7)*pi/180));
BC_7 = L2*exp(1i*(t2(7)*pi/180));
CD_7 = L3*exp(1i*(t3(7)*pi/180));
BE_7 = Lp*exp(1i*((t2(7)+tk)*pi/180));

AB_8 = L1*exp(1i*(t1(8)*pi/180));
BC_8 = L2*exp(1i*(t2(8)*pi/180));
CD_8 = L3*exp(1i*(t3(8)*pi/180));
BE_8 = Lp*exp(1i*((t2(8)+tk)*pi/180));

AB_9 = L1*exp(1i*(t1(9)*pi/180));
BC_9 = L2*exp(1i*(t2(9)*pi/180));
CD_9 = L3*exp(1i*(t3(9)*pi/180));
BE_9 = Lp*exp(1i*((t2(9)+tk)*pi/180));

F(1) = real(OA + AB_1 + BC_1 + CD_1 + DO);
F(2) = imag(OA + AB_1 + BC_1 + CD_1 + DO);
F(3) = real(OA + AB_1 + BE_1 - OE(1));
F(4) = imag(OA + AB_1 + BE_1 - OE(1));

F(5) = real(OA + AB_2 + BC_2 + CD_2 + DO);
F(6) = imag(OA + AB_2 + BC_2 + CD_2 + DO);
F(7) = real(OA + AB_2 + BE_2 - OE(2));
F(8) = imag(OA + AB_2 + BE_2 - OE(2));

F(9) = real(OA + AB_3 + BC_3 + CD_3 + DO);
F(10) = imag(OA + AB_3 + BC_3 + CD_3 + DO);
F(11) = real(OA + AB_3 + BE_3 - OE(3));
F(12) = imag(OA + AB_3 + BE_3 - OE(3));

F(13) = real(OA + AB_4 + BC_4 + CD_4 + DO);
F(14) = imag(OA + AB_4 + BC_4 + CD_4 + DO);
F(15) = real(OA + AB_4 + BE_4 - OE(4));
F(16) = imag(OA + AB_4 + BE_4 - OE(4));

F(17) = real(OA + AB_5 + BC_5 + CD_5 + DO);
F(18) = imag(OA + AB_5 + BC_5 + CD_5 + DO);
F(19) = real(OA + AB_5 + BE_5 - OE(5));
F(20) = imag(OA + AB_5 + BE_5 - OE(5));

F(21) = real(OA + AB_6 + BC_6 + CD_6 + DO);
F(22) = imag(OA + AB_6 + BC_6 + CD_6 + DO);
F(23) = real(OA + AB_6 + BE_6 - OE(6));
F(24) = imag(OA + AB_6 + BE_6 - OE(6));

F(25) = real(OA + AB_7 + BC_7 + CD_7 + DO);
F(26) = imag(OA + AB_7 + BC_7 + CD_7 + DO);
F(27) = real(OA + AB_7 + BE_7 - OE(7));
F(28) = imag(OA + AB_7 + BE_7 - OE(7));

F(29) = real(OA + AB_8 + BC_8 + CD_8 + DO);
F(30) = imag(OA + AB_8 + BC_8 + CD_8 + DO);
F(31) = real(OA + AB_8 + BE_8 - OE(8));
F(32) = imag(OA + AB_8 + BE_8 - OE(8));

F(33) = real(OA + AB_9 + BC_9 + CD_9 + DO);
F(34) = imag(OA + AB_9 + BC_9 + CD_9 + DO);
F(35) = real(OA + AB_9 + BE_9 - OE(9));
F(36) = imag(OA + AB_9 + BE_9 - OE(9));
end