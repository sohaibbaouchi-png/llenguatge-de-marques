DROP DATABASE IF EXISTS vinacoteca;
CREATE DATABASE vinacoteca;
USE vinacoteca;

CREATE TABLE DOs (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    nom                 VARCHAR(30)  NOT NULL,
    descripcio          TEXT         NOT NULL,
    hectarees           INT NOT NULL,
    numero_viticultors  INT NOT NULL
);

CREATE TABLE varietats_de_raim (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    nom  VARCHAR(50) NOT NULL
);

CREATE TABLE bodegues (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    nom               VARCHAR(30)  NOT NULL UNIQUE,
    descripcio        TEXT         NOT NULL,
    any_fundacio      YEAR         NOT NULL,
    produccio_anual   INT NOT NULL,
    adreca            VARCHAR(100) NOT NULL,
    telefon           VARCHAR(9)      NOT NULL,
    lloc_web          VARCHAR(50)  NOT NULL,
    id_do             INT,
    CONSTRAINT fk_bodega_do FOREIGN KEY (id_do)
        REFERENCES DOs (id) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE vins (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    nom           VARCHAR(25) NOT NULL,
    descripcio    TEXT        NOT NULL,
    any_collita   YEAR        NOT NULL,
    tipus         ENUM('blanc', 'negre', 'rosat', 'escumos') NOT NULL,
    preu_unitat   DOUBLE      NOT NULL,
    id_bodega     INT NOT NULL,
    id_varietat_principal INT NOT NULL,
    CONSTRAINT fk_vi_bodega FOREIGN KEY (id_bodega)
        REFERENCES bodegues (id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vi_var_prin FOREIGN KEY (id_varietat_principal)
        REFERENCES varietats_de_raim (id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE vins_varietats (
    id_vi        INT NOT NULL,
    id_varietat_de_raim  INT NOT NULL,
    PRIMARY KEY (id_vi, id_varietat_de_raim),
    CONSTRAINT fk_vv_vi FOREIGN KEY (id_vi) REFERENCES vins (id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_vv_varietat FOREIGN KEY (id_varietat_de_raim)
        REFERENCES varietats_de_raim (id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Creo les Denomacions d'origen
INSERT INTO DOs (nom,descripcio,hectarees,numero_viticultors) VALUES
('Pla de Bages',
 'DO de la Catalunya central, terra de tines de pedra i del picapoll.',
 550,90),
('Tarragona',
  'DO costanera al voltant del Camp de Tarragona.',
  4500,1200);

-- Creo les varietats de raïm
INSERT INTO varietats_de_raim (nom) VALUES
('Picapoll blanc'), 
('Picapoll negre'), 
('Mandó'),
('Malvasia'),
('Garnatxa roja');

-- Creo les bodegues
INSERT INTO bodegues (nom, 
                      descripcio,
                      any_fundacio,
                      produccio_anual, 
                      adreca, 
                      telefon, 
                      lloc_web, 
                      id_do) 
VALUES
('Celler les Tines',
 'Celler que recupera les antigues tines de pedra.',
 2008,
 35000,
 'Camí de les Tines s/n, Artés',
 '938000201',
 'www.lestines.cat',
 (SELECT id FROM DOs WHERE nom = 'Pla de Bages')),
('Celler Vinya del Bages',
 'Cooperativa de petits viticultors del Bages.',
 1964,
 150000,
 'Carrer de la Vinya 8, Navarcles',
 '938000202',
 'www.vinyadelbages.cat',
 (SELECT id FROM DOs WHERE nom = 'Pla de Bages')),
('Celler Mas del Camp',
'Masia vitícola a tocar del mar.',
 1976,
 220000,
 'Mas del Camp, el Morell',
 '977000203',
 'www.masdelcamp.cat',
 (SELECT id FROM DOs WHERE nom = 'Tarragona'));

-- Afegim els vins
INSERT INTO vins (nom, 
                  descripcio, 
                  any_collita,
                  tipus, 
                  preu_unitat,
                  id_bodega, 
                  id_varietat_principal) 
VALUES
('Tines Picapoll',
 'Blanc fresc fermentat en tina de pedra.',
 2023,
 'blanc',
 12.90,
 (SELECT id FROM bodegues WHERE nom = 'Celler les Tines'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Picapoll blanc')),
('Tines Mandó',
 'Negre lleuger i especiat.',
 2021,
 'negre',
 16.50,
 (SELECT id FROM bodegues WHERE nom = 'Celler les Tines'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Mandó')),
('Bages Rosat',
 'Rosat de picapoll negre.',
 2023,
 'rosat',
 9.80,
 (SELECT id FROM bodegues WHERE nom = 'Celler Vinya del Bages'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Picapoll negre')),
('Mas del Camp Blanc',
 'Blanc mediterrani amb notes florals.',
 2022,
 'blanc',
 8.75,
 (SELECT id FROM bodegues WHERE nom = 'Celler Mas del Camp'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Malvasia')),
('Mas del Camp Brut',
 'Escumós sec de criança curta.',
 2021,
 'escumos',
 13.40,
 (SELECT id FROM bodegues WHERE nom = 'Celler Mas del Camp'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa roja'));

-- Afegim les varietas de raïm de cada vi

INSERT INTO vins_varietats
VALUES 
((SELECT id FROM vins WHERE nom = 'Tines Picapoll'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Picapoll blanc')),
((SELECT id FROM vins WHERE nom = 'Tines Mandó'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Mandó')),
((SELECT id FROM vins WHERE nom = 'Tines Mandó'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Picapoll negre')),
((SELECT id FROM vins WHERE nom = 'Bages Rosat'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Picapoll negre')),
((SELECT id FROM vins WHERE nom = 'Mas del Camp Blanc'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Malvasia')),
((SELECT id FROM vins WHERE nom = 'Mas del Camp Blanc'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa Roja')),
((SELECT id FROM vins WHERE nom = 'Mas del Camp Brut'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa Roja')),
((SELECT id FROM vins WHERE nom = 'Mas del Camp Brut'),
 (SELECT id FROM varietats_de_raim WHERE nom = 'Malvasia'));

INSERT INTO DOs (nom, descripcio, hectarees, numero_viticultors) VALUES
('Priorat',            'DO Qualificada de terrenys de llicorella i vins negres potents.', 2000, 600),
('Montsant',           'Envolta el Priorat; vins de garnatxa i carinyena.', 1800, 700),
('Penedès',            'Zona de blancs i escumosos entre la costa i la serralada prelitoral.', 12000, 2000),
('Terra Alta',         'Referent de la garnatxa blanca, clima continental mediterrani.', 5800, 1300),
('Conca de Barberà',   'Bressol del trepat, vins rosats i negres frescos.', 4000, 800),
('Empordà',            'Vins marcats per la tramuntana i la proximitat del mar.', 1800, 300),
('Costers del Segre',  'Vinyes de secà a l''interior de Lleida.', 4000, 500),
('Alella',             'Una de les DO més petites, sòls de sauló.', 300, 60);

INSERT INTO bodegues (nom, descripcio, any_fundacio, produccio_anual, adreca, telefon, lloc_web, id_do) VALUES
('Celler Mas de la Roca','Celler familiar a les costers del Priorat.', 1998, 120000, 'Camí del Molló s/n, Gratallops', '977000101', 'www.masdelaroca.cat',
    (SELECT id FROM DOs WHERE nom = 'Priorat')),
('Celler Coma Vella',         'Petit celler d''elaboració artesanal.', 2005, 45000, 'Carrer Major 12, Porrera', '977000102', 'www.comavella.cat',
    (SELECT id FROM DOs WHERE nom = 'Priorat')),
('Celler Serra del Montsant', 'Celler situat als peus de la serra.', 1987, 300000, 'Av. Catalunya 4, Cornudella', '977000103', 'www.serramontsant.cat',
    (SELECT id FROM DOs WHERE nom = 'Montsant')),
('Cooperativa Terra Nova',    'Cooperativa agrícola centenària.', 1919, 900000, 'Plaça de l''Església 1, Gandesa', '977000104', 'www.terranova.coop',
    (SELECT id FROM DOs WHERE nom = 'Terra Alta')),
('Caves Vilanova',            'Elaboradors d''escumosos de llarga criança.', 1952, 1500000, 'Ctra. de Vilafranca km 3, Sant Sadurní', '938000105', 'www.cavesvilanova.cat',
    (SELECT id FROM DOs WHERE nom = 'Penedès')),
('Celler Can Roig',           'Projecte jove de viticultura ecològica.', 2010, 60000, 'Mas Can Roig, Subirats', '938000106', 'www.canroig.cat',
    (SELECT id FROM DOs WHERE nom = 'Penedès')),
('Celler Torre del Comte',    'Celler modernista recuperat.', 1932, 250000, 'Carrer del Celler 2, l''Espluga de Francolí', '977000107', 'www.torredelcomte.cat',
    (SELECT id FROM DOs WHERE nom = 'Conca de Barberà')),
('Mas Tramuntana',            'Vinyes en terrasses mirant al mar.', 2001, 80000, 'Veïnat de Mas Pla, Garriguella', '972000108', 'www.mastramuntana.cat',
    (SELECT id FROM DOs WHERE nom = 'Empordà')),
('Celler Riu Segre',          'Finca de secà amb varietats franceses.', 1995, 400000, 'Partida Vinyals s/n, Raimat', '973000109', 'www.riusegre.cat',
    (SELECT id FROM DOs WHERE nom = 'Costers del Segre'));

INSERT INTO varietats_de_raim (nom) VALUES
('Garnatxa negra'), ('Carinyena'), ('Ull de llebre'), ('Cabernet sauvignon'),
('Merlot'), ('Syrah'), ('Garnatxa blanca'), ('Macabeu'), ('Xarel·lo'),
('Parellada'), ('Chardonnay'), ('Trepat'), ('Moscatell'), ('Sumoll');

INSERT INTO vins (nom, descripcio, any_collita, tipus, preu_unitat, id_bodega, id_varietat_principal) VALUES
('Roca Negra',           'Negre intens amb 14 mesos de criança en bóta.', 2019, 'negre', 32.50,
    (SELECT id FROM bodegues WHERE nom = 'Celler Mas de la Roca'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Carinyena')),
('Roca Blanca',          'Blanc mineral fermentat en bóta.', 2022, 'blanc', 18.00,
    (SELECT id FROM bodegues WHERE nom = 'Celler Mas de la Roca'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa blanca')),
('Llicorella',           'Vi de vinyes velles, edició limitada.', 2018, 'negre', 45.00,
    (SELECT id FROM bodegues WHERE nom = 'Celler Mas de la Roca'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa negra')),
('Coma Vella Clos',      'Negre de finca amb criança.', 2020, 'negre', 27.90,
    (SELECT id FROM bodegues WHERE nom = 'Celler Coma Vella'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa negra')),
('Coma Vella Jove',      'Negre jove i afruitat.', 2023, 'negre', 12.50,
    (SELECT id FROM bodegues WHERE nom = 'Celler Coma Vella'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Carinyena')),
('Serra Fosca',          'Negre amb notes de fruita madura.', 2020, 'negre', 15.75,
    (SELECT id FROM bodegues WHERE nom = 'Celler Serra del Montsant'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa negra')),
('Serra Rosada',         'Rosat fresc de sagnat.', 2023, 'rosat', 9.90,
    (SELECT id FROM bodegues WHERE nom = 'Celler Serra del Montsant'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa negra')),
('Terra Nova Blanc',     'Blanc jove i aromàtic.', 2023, 'blanc', 7.50,
    (SELECT id FROM bodegues WHERE nom = 'Cooperativa Terra Nova'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa blanca')),
('Vent de Mestral',      'Blanc amb criança sobre lies.', 2021, 'blanc', 11.20,
    (SELECT id FROM bodegues WHERE nom = 'Cooperativa Terra Nova'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa blanca')),
('Vent de Garbí',        'Negre de cupatge mediterrani.', 2021, 'negre', 10.80,
    (SELECT id FROM bodegues WHERE nom = 'Cooperativa Terra Nova'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa negra')),
('Vilanova Brut Nature', 'Escumós sec de 24 mesos en rima.', 2020, 'escumos', 14.95,
    (SELECT id FROM bodegues WHERE nom = 'Caves Vilanova'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Xarel·lo')),
('Vilanova Reserva',     'Escumós de llarga criança.', 2018, 'escumos', 22.00,
    (SELECT id FROM bodegues WHERE nom = 'Caves Vilanova'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Macabeu')),
('Vilanova Rosé',        'Escumós rosat elegant.', 2021, 'escumos', 16.50,
    (SELECT id FROM bodegues WHERE nom = 'Caves Vilanova'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Trepat')),
('Can Roig Xarel·lo',    'Blanc ecològic monovarietal.', 2023, 'blanc', 9.50,
    (SELECT id FROM bodegues WHERE nom = 'Celler Can Roig'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Xarel·lo')),
('Can Roig Merlot',      'Negre suau i rodó.', 2022, 'negre', 10.25,
    (SELECT id FROM bodegues WHERE nom = 'Celler Can Roig'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Merlot')),
('Comte Trepat',         'Rosat de trepat amb notes de maduixa.', 2022, 'rosat', 11.90,
    (SELECT id FROM bodegues WHERE nom = 'Celler Torre del Comte'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Trepat')),
('Comte Negre',          'Negre amb 12 mesos de criança.', 2019, 'negre', 19.40,
    (SELECT id FROM bodegues WHERE nom = 'Celler Torre del Comte'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Ull de llebre')),
('Tramuntana Rosat',     'Rosat lleuger per a l''estiu.', 2023, 'rosat', 8.95,
    (SELECT id FROM bodegues WHERE nom = 'Mas Tramuntana'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa negra')),
('Cap de Creus',         'Negre de vinyes en terrasses.', 2020, 'negre', 24.00,
    (SELECT id FROM bodegues WHERE nom = 'Mas Tramuntana'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Carinyena')),
('Riu Segre Chardonnay', 'Blanc amb pas per bóta.', 2022, 'blanc', 13.60,
    (SELECT id FROM bodegues WHERE nom = 'Celler Riu Segre'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Chardonnay')),
('Riu Segre Cabernet',   'Negre estructurat de guarda.', 2017, 'negre', 21.30,
    (SELECT id FROM bodegues WHERE nom = 'Celler Riu Segre'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Cabernet sauvignon')),
('Llicorella',           'Vi de vinyes velles, edició limitada.', 2020, 'negre', 48.00,
    (SELECT id FROM bodegues WHERE nom = 'Celler Mas de la Roca'),
    (SELECT id FROM varietats_de_raim WHERE nom = 'Garnatxa negra'));

-- Un INSERT per vi: la subconsulta busca el vi (nom + collita, perquè hi ha
-- dos "Llicorella") i el SELECT extern retorna una fila per a cada varietat.
INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Roca Negra' AND any_collita = 2019), id
FROM varietats_de_raim WHERE nom IN ('Carinyena', 'Garnatxa negra', 'Cabernet sauvignon');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Roca Blanca' AND any_collita = 2022), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa blanca', 'Macabeu');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Llicorella' AND any_collita = 2018), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa negra', 'Carinyena');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Coma Vella Clos' AND any_collita = 2020), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa negra', 'Carinyena', 'Syrah');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Coma Vella Jove' AND any_collita = 2023), id
FROM varietats_de_raim WHERE nom IN ('Carinyena', 'Garnatxa negra');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Serra Fosca' AND any_collita = 2020), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa negra', 'Carinyena', 'Syrah');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Serra Rosada' AND any_collita = 2023), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa negra');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Terra Nova Blanc' AND any_collita = 2023), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa blanca', 'Macabeu', 'Moscatell');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Vent de Mestral' AND any_collita = 2021), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa blanca');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Vent de Garbí' AND any_collita = 2021), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa negra', 'Syrah', 'Merlot');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Vilanova Brut Nature' AND any_collita = 2020), id
FROM varietats_de_raim WHERE nom IN ('Xarel·lo', 'Macabeu', 'Parellada');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Vilanova Reserva' AND any_collita = 2018), id
FROM varietats_de_raim WHERE nom IN ('Macabeu', 'Xarel·lo', 'Parellada', 'Chardonnay');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Vilanova Rosé' AND any_collita = 2021), id
FROM varietats_de_raim WHERE nom IN ('Trepat');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Can Roig Xarel·lo' AND any_collita = 2023), id
FROM varietats_de_raim WHERE nom IN ('Xarel·lo');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Can Roig Merlot' AND any_collita = 2022), id
FROM varietats_de_raim WHERE nom IN ('Merlot');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Comte Trepat' AND any_collita = 2022), id
FROM varietats_de_raim WHERE nom IN ('Trepat');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Comte Negre' AND any_collita = 2019), id
FROM varietats_de_raim WHERE nom IN ('Ull de llebre', 'Cabernet sauvignon', 'Merlot');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Tramuntana Rosat' AND any_collita = 2023), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa negra', 'Merlot');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Cap de Creus' AND any_collita = 2020), id
FROM varietats_de_raim WHERE nom IN ('Carinyena', 'Garnatxa negra', 'Syrah');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Riu Segre Chardonnay' AND any_collita = 2022), id
FROM varietats_de_raim WHERE nom IN ('Chardonnay');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Riu Segre Cabernet' AND any_collita = 2017), id
FROM varietats_de_raim WHERE nom IN ('Cabernet sauvignon', 'Merlot');

INSERT INTO vins_varietats (id_vi, id_varietat_de_raim)
SELECT (SELECT id FROM vins WHERE nom = 'Llicorella' AND any_collita = 2020), id
FROM varietats_de_raim WHERE nom IN ('Garnatxa negra', 'Carinyena');