% 3 Punti di biella (definiscono una circonferenza)
% 3 Posizioni desiderate: BC, B'C', B''C''
B_1 = [1, 3]';
B_2 = [2, 5]';
B_3 = [4, 4]';

B = [B_1, B_2, B_3];

L = 5;

% Creiamo tre lati a caso equidistanti
C = generate_random_c(B, L);

% Troviamo il "circumcerchio", ovvero il centro di una circonferenza che
% unisce tre punti
A = compute_circumcircle(B);
D = compute_circumcircle(C);

FourBarPlotter(A, D, B, C)


% Generico per 3,5,7,9 punti di biella, dati 9 punti
% Incognite: Vettori OA, AB, BC, CD, DA, OE, BE <- Che però devono sempre
% restare equidistanti in quanto corpo rigido. Inoltre AD non varia neanche
% orientamento in quanto telaio
% Noti 9 punto OE da compiere