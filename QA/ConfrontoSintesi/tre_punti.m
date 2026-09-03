% Generatore di Qa a partire da 3 punti
% P -> Set di punti target (3 punti) [2x3]
% A,D -> coordinate del telaio (devono essere date per rendere determinato
% il problema [2x1], [2x1]
% gamma -> angoli che la biella assumerà quando toccherà ogni punto Pi
% [1x3]
% (Teoricamente 9-3=6 gradi di indeterminatezza, ma con 6 parametri (

% Algoritmo:
% Si blocca la biella nella sua prima configurazione e si osserva il moto
% relativo del  telaio. Conoscendo il punto P e il rispettivo angolo a ogni
% posizione, si trovano tre punti A1, A2, A3. Siccome la distanza AB è
% fissa (bielle rigide), il punto B sarà il circumcircle di ogni Ai. Allo
% stesso modo si determinano i  Di.
% Una volta scoperte le posizioni B e D, ho scoperto la geometria della
% biella, che userò poi per disegnare il QA

function lenghts = tre_punti(P, A, D, gamma)
    FinalA(:, 1) = A;
    FinalD(:, 1) = D;
    for i=2:3
        delta_gamma = gamma(i) - gamma(1); % <- Di quanto ha ruotato la biella
        APi = A-P(:,i); % <- Distanza tra il nuovo punto e A
        DPi = D-P(:,i); % <- Distanza tra il nuovo punto e D
        R = [cos(-delta_gamma), -sin(-delta_gamma);... % <- Matrice di rotaz.
            sin(-delta_gamma), cos(-delta_gamma)];
        rotated_APi = R * APi;
        rotated_DPi = R * DPi;
        FinalA(:, i) = P(:, 1) + rotated_APi;
        FinalD(:, i) = P(:, 1) + rotated_DPi;
    end

    % -> Calcolati A1, A2, A3; D1, D2, D3 dal SDR della biella calcolo B1, B2, B3 e C1,
    % C2, C3. Questi avranno sempre la stessa distanza, da cui trovo le
    % lunghezze (la geometria) del QA

    B = compute_circumcircle(FinalA);
    C = compute_circumcircle(FinalD);

    % Lunghezze (distanze AB, BC, CD, DA)
    lenghts(1) = norm(B-A);
    lenghts(2) = norm(C-B);
    lenghts(3) = norm(D-C);
    lenghts(4) = norm(D-A);
end