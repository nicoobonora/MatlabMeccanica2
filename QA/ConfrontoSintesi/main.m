
clc;
clear;

% Generico per 3,5,7,9 punti di biella, dati 9 punti
% Incognite: Vettori OA, AB, BC, CD, DA, OE, BE <- Che però devono sempre
% restare equidistanti in quanto corpo rigido. Inoltre AD non varia neanche
% orientamento in quanto telaio
% Noti 9 punto OE da compiere

% Per generici N punti:
% - Estraggo N punti
% - Valuto F dando per noti 9-N parametri a ogni iterazione della soluzione
% - fsolve risolve il sistema

% 9 punti
points_set = points_set_generator();

% Parametri noti da usare a seconda del numero di pose ( 6 parametri
% totali)
A = [0;1];
D = [3;2];
L1 = 2;
L2 = 3;

% Opzioni solver
options = optimoptions('fsolve', 'MaxFunctionEvaluations', 20000, 'MaxIterations', 5000);

% --- Caso 3 punti ---
tic;
X0_3 = zeros(1, 12)+1;
P_3 = points_set(1:3, :);
X3_sol = fsolve(@(X) solve_fun(X, P_3, A, D, L1, L2), X0_3, options);
time_3 = toc;

% --- Caso 5 punti ---
tic;
X0_5 = zeros(1, 20)+1; % Incognite: 9+(3x5)=24 incognite, 4x5 eq. di chiusura -> servono 4 parametri noti
P_5 = points_set(1:5, :);
% fsolve risolve un sistema nella forma F(X) = 0. F(X) è la nostra funzione
% di costo, per cui la soluzione F(X) = 0 ci darà le X (le incognite) che
% rendono 0 la funzione di costo
X5_sol = fsolve(@(X) solve_fun(X, P_5, A, D, [], []), X0_5, options);
time_5 = toc;

% --- Caso 7 punti ---
tic;
X0_7 = zeros(1, 28)+1; % Servono 2 parametri noti
P_7 = points_set(1:7, :);
X7_sol = fsolve(@(X) solve_fun(X, P_7, A, [], [], []), X0_7, options);
time_7 = toc;

% --- Caso 9 punti ---
tic;
X0_9 = zeros(1, 36)+1; % Non servono parametri noti
P_9 = points_set(1:9, :);
X9_sol = fsolve(@(X) solve_fun(X, P_9, [], [], [], []), X0_9, options);
time_9 = toc;


% ----------------------- Funzioni ------------------------
function F = solve_fun(X, points_set, A, D, L1, L2)
    [m, ~] = size(points_set); % m è il numero di punti da valutare
    
    % Ricostruisce il vettore X da passare a QA_Npt in base a quanti punti ci sono
    if m == 3    
        % 6 parametri noti
        X_full = [A(1), A(2), D(1), D(2), L1, L2, X];
    elseif m == 5
        % 4 parametri noti (posizione telaio, ad esempio)
        X_full = [A(1), A(2), D(1), D(2), X];
    elseif m == 7
        % 2 parametri noti
        X_full = [A(1), A(2), X];
    elseif m == 9
        % No parametri
        X_full = X;
    end
    
    F = QA_Npt(X_full, points_set, m);
end


% --- Geometrie a partire dai risultati trovati ---
QA_3 = [A(1), A(2), D(1), D(2), L1, L2, X3_sol];
QA_5 = [A(1), A(2), D(1), D(2), X5_sol];
QA_7 = [A(1), A(2), X7_sol];
QA_9 = X9_sol;

plot_QA_N_poses(QA_3, P_3);
plot_QA_N_poses(QA_5, P_5);
plot_QA_N_poses(QA_7, P_7);
plot_QA_N_poses(QA_9, P_9);

time_3
time_5
time_7
time_9