function plot_QA_N_poses(X_full, Points)
    [N, ~] = size(Points);
    
    % 1. Estrazione parametri geometrici fissi
    xa = X_full(1); ya = X_full(2); xd = X_full(3); yd = X_full(4);
    L1 = X_full(5); L2 = X_full(6); L3 = X_full(7); Lp = X_full(8); tk = X_full(9);
    
    A = [xa; ya];
    D = [xd; yd];
    
    % Inizializzazione figura
    figure('Name', sprintf('Sintesi QA - %d Pose', N), 'Color', 'w');
    hold on; axis equal; grid on;
    
    % Disegna il telaio fisso e i punti target
    plot(Points(:,1), Points(:,2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    plot([xa, xd], [ya, yd], 'ks--', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'k');
    
    % Tavolozza colori per distinguere le N pose
    colori = lines(N); 
    
    % 2. Ciclo per disegnare il meccanismo in ogni posa
    for i = 1:N
        % Indice base per estrarre la tripletta di angoli della posa corrente
        idx = 9 + (i-1)*3;
        t1 = X_full(idx + 1);
        t2 = X_full(idx + 2);
        t3 = X_full(idx + 3);
        
        % Calcolo delle coordinate dei perni in questa specifica posa
        B = A + [L1*cosd(t1); L1*sind(t1)];
        C = D + [L3*cosd(t3); L3*sind(t3)]; 
        E = B + [Lp*cosd(t2 + tk); Lp*sind(t2 + tk)];
        
        % Disegno delle aste (Manovella, Biella, Bilanciere)
        plot([A(1), B(1), C(1), D(1)], [A(2), B(2), C(2), D(2)], '-o', ...
            'Color', colori(i,:), 'LineWidth', 1.5, 'MarkerFaceColor', 'w');
        
        % Disegno della forma triangolare della biella (B-C-E)
        plot([B(1), E(1), C(1), B(1)], [B(2), E(2), C(2), B(2)], '-', ...
            'Color', colori(i,:), 'LineWidth', 1);
            
        % Evidenzia il punto tracciante
        plot(E(1), E(2), '*', 'Color', colori(i,:), 'MarkerSize', 8);
    end
    
    title(sprintf('Quadrilatero Articolato nelle %d configurazioni calcolate', N));
end