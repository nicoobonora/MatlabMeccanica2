%% Vari check per verificare il tipo di meccanismo realizzato e la sua fisica fattibilità
function grashof_check(L1, L2, L3, L4)

check = [L1,L2,L3,L4];
% trova la massima lunghezza e rimuovila dalla lista
[L locL] = max(check);
check(locL) = [];
% trova la minima lunghezza e rimuovila dalla lista
[S locS] = min(check);
check(locS) = [];


if sum(check)<(L-S) %non è possibile assemblare il meccanismo
    error('This is not a valid linkage');
end

if sum(check)<(L+S) %non-Grashof QA
    error('This is a non Grashof Double-Rocker Mechanism');
    %---------------transizione tra Grashof e non-Grashof
elseif sum(check)==(L+S) 
    disp ('Limit case');
elseif (S==L1 || S==L3)
    if (L1<L3)
        disp ('This is a Rocker-Crank Mechanism');
    else
        error ('This is a Rocker-Crank Mechanism, but the crank is on member 3');
    end
elseif S==L2
     error ('This is a Double-Rocker Mechanism');
elseif S==L4
     error ('This is a Double-Crank Mechanism');
end