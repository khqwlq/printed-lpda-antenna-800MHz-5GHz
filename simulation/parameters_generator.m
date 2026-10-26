

%% 1. PARAMÈTRES PHYSIQUES ET DU SUBSTRAT 
c = 299792458;             % Vitesse de la lumière dans le vide (m/s)
H_sub = 1.6;               % Épaisseur du substrat FR4 (mm)
eps_r = 4.3;               % Permittivité relative du FR4
w_boom = 2.4;              % Largeur du boom / ligne d'alimentation (mm)
feed_gap = 1.5;            % Écart d'alimentation (mm)
cu_thick = 0.035;          % Épaisseur de métallisation cuivre (mm)

% Permittivité effective du substrat (Modèle microruban)
eps_eff = (eps_r + 1)/2 + ((eps_r - 1)/2) * (1 / sqrt(1 + 12*(H_sub/w_boom)));

%%
% Longueurs totales L_i (mm)
L = [115.11, 101.30, 89.14, 78.44, 69.03, 60.75, 53.46, 47.04, ...
     41.40,  36.43,  32.06, 28.21, 24.83, 21.85, 19.23, 16.92];

% Espacements R_i entre éléments successifs (mm)
R = [34.53, 30.39, 26.74, 23.53, 20.71, 18.22, 16.04, 14.11, ...
     12.42, 10.93,  9.62,  8.46,  7.45,  6.55,  5.77];

N = length(L);

%% 3. CALCUL DES PARAMÈTRES DÉRIVÉS
% Largeurs des pistes W_i = L_i * 0.025 (mm)
W = L * 0.025;

% Diamètre filaire équivalent du plus petit élément (\emptyset_n \approx W_16 / 2)
diam_eq_shortest = W(N) / 2;

% Positions Y cumulées des dipôles (mm)
Y_pos = zeros(1, N);
for i = 2:N
    Y_pos(i) = Y_pos(i-1) + R(i-1);
end

% Facteurs géométriques tau, sigma et angle alpha (Formules Cebik / Carrel)
tau_array = L(2:end) ./ L(1:end-1);
sigma_array = R ./ (2 * L(1:end-1));

tau_moyen = mean(tau_array);
sigma_moyen = mean(sigma_array);
sigma_opt = 0.243 * tau_moyen - 0.051; % Formule empirique Cebik

% Angle d'ouverture cot(alpha) = 4 * sigma / (1 - tau)
cot_alpha = (4 * sigma_moyen) / (1 - tau_moyen);
alpha_deg = atan(1 / cot_alpha) * (180 / pi);

% Fréquences de résonance théoriques (Vide vs FR4)
f_air = (c ./ (2 * (L * 1e-3))) * 1e-6;              % Fréquences en MHz (Air)
f_fr4 = (c ./ (2 * (L * 1e-3) * sqrt(eps_eff))) * 1e-6;    % Fréquences en MHz (FR4)

%% 4. AFFICHAGE DES PARAMÈTRES D'ENTRÉE (INPUTS) ET DE SYNTHÈSE
fprintf('===============================================================\n');
fprintf('       PARAMÈTRES EXTRAITS DU CODE VBA (LPDA IMPRIMÉE FR4)\n');
fprintf('===============================================================\n');
fprintf('Fréquence basse estimée (f_1 sur FR4)    : %.1f MHz\n', min(f_fr4));
fprintf('Fréquence haute estimée (f_n sur FR4)    : %.1f MHz\n', max(f_fr4));
fprintf('Largeur piste plus petit élément (W_16)  : %.3f mm\n', W(N));
fprintf('Diamètre équivalent plus petit élément    : %.3f mm\n', diam_eq_shortest);
fprintf('Impédance caractéristique cible (Zc_in)  : 50 Ohm\n');
fprintf('---------------------------------------------------------------\n');
fprintf('Facteur d''échelle géométrique (tau)     : %.3f\n', tau_moyen);
fprintf('Facteur d''espacement réel (sigma)        : %.3f\n', sigma_moyen);
fprintf('Facteur d''espacement optimal (sigma_opt) : %.3f\n', sigma_opt);
fprintf('Angle de demi-ouverture (alpha)          : %.2f degres\n', alpha_deg);
fprintf('Permittivité effective substrat (eps_eff): %.3f\n', eps_eff);
fprintf('===============================================================\n\n');

%% 5. TABLEAU DÉTAILLÉ PAR ÉLÉMENT POUR LE RAPPORT
T = table((1:N)', L', W', [R, 0]', Y_pos', f_air', f_fr4', ...
    'VariableNames', {'Element', 'L_mm', 'W_mm', 'R_mm', 'Pos_Y_mm', 'f_Res_Air_MHz', 'f_Res_FR4_MHz'});
disp(T);