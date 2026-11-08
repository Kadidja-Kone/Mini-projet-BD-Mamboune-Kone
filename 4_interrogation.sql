-- Mini-projet TI503N - sephoraDB
-- Fichier : 4_interrogation.sql
-- Utilisatrice : Camille, responsable marketing (campagne de fin d'annee 2026)
USE sephoraDB;

-- ==========================================
-- 1. PROJECTIONS ET SELECTIONS
-- ==========================================

-- Q1. Donnee recherchee : les parfums a plus de 80 euros, du plus cher au moins cher
-- (produits phares pour les coffrets de fin d'annee)
SELECT nom_produit, prix_produit
FROM PRODUIT
WHERE id_categorie = 2 AND prix_produit > 80
ORDER BY prix_produit DESC;

-- Q2. Donnee recherchee : les pays d'origine des marques, sans doublon
SELECT DISTINCT pays_marque
FROM MARQUE
ORDER BY pays_marque;

-- Q3. Donnee recherchee : les clients dont l'e-mail est une adresse gmail
-- (cible pour une campagne d'e-mailing)
SELECT nom_client, prenom_client, email_client
FROM CLIENT
WHERE email_client LIKE '%@gmail.com'
ORDER BY nom_client;

-- Q4. Donnee recherchee : les produits a prix intermediaire (entre 30 et 60 euros)
SELECT nom_produit, prix_produit, volume_produit
FROM PRODUIT
WHERE prix_produit BETWEEN 30 AND 60
ORDER BY prix_produit;

-- Q5. Donnee recherchee : les commandes payees par PayPal ou par virement,
-- de la plus recente a la plus ancienne
SELECT id_commande, date_commande, mode_paiement, id_client
FROM COMMANDE
WHERE mode_paiement IN ('PayPal', 'Virement')
ORDER BY date_commande DESC;

-- Q6. Donnee recherchee : les clients nes apres 1995 dont le prenom se termine par la lettre e
-- (cible jeune pour une campagne reseaux sociaux)
SELECT prenom_client, nom_client, date_naissance_client
FROM CLIENT
WHERE date_naissance_client > '1995-12-31' AND prenom_client LIKE '%e'
ORDER BY date_naissance_client;

-- ==========================================
-- 2. FONCTIONS D'AGREGATION, GROUP BY, HAVING
-- ==========================================

-- Q7. Donnee recherchee : le chiffre d'affaires de chaque annee
SELECT YEAR(c.date_commande) AS annee,
       ROUND(SUM(l.quantite * l.prix_unitaire), 2) AS chiffre_affaires
FROM COMMANDE c
JOIN LIGNE_COMMANDE l ON c.id_commande = l.id_commande
GROUP BY YEAR(c.date_commande)
ORDER BY annee;

-- Q8. Donnee recherchee : par mode de paiement, le nombre de commandes et le panier moyen
SELECT c.mode_paiement,
       COUNT(DISTINCT c.id_commande) AS nb_commandes,
       ROUND(SUM(l.quantite * l.prix_unitaire) / COUNT(DISTINCT c.id_commande), 2) AS panier_moyen
FROM COMMANDE c
JOIN LIGNE_COMMANDE l ON c.id_commande = l.id_commande
GROUP BY c.mode_paiement
ORDER BY panier_moyen DESC;

-- Q9. Donnee recherchee : le chiffre d'affaires par categorie de produit
SELECT cat.nom_categorie,
       ROUND(SUM(l.quantite * l.prix_unitaire), 2) AS chiffre_affaires
FROM LIGNE_COMMANDE l
JOIN PRODUIT p ON l.id_produit = p.id_produit
JOIN CATEGORIE cat ON p.id_categorie = cat.id_categorie
GROUP BY cat.nom_categorie
ORDER BY chiffre_affaires DESC;

-- Q10. Donnee recherchee : les marques dont au moins 50 unites ont ete vendues
-- (marques a mettre en avant dans la campagne)
SELECT m.nom_marque, SUM(l.quantite) AS unites_vendues
FROM LIGNE_COMMANDE l
JOIN PRODUIT p ON l.id_produit = p.id_produit
JOIN MARQUE m ON p.id_marque = m.id_marque
GROUP BY m.nom_marque
HAVING SUM(l.quantite) >= 50
ORDER BY unites_vendues DESC;

-- Q11. Donnee recherchee : les boutiques qui emploient plus de 3 personnes
SELECT b.nom_boutique, COUNT(e.id_employe) AS nb_employes
FROM BOUTIQUE b
JOIN EMPLOYE e ON b.id_boutique = e.id_boutique
GROUP BY b.id_boutique, b.nom_boutique
HAVING COUNT(e.id_employe) > 3;

-- Q12. Donnee recherchee : statistiques globales du programme de fidelite
SELECT COUNT(*) AS nb_comptes,
       ROUND(AVG(nombre_points_fidelite), 1) AS points_moyens,
       MIN(nombre_points_fidelite) AS points_min,
       MAX(nombre_points_fidelite) AS points_max
FROM FIDELITE;

-- Q13. Donnee recherchee : les clients qui ont depense plus de 2000 euros (clients VIP a cibler)
SELECT cl.nom_client, cl.prenom_client,
       ROUND(SUM(l.quantite * l.prix_unitaire), 2) AS total_depense
FROM CLIENT cl
JOIN COMMANDE c ON cl.id_client = c.id_client
JOIN LIGNE_COMMANDE l ON c.id_commande = l.id_commande
GROUP BY cl.id_client, cl.nom_client, cl.prenom_client
HAVING SUM(l.quantite * l.prix_unitaire) > 2000
ORDER BY total_depense DESC;

-- ==========================================
-- 3. JOINTURES (internes, externes, multiples, auto-jointure)
-- ==========================================

-- Q14. Donnee recherchee : les produits avec leur marque et leur categorie
-- (jointure interne multiple)
SELECT p.nom_produit, m.nom_marque, cat.nom_categorie, p.prix_produit
FROM PRODUIT p
JOIN MARQUE m ON p.id_marque = m.id_marque
JOIN CATEGORIE cat ON p.id_categorie = cat.id_categorie
ORDER BY m.nom_marque, p.nom_produit;

-- Q15. Donnee recherchee : le detail des commandes d'octobre 2026 (client, produit, quantite)
-- (jointure interne a 4 tables)
SELECT c.id_commande, c.date_commande, cl.nom_client, cl.prenom_client,
       p.nom_produit, l.quantite, l.prix_unitaire
FROM COMMANDE c
JOIN CLIENT cl ON c.id_client = cl.id_client
JOIN LIGNE_COMMANDE l ON c.id_commande = l.id_commande
JOIN PRODUIT p ON l.id_produit = p.id_produit
WHERE c.date_commande >= '2026-10-01'
ORDER BY c.date_commande, c.id_commande, l.num_ligne;

-- Q16. Donnee recherchee : tous les clients avec leur compte de fidelite, s'ils en ont un
-- (jointure externe gauche : les clients sans compte apparaissent avec NULL)
SELECT cl.nom_client, cl.prenom_client, f.nombre_points_fidelite
FROM CLIENT cl
LEFT JOIN FIDELITE f ON cl.id_client = f.id_client
ORDER BY cl.nom_client;

-- Q17. Donnee recherchee : les employes avec le nom de leur manager
-- (auto-jointure externe : le directeur general n'a pas de manager)
SELECT e.nom_employe, e.prenom_employe, e.poste_employe,
       m.nom_employe AS nom_manager
FROM EMPLOYE e
LEFT JOIN EMPLOYE m ON e.subordonne = m.id_employe
ORDER BY e.id_employe;

-- Q18. Donnee recherchee : les clients qui n'ont jamais passe de commande
-- (jointure externe gauche + IS NULL)
SELECT cl.nom_client, cl.prenom_client, cl.email_client
FROM CLIENT cl
LEFT JOIN COMMANDE c ON cl.id_client = c.id_client
WHERE c.id_commande IS NULL;

-- Q19. Donnee recherchee : les conseillers avec leur boutique et les clients auxquels
-- ils ont recommande des produits (jointure interne a 4 tables)
SELECT e.nom_employe, e.prenom_employe, b.nom_boutique,
       cl.nom_client, cl.prenom_client
FROM RECOMMANDER r
JOIN EMPLOYE e ON r.id_employe = e.id_employe
JOIN BOUTIQUE b ON e.id_boutique = b.id_boutique
JOIN CLIENT cl ON r.id_client = cl.id_client
ORDER BY b.nom_boutique, e.nom_employe;

-- ==========================================
-- 4. REQUETES IMBRIQUEES (IN, NOT IN, EXISTS, NOT EXISTS, ANY, ALL)
-- ==========================================

-- Q20. Donnee recherchee : les clients qui ont achete au moins un produit Dior (IN)
SELECT nom_client, prenom_client
FROM CLIENT
WHERE id_client IN (
    SELECT c.id_client
    FROM COMMANDE c
    JOIN LIGNE_COMMANDE l ON c.id_commande = l.id_commande
    JOIN PRODUIT p ON l.id_produit = p.id_produit
    JOIN MARQUE m ON p.id_marque = m.id_marque
    WHERE m.nom_marque = 'Dior'
)
ORDER BY nom_client;

-- Q21. Donnee recherchee : les clients qui n'ont jamais achete de produit de la marque
-- maison Sephora Collection (NOT EXISTS)
SELECT cl.nom_client, cl.prenom_client
FROM CLIENT cl
WHERE NOT EXISTS (
    SELECT 1
    FROM COMMANDE c
    JOIN LIGNE_COMMANDE l ON c.id_commande = l.id_commande
    JOIN PRODUIT p ON l.id_produit = p.id_produit
    JOIN MARQUE m ON p.id_marque = m.id_marque
    WHERE c.id_client = cl.id_client
      AND m.nom_marque = 'Sephora Collection'
)
ORDER BY cl.nom_client;

-- Q22. Donnee recherchee : les produits plus chers que tous les produits Dior (> ALL)
SELECT nom_produit, prix_produit
FROM PRODUIT
WHERE prix_produit > ALL (
    SELECT p2.prix_produit
    FROM PRODUIT p2
    JOIN MARQUE m ON p2.id_marque = m.id_marque
    WHERE m.nom_marque = 'Dior'
)
ORDER BY prix_produit DESC;

-- Q23. Donnee recherchee : les commandes dont le montant depasse le montant moyen
-- d'une commande (sous-requete scalaire)
SELECT l.id_commande,
       ROUND(SUM(l.quantite * l.prix_unitaire), 2) AS montant
FROM LIGNE_COMMANDE l
GROUP BY l.id_commande
HAVING SUM(l.quantite * l.prix_unitaire) > (
    SELECT AVG(t.montant)
    FROM (
        SELECT SUM(quantite * prix_unitaire) AS montant
        FROM LIGNE_COMMANDE
        GROUP BY id_commande
    ) t
)
ORDER BY montant DESC;

-- Q24. Donnee recherchee : les clients qui n'ont aucun compte de fidelite (NOT IN)
SELECT nom_client, prenom_client, email_client
FROM CLIENT
WHERE id_client NOT IN (SELECT id_client FROM FIDELITE)
ORDER BY nom_client;

-- Q25. Donnee recherchee : les clients qui n'ont jamais recu de recommandation
-- d'un conseiller (NOT IN)
SELECT nom_client, prenom_client
FROM CLIENT
WHERE id_client NOT IN (SELECT id_client FROM RECOMMANDER)
ORDER BY nom_client;

-- Q26. Donnee recherchee : les commandes passees par des clients ayant un compte
-- de fidelite (= ANY)
SELECT id_commande, date_commande, id_client
FROM COMMANDE
WHERE id_client = ANY (SELECT id_client FROM FIDELITE)
ORDER BY date_commande DESC;
-- Q27. Donnee recherchee : les produits Dior et les quantites commandees
-- (requete utilisee pour l'etude des plans d'execution dans le README)
SELECT p.nom_produit, l.quantite
FROM MARQUE m
JOIN PRODUIT p ON m.id_marque = p.id_marque
JOIN LIGNE_COMMANDE l ON p.id_produit = l.id_produit
WHERE m.nom_marque = 'Dior';