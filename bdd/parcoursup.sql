-- On supprime les fichiers téléchargés et générés s'ils existent grâce à l'option -f
-- Le script est par conséquent idempotent  
\! rm -f data.csv 
\! rm -f dico.xls
\! rm -f data1.csv

-- Téléchargement du fichier .csv dans 'data.csv'
\! wget -O data.csv "https://data.enseignementsup-recherche.gouv.fr/api/explore/v2.1/catalog/datasets/fr-esr-parcoursup/exports/csv?lang=fr&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B"
\echo >> fichier téléchargé dans data.csv 

-- Création du fichier dico.xls : 
-- On prend la première ligne du fichier seulement et on remplace les points virgules
-- on le redirige vers 'dico.xls'
-- par des retours à la ligne en incrémentant chaque numéro de ligne, puis 
\! head data.csv -n1 | tr ";" "\n" | nl -i 1 | tr "\t" ";" > dico.xls 
\echo >> création du fichier dico.xls terminée

-- Pour importer le fichier dans la table, on supprime l'en-tête et on redirige vers 'data1.csv'
\! sed 1d data.csv > data1.csv 
\echo >> en-tête supprimé, nouveau fichier data1.csv créé

-- On supprime la table si elle existe déjà 
DROP TABLE IF EXISTS import, formation, etablissement, candidature, lieu;

-- On crée la table d'importation  
CREATE TABLE import (
    n1 SMALLINT, n2 VARCHAR(40), n3 CHAR(8), n4 VARCHAR(200), n5 CHAR(3), n6 VARCHAR(30), 
    n7 VARCHAR(30), n8 VARCHAR(30), n9 VARCHAR(30), n10 TEXT, n11 CHAR(30), 
    n12 VARCHAR(20), n13 TEXT, n14 VARCHAR(100), n15 VARCHAR(200), n16 VARCHAR(300), 
    n17 CHAR(40), n18 SMALLINT, n19 SMALLINT, n20 SMALLINT, n21 SMALLINT, n22 INT, 
    n23 INT, n24 SMALLINT, n25 SMALLINT, n26 SMALLINT, n27 SMALLINT, n28 SMALLINT, 
    n29 SMALLINT, n30 SMALLINT, n31 SMALLINT, n32 SMALLINT, n33 SMALLINT, n34 SMALLINT, 
    n35 SMALLINT, n36 SMALLINT, n37 SMALLINT, n38 SMALLINT, n39 SMALLINT, n40 SMALLINT, 
    n41 SMALLINT, n42 SMALLINT, n43 SMALLINT, n44 SMALLINT, n45 SMALLINT, n46 SMALLINT, 
    n47 SMALLINT, n48 SMALLINT, n49 SMALLINT, n50 SMALLINT, n51 NUMERIC(5,1), n52 NUMERIC(5,1), 
    n53 NUMERIC(5,1), n54 SMALLINT, n55 SMALLINT, n56 SMALLINT, n57 SMALLINT, n58 SMALLINT, 
    n59 SMALLINT, n60 SMALLINT, n61 SMALLINT, n62 SMALLINT, n63 SMALLINT, n64 SMALLINT, 
    n65 SMALLINT, n66 NUMERIC(5,1), n67 SMALLINT, n68 SMALLINT, n69 SMALLINT, n70 SMALLINT, 
    n71 SMALLINT, n72 SMALLINT, n73 SMALLINT, n74 NUMERIC(4,1), n75 NUMERIC(4,1), n76 NUMERIC(4,1),
    n77 NUMERIC(4,1), n78 NUMERIC(4,1), n79 NUMERIC(4,1), n80 NUMERIC(4,1), n81 NUMERIC(4,1), 
    n82 NUMERIC(4,1), n83 NUMERIC(4,1), n84 NUMERIC(4,1), n85 NUMERIC(4,1), n86 NUMERIC(4,1), 
    n87 NUMERIC(4,1), n88 NUMERIC(4,1), n89 NUMERIC(4,1), n90 NUMERIC(4,1), n91 NUMERIC(4,1), 
    n92 NUMERIC(4,1), n93 NUMERIC(4,1), n94 NUMERIC(4,1), n95 NUMERIC(5,1), n96 NUMERIC(5,1), 
    n97 NUMERIC(5,1), n98 NUMERIC(5,1), n99 NUMERIC(5,1), n100 NUMERIC(5,1), n101 NUMERIC(5,1), 
    n102 VARCHAR(40), n103 NUMERIC(6,1), n104 CHAR(40), n105 SMALLINT, n106 CHAR(40), n107 SMALLINT, 
    n108 VARCHAR(45), n109 VARCHAR(25), n110 INT, n111 VARCHAR(100), n112 CHAR(100), n113 NUMERIC(4,1),
    n114 NUMERIC(4,1), n115 NUMERIC(4,1), n116 NUMERIC(4,1), n117 CHAR(5), n118 CHAR(5)
);
\echo >> table import créée

-- Pour se partager la table : commande à partir de la session de binôme1
-- GRANT ALL ON import TO <prenomnometu_binôme2.table>; 

-- Copier les données du fichier sans entête dans la table import
\copy import from data1.csv CSV DELIMITER ';'
\echo >> données importées dans la table import

-- Création des tables redéfinies
CREATE TABLE formation(
    code_aff_form INT, 
    filiere TEXT, 
    capacite SMALLINT, 
    taux_acces NUMERIC(4,1),
    CONSTRAINT pk_code PRIMARY KEY(code_aff_form)
);
\echo >> table formation créée 

-- Insertion des données d'import dans les colonnes correspondantes des nouvelles tables
INSERT INTO formation SELECT DISTINCT n110, n10, n18, n113 FROM import;
\echo >> données importées dans formation 

CREATE TABLE etablissement(
    code_UAI CHAR(8), 
    nom VARCHAR(200), 
    academie VARCHAR(30), 
    statut VARCHAR(40),
    CONSTRAINT pk_codeUAI PRIMARY KEY(code_UAI)
);
\echo >> table etablissement créée

INSERT INTO etablissement SELECT DISTINCT n3, n4, n8, n2 FROM import;
\echo >> données importées dans etablissement

CREATE TABLE lieu (
    code_dep CHAR(3),
    commune VARCHAR(30),
    departement VARCHAR(30),
    region VARCHAR(30),
    CONSTRAINT pk_lieu PRIMARY KEY (code_dep, commune)
);
\echo >> table lieu créée

INSERT INTO lieu SELECT DISTINCT n5, n9, n6, n7 FROM import;
\echo >> données importées dans lieu 

CREATE TABLE candidature (
    n110 INT, 
    n23 INT, 
    n25 SMALLINT, 
    n27 SMALLINT, 
    n29 SMALLINT,
    CONSTRAINT pk_candidature PRIMARY KEY (n110),
    CONSTRAINT fk_cand FOREIGN KEY (n110) REFERENCES formation(code_aff_form)
);
\echo >> table candidature créée

INSERT INTO candiature SELECT DISTINCT n110, n23, n25, n27, n29 FROM import;
\echo >> données importées dans candidature

\echo >> parcoursup.sql a été exécuté