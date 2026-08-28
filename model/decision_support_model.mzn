% --- 1. CONFIGURATION ---
int: n_guests = 76; 
int: n_invited = 66; 
int: n_tables = 9; 

set of int: GUESTS = 1..n_guests;
set of int: ALL_TABLES = 0..n_tables;
set of int: INVITED_TABLES = 1..n_tables;

% Table Capacities: T1 (2 seats: ONLY BRIDE & GROOM), T2-T8 (8 seats), T9 (14 seats)
% T9 is larger to accommodate the remainder of large houses (like the 11 Starks).
array[INVITED_TABLES] of int: table_capacities = [2, 8, 8, 8, 8, 8, 8, 8, 8];

% --- 2. DATA ---
array[GUESTS] of string: guest_names = ["Walder Frey", "Tommen Baratheon", "Valarr Targaryen", "Joffrey Baratheon", "Margaery Tyrell", "Robb Stark", "Stannis Baratheon", "Samwell Tarly", "Baelor Targaryen (son of Daeron II)", "Euron Greyjoy", "Cregan Stark", "Edmyn Tully", "Arya Stark", "Aurane Waters", "Bran Stark", "Cersei Lannister", "Doran Martell", "Gerold Hightower", "Janos Slynt", "Jorah Mormont", "Lancel Lannister", "Lyanna Stark", "Mace Tyrell", "Melisandre", "Merrett Frey", "Myrcella Baratheon", "Nymeria Sand", "Oberyn Martell", "Orys Baratheon", "Otto Hightower", "Pycelle", "Quentyn Martell", "Ramsay Snow", "Randyll Tarly", "Aeron Greyjoy", "Asha Greyjoy", "Balon Greyjoy", "Benjen Stark", "Brynden Rivers", "Brynden Tully", "Corlys Velaryon", "Criston Cole", "Daemon Targaryen", "Daenerys Targaryen", "Eddard Stark", "Edmure Tully", "Gregor Clegane", "Illyrio Mopatis", "Jaime Lannister", "Jon Arryn", "Jon Snow", "Kevan Lannister", "Mance Rayder", "Roose Bolton", "Renly Baratheon", "Theon Greyjoy", "Sansa Stark", "Tywin Lannister", "Steffon Baratheon", "Petyr Baelish", "Viserys Targaryen", "Varys", "Victarion Greyjoy", "Tyrion Lannister", "Tyland Lannister", "Sandor Clegane", "Jeor Mormont", "Qyburn", "Rickon Stark", "Arianne Martell", "Brandon Stark", "Rhaegar Targaryen", "Drogo", "Loras Tyrell", "Luwin", "Robert Baratheon"];
array[GUESTS] of string: guest_house = ["House Frey", "House Baratheon", "House Targaryen", "House Baratheon", "House Tyrell", "House Stark", "House Baratheon", "Night's Watch", "House Targaryen", "House Greyjoy", "House Stark", "House Tully", "House Stark", "House Velaryon", "House Stark", "House Lannister", "House Martell", "House Hightower", "Night's Watch", "House Mormont", "House Lannister", "House Stark", "House Tyrell", "Other", "House Frey", "House Baratheon", "House Martell", "House Martell", "House Baratheon", "House Hightower", "House Lannister", "House Martell", "House Bolton", "House Tarly", "House Greyjoy", "House Greyjoy", "House Greyjoy", "House Stark", "House Targaryen", "House Tully", "House Velaryon", "House Cole", "House Targaryen", "House Targaryen", "House Stark", "House Tully", "House Clegane", "House Targaryen", "House Lannister", "House Arryn", "House Stark", "House Lannister", "Other", "House Bolton", "House Baratheon", "House Greyjoy", "House Stark", "House Lannister", "House Baratheon", "House Baelish", "House Targaryen", "Other", "House Greyjoy", "House Lannister", "House Lannister", "House Clegane", "House Mormont", "House Lannister", "House Stark", "House Martell", "House Stark", "House Targaryen", "Dothraki", "House Tyrell", "House Stark", "House Baratheon"];

% --- 3. VARIABLES ---
array[GUESTS] of var ALL_TABLES: assigned_table;
var bool: marry_margaery; % If true, bride is Margaery; if false, bride is Sansa

% --- 4. HARD CONSTRAINTS ---
include "count.mzn";

% Physical constraints
constraint forall(t in INVITED_TABLES)(count(assigned_table, t) <= table_capacities[t]);
constraint count(assigned_table, 0) = n_guests - n_invited;

% TABLE 1: RESERVED EXCLUSIVELY FOR THE COUPLE
constraint assigned_table[4] = 1; % Joffrey
constraint if marry_margaery then assigned_table[5] = 1 else assigned_table[57] = 1 endif; % Chosen Bride
constraint count(assigned_table, 1) = 2; % Ensure only 2 people at Table 1

% TABLE 2: GROOM'S PARENTS & IMMEDIATE FAMILY
% Robert (76), Cersei (16), Tommen (2), Myrcella (26), Tywin (58)
constraint assigned_table[76] = 2 /\ assigned_table[16] = 2 /\ assigned_table[2] = 2 /\ assigned_table[26] = 2 /\ assigned_table[58] = 2;

% TABLE 3: BRIDE'S PARENTS & IMMEDIATE FAMILY
constraint if marry_margaery then 
              assigned_table[23] = 3 /\ assigned_table[74] = 3 % Mace & Loras Tyrell
           else 
              assigned_table[45] = 3 /\ assigned_table[6] = 3 /\ assigned_table[13] = 3 % Ned, Robb & Arya Stark
           endif;

% MANDATORY INVITATIONS: All members of the Bride and Groom's houses must attend
constraint forall(i in GUESTS)(
    (guest_house[i] == "House Baratheon" \/ guest_house[i] == "House Lannister") -> assigned_table[i] > 0
);
constraint if marry_margaery then
    forall(i in GUESTS)(guest_house[i] == "House Tyrell" -> assigned_table[i] > 0)
else
    forall(i in GUESTS)(guest_house[i] == "House Stark" -> assigned_table[i] > 0)
endif;

% Mandatory House Heads invitation
set of int: HOUSE_HEADS = {1, 17, 23, 37, 45, 58, 76};
constraint forall(h in HOUSE_HEADS)(assigned_table[h] > 0);

% --- 5. ENEMY LOGIC (DISSENSION) ---
% Pairs of characters that should NOT sit at the same table
array[int, 1..2] of int: enemies = [|
    45, 58 | % Ned Stark vs Tywin Lannister
    13, 1  | % Arya Stark vs Walder Frey
    47, 66 | % Gregor Clegane vs Sandor Clegane
    7, 76  | % Stannis Baratheon vs Robert Baratheon
    60, 57 | % Petyr Baelish vs Sansa Stark
    4, 64  | % Joffrey Baratheon vs Tyrion Lannister
    1, 6     % Walder Frey vs Robb Stark
|];

% --- 6. OPTIMIZATION ---

% Total Happiness: Bonus for grouping members of the same house (+100 per pair)
var int: total_happiness = sum(i, j in GUESTS where i < j)(
    if assigned_table[i] != 0 /\ assigned_table[i] == assigned_table[j] /\ guest_house[i] == guest_house[j] then 100 else 0 endif
);

% Enemy Penalty: Massive penalty if enemies share a table
var int: enemy_penalty = sum(k in 1..7)(
    if assigned_table[enemies[k,1]] != 0 /\ assigned_table[enemies[k,1]] == assigned_table[enemies[k,2]] then -10000 else 0 endif
);

solve maximize total_happiness + enemy_penalty;

% --- 7. OUTPUT ---
output [
    "\n*** ROYAL WEDDING PLAN: TABLE 1 COUPLE ONLY ***\n",
    "Bride chosen: " ++ (if fix(marry_margaery) then "MARGAERY TYRELL" else "SANSA STARK" endif) ++ "\n",
    "TOTAL HAPPINESS SCORE: " ++ show(total_happiness) ++ "\n",
    "Enemy Penalties (0 is perfect): " ++ show(enemy_penalty) ++ "\n"
] ++ [
    "Table " ++ show(t) ++ " (" ++ show(count(i in GUESTS)(fix(assigned_table[i]) == t)) ++ " guests): " ++ 
    join(", ", [guest_names[i] | i in GUESTS where fix(assigned_table[i]) == t]) ++ "\n"
    | t in INVITED_TABLES
] ++ [
    "\nNOT INVITED: " ++ join(", ", [guest_names[i] | i in GUESTS where fix(assigned_table[i]) == 0]) ++ "\n"
];
