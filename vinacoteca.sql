CREATE TABLE IF NOT EXISTS varietats_de_raims (
    id_raim INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS does (
    id_do INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(30),
    descripció TEXT,
    hectarees INT UNSIGNED,
    numero_viticultors INT UNSIGNED
);
CREATE TABLE IF NOT EXISTS bodegues (
    id_bodega INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_do INT UNSIGNED,
    nom VARCHAR(30),
    descripció TEXT,
    any_fundació YEAR,
    producció_anual INT UNSIGNED,
    adreca VARCHAR(100),
    telefon CHAR(9),
    lloc_web VARCHAR(50),
    CONSTRAINT FK_bodegues_do FOREIGN KEY (id_do) REFERENCES does(id_do) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS vins (
    id_vi INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_raim INT UNSIGNED,
    id_bodega INT UNSIGNED,
    nom VARCHAR(25),
    descripció TEXT,
    any_collita YEAR,
    tipus ENUM('blanc', 'negre', 'rosat', 'escumos'),
    preu_unitat DOUBLE,
    CONSTRAINT FK_vins_raim FOREIGN KEY (id_raim) REFERENCES varietats_de_raims(id_raim) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_vins_bodegues FOREIGN KEY (id_bodega) REFERENCES bodegues (id_bodega) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS vi_raims (
    id_vi INT UNSIGNED,
    id_raim INT UNSIGNED,
    PRIMARY KEY (id_vi, id_raim),
    CONSTRAINT raim_vins FOREIGN KEY (id_raim) REFERENCES varietats_de_raims(id_raim) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Fk_vi_raims FOREIGN KEY (id_vi) REFERENCES vins (id_vi) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Exercici 1: Inserir dades a les taules
INSERT INTO does (nom, descripció, hectarees, numero_viticultors)
VALUES (
        'Pla de Bages',
        'DO de la Catalunya central, terra de tines de pedra i del picapoll.',
        550,
        90
    ),
    (
        'Tarragona',
        'DO costanera al voltant del Camp de Tarragona',
        4500,
        1200
    );
-- Exercici 2: Inserir dades a les taules
INSERT INTO varietats_de_raims (nom)
VALUES ('Picapoll blanc'),
    ('Picapoll negre'),
    ('Mandó'),
    ('Malvasia'),
    ('Garnatxa roja');
-- Exercici 3: Inserir dades a les taules
/* a)
    SELECT id_do
    FROM does
    WHERE nom LIKE '%Pla%';
    */
INSERT INTO bodegues (
        nom,
        descripció,
        any_fundació,
        producció_anual,
        adreca,
        telefon,
        lloc_web,
        id_do
    )
VALUES (
        'Celler Les Tines',
        'Celler que recupera les antigues tines de pedra.',
        2008,
        35000,
        'Camí de les Tines s/n, Artés',
        '938000201',
        'www.lestines.cat',
        1
    );
/* b)
    SELECT id_do
    FROM denominacions
    WHERE nom LIKE '%Pla%';
 
    SELECT id_do
    FROM denominacions
    WHERE nom LIKE '%Tarr%'; 
 */
INSERT INTO bodegues (
        nom,
        descripció,
        any_fundació,
        producció_anual,
        adreca,
        telefon,
        lloc_web,
        id_do
    )
VALUES (
        'Celler Vinya Del Bages',
        'Cooperativa de petits viticultors del Bages.',
        1964,
        150000,
        'Carrer de la Vinya 8, Navarcles',
        938000202,
        'www.vinyadelbages.cat',
    ),
    (
        'Celler Mas del Camp',
        'Masia vitícola a tocar del mar.',
        1976,
        220000,
        'Mas del Camp, el Morell',
        977000203,
        'www.masdelcamp.cat',
    );
/* c)
   La ventaja es que podemos ejecutar la operación 
   directamente desde el script, sin necesidad de 
   guardar previamente los datos en la tabla para 
   después realizar la consulta.
*/

-- Exercici 4: Inserir dades a les taules
INSERT INTO vins (
        nom,
        descripció,
        any_collita,
        tipus,
        preu_unitat,
        id_bodega,
        id_raim
    )
VALUES (
        'Tines Picapoll',
        'Blanc fresc fermentat en tina de pedra.',
        2023,
        'blanc',
        12.90,
    ),
    (
        'Tines Mandó',
        'Negre lleuger i especiat',
        2021,
        'negre',
        16.50,
    ),
    (
        'Bages Rosat',
        'Rosat de picapoll negre.',
        2023,
        'rosat',
        9.80,
    ),
    (
        'Mas del Camp Blanc',
        'Blanc mediterrani amb notes florals',
        2022,
        'blanc',
        8.75,
    ),
    (
        'Mas del Camp Brut',
        'Escumós sec de criança curta',
        2021,
        'escumos',
        13.40,
    );
-- Exercici 5: Inserir dades a les taules
 /* INSERT INTO vi_raims (id_vi, id_raim)
VALUES (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Tines Picapoll%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Picapoll blanc%'
        )
    ),
    (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Tines Mandó%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Mandó%'
        )
    ),
    (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Tines Mandó%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Picapoll negre%'
        )
    ),
    (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Bages Rosat%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Picapoll negre%'
        )
    ),
    (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Mas del Camp Blanc%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Malvasia%'
        )
    ),
    (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Mas del Camp Blanc%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Garnatxa roja%'
        )
    ),
    (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Mas del Camp Brut%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Garnatxa roja%'
        )
    ),
    (
        (
            SELECT id_vi
            FROM vins
            WHERE nom LIKE '%Mas del Camp Brut%'
        ),
        (
            SELECT id_raim
            FROM varietats_de_raims
            WHERE nom LIKE '%Malvasia%'
        )
    ); */