-- Q1. Ecrire une requête qui, à partir de import affiche le contenu de la 
-- colonne n56 et le re-calcul de celle-ci à partir d’autres colonnes de import
SELECT n56, (n47-n60) AS recalcul FROM import ;

-- Q2. Quelle requête vous permet de savoir que ce re-calcul est parfaitement exact ?


-- Q3. Ecrire une requête qui, à partir de import affiche le contenu de la colonne 
-- n74 et le re-calcul de celle-ci à partir d’autres colonnes de import
SELECT n74, ((n51/n47)*100) AS recalcul FROM import;

-- Q4. Quelle requête vous permet de savoir que ce re-calcul est parfaitement exact ?

-- Q5. Ecrire une requête qui, à partir de import affiche le contenu de la colonne n76 
-- et le re-calcul de celle-ci à partir d’autres colonnes de import. A partir de combien 
-- de décimales ces données sont exactes ?

-- Q6. Fournir la même requête sur vos tables ventilées

-- Q7. Ecrire une requête qui, à partir de import affiche la n81 et la manière de la 
-- recalculer. A partir de combien de décimales ces données sont exactes ?
SELECT n81, ((n55/n56)*100) AS recalcul FROM import;

-- Q8. Fournir la même requête sur vos tables ventilées