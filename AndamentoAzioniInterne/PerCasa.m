%{
    Realizzare un codice che calcoli le reazioni vincolari e l'andamento delle azioni interne nel caso della trave
    di figura. Si assumano valori a piacere per i moduli delle forze e delle coppie, cosiccome per la geometria
    della trave, a sezione rettangolare.

    La trave deve poter essere caricata con un numero generico di coppie flettenti e torcenti, da poter
    prescrivere ad inizio codice.

    Il codice dovrà inoltre calcolare la tensione equivalente in ogni punto della trave, utilizzando il criterio di
    resistenza di Huber – von Mises.

    Il codice dovrà inoltre produrre due grafici: uno relativo all'andamento delle azioni interne ed uno
    all'andamento della tensione equivalente.
%}



%% Variabili

% --- Parametri trave rettangolare
L = 1.5; % Lunghezza trave (metri)
h = 0.2; % Altezza sezione trave
b = 0.3; % Larghezza sezione trave

% --- Forze e rispettivi punti di applicazione
T = [0, -3, 0]'; % Forza T
P_T = [L, 0, 0]';
N = [-2, 0, 0]'; % Forza N
P_N = [L, 0, 0]';
Z = [0, 0, 0]'; % Forza lungo z (0)
P_Z = [0, 0, 0]';
F = [T, N, Z];
P_F = [P_T, P_N, P_Z];

% --- Momenti prodotti dalle forze
[m, n] = size(F)
M_e = zeros(3,n);
for i = 1:n
    M_e(:, i) = cross(P_F(:, i), F(:, i));
end

% --- Momenti flettenti e rispettivi punti di applicazione
MF1 = [0, 0, 2]';
MT1 = [1.5, 0, 0]';
P_MF1 = [L/2, 0, 0]';
P_MT1 = [L/3, 0, 0]';
M = [MF1, MT1];
P_M = [P_MF1, P_MT1];

% --- Forza e momento totale
F_tot = [0, 0, 0]';
M_tot = [0, 0, 0]';

for i=1:n
    F_tot = F_tot + F(:, i);
    M_tot = M_tot + M_e(:, i);
end

[m, n] = size(M);
for i=1:n
    M_tot = M_tot + M(:, i);
end

%% Calcolo reazioni vincolari e momenti
R_x = -N;
R_y = -T;
R_z = [0, 0, 0]';
R = [R_x, R_y, R_z];
P_R = zeros(3, 3); % <- Tutte le reaz. vinc. sono applicati a x = 0
Mr = -M_tot;


%% Calcolo andamento azioni interne
% Costruiamo una matrice di 9 righe come segue:
% 1-2-3 -> Componenti delle forze + zeri necessari
% 4-5-6 -> Punti di applicazione di forze e momenti
% 6-7-8 -> Momenti + zeri necessari
Forces = [F, R];
Moments = [M, Mr];
Points = [P_F, P_R, P_M, [0,0,0]'];
[m_forces, n_forces] = size(Forces);
[m_moments, n_moments] = size(Moments);
[m_points, n_points] = size(Points);
Zeros_for_forces = zeros(3, n_points - n_forces);
Zeros_for_moments = zeros(3, n_points - n_moments);
Unordered_actions = [Forces, Zeros_for_forces; Points; Zeros_for_moments, Moments];
Actions = sortrows(Unordered_actions', 4)';

% Algoritmo
S = []; % Array con le varie x in cui agiscono le forze
W_F = []; % Matrice 3xn con [N; Ty; Tz]
W_M = []; % Matrice 3xn con [Mt; My; Mz]

[m, n] = size(Actions);
i = 1;
j = 1;
while i<n
    
    % Spostiamo avanti i per includere le azioni che agiscono alla stessa
    % distanza x
    while (i < n-1  && Actions(4,i+1) == Actions(4,i))
        i = i+1;
    end

    % Registriamo la x corrente (che verrà usata per i plot)
    S(j)=Actions(4,i);

    % Setup delle matrici che conterranno le forze e i momenti agenti nel
    % segmento considerato
    W_F(1:3,j) = [0,0,0]'; % Risultante forze interne
    W_M(1:3,j) = [0,0,0]'; % Risultante momenti

    % Somma tutte le forze applicate dall'inizio dell'albero alla x
    % considerata (es al primo ciclo tutte le forze a x = 0) e calcola le
    % corrispettive forze e momenti interni da esercitare per equilibrare
    for k = 1:i
        W_F(1:3,j) = W_F(1:3,j) - Actions(1:3,k);
        W_M(1:3,j) = W_M(1:3,j) - cross(Actions(4:6,k)-[S(j);0;0],Actions(1:3,k)) - Actions(7:9, k);
    end

    % Il blocco sopra ha calcolato lo sforzo appena dopo la x considerata.
    % Nonostante il taglio rimanga costante fino alla prossima x
    % considerata, il momento flettente varia linearmente. Per questo ci
    % posizioniamo alla x successiva (S(J) = Actions(4, i+1)). W_M potrebbe
    % cambiare, siccome il braccio è cambiato.
    if i<=n
        j = j+1;
        S(j)=Actions(4,i+1);%ascissa
        W_F(1:3,j) = [0,0,0]'; % Risultante forze interne
        W_M(1:3,j) = [0,0,0]'; % Risultante momenti

        for k = 1:i
            W_F(1:3,j) = W_F(1:3,j) - Actions(1:3,k);
            W_M(1:3,j) = W_M(1:3,j) - cross(Actions(4:6,k)-[S(j);0;0],Actions(1:3,k)) - Actions(7:9, k);
        end        
    end

    % re-itera il ciclo
    i = i+1;
    j = j+1;

end

%% Plot azioni interne

% Sforzo normale
subplot(5,1,1)

plot(S, W_F(1,:))
grid on
box on
xlim([0 L])
ylim([-2.5 0.5])
ylabel('N')


% Taglio
subplot(5,1,2)
plot(S, W_F(2,:));
grid on
box on
xlim([0 L])
ylim([-3.5 0.5])
ylabel('T')

% Momento torcente
subplot(5,1,3)
plot(S, W_M(1,:))
grid on
box on
xlim([0 L])
ylim([-1 2])
ylabel('M_t')

% Momento flettente
subplot(5,1,4)
plot(S, W_M(3,:))
grid on
box on
xlim([0 L])
ylabel('M_f')

xlabel('x [m]')
sgtitle('Andamento delle azioni interne')


%% Calcolo tensioni equivalenti
area = b*h;

% Inerzie
Jy = h*b^3/12;
Jz = b*h^3/12;

% Formule: slide 87

% --- Tensione normale ---
% sigma_x = Sforzo normale + flessione retta da Mz
sigma_x = W_F(1, :) / area + W_M(3, :) / Jz * h/2;

% --- Tensione tangenziale ---
% Taglio dovuto al taglio:
% b(y) è costante.
% da file:///Users/nic/Downloads/Soluzione%20esame%2017_07_2024%20(2).pdf,
% per una sezione rettangolare si ha Jp.
% y è massima a y = 0.
% (caso piu generico)
tau_taglio = 6 / (b * h^3) * h^2 / 4 * W_F(2, :);

% Taglio dovuto alla torsione
% Come si calcola?? Andrebbe poi aggiunto a tau_taglio per avere tau

% Massima tensione tangenziale
sigma_eq = sqrt(sigma_x.^2 + 4*tau_taglio.^2)/1e6; % <- MPa

subplot(5,1,5)
plot(S, sigma_eq)
grid on
box on
xlim([0 L])
ylabel('sigma_eq')