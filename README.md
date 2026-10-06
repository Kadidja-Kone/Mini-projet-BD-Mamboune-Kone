# Mini-projet TI503N — Partie 1 : Analyse des besoins et MCD

**Domaine choisi :** vente au détail de produits de beauté (maquillage, parfumerie, soins), sur le modèle de Sephora.

**Binôme :** Safoura Mamboune Ndam et Kadidja Kone

**Contenu du dépôt :**

| Fichier | Rôle |
|---|---|
| `README.md` | Ce document (prompt, règles de gestion, dictionnaire, MCD) |
| `prompt_final.txt` | Texte complet du prompt RICARDO |
| `mcd.png` | Image du MCD (export Looping) |
| `mcd.loo` | Fichier source Looping du MCD |

---

## Étape 1 : Analyse des besoins

### 1.1 Prompt final utilisé (framework RICARDO)

Le prompt complet est disponible dans [`prompt_final.txt`](./prompt_final.txt). Éléments ajoutés au prompt de base :

- **Rôle / Contexte :** entreprise de vente au détail de produits de beauté (maquillage, parfumerie, soins), en boutique physique et en ligne, avec programme de fidélité et conseillers beauté en magasin, sur le modèle de Sephora.
- **Références :** sephora.fr.
- **Instructions / Rendement désiré / Objectifs :** conservés tels quels dans le prompt de base (règles de gestion en liste à puce, puis dictionnaire de données de 25 à 35 éléments en tableau).

### 1.2 Règles de gestion

- Un client peut créer un compte de fidélité (un seul), qui cumule des points selon ses achats. Un compte de fidélité appartient à un seul client.
- Un client peut passer plusieurs commandes (ou aucune pour un nouveau client) ; une commande est passée par un seul client.
- Une commande contient une ou plusieurs lignes, chacune correspondant à un produit et à une quantité.
- Une ligne de commande n'a de sens que rattachée à sa commande : elle n'existe pas de manière autonome.
- Un produit peut apparaître dans plusieurs lignes de commande, ou dans aucune.
- Chaque produit appartient à une seule marque et à une seule catégorie (maquillage, parfum ou soin).
- Une marque peut proposer plusieurs produits ; une catégorie peut regrouper plusieurs produits.
- Chaque employé travaille dans une seule boutique ; une boutique emploie plusieurs employés.
- Un employé a au plus un manager, qui est lui-même un employé de l'entreprise (le directeur général n'a pas de manager) ; un manager peut encadrer plusieurs employés.
- Un conseiller beauté peut recommander des produits à des clients lors de leur passage en boutique ; un client peut être conseillé par plusieurs employés.
- Le prix unitaire d'un produit est aussi enregistré dans la ligne de commande, car il peut varier dans le temps (promotions).

### 1.3 Dictionnaire de données (35 éléments)

| # | Signification de la donnée | Type | Taille |
|---|---|---|---|
| 1 | Identifiant client | Entier | 8 |
| 2 | Nom du client | Chaîne de caractères | 30 |
| 3 | Prénom du client | Chaîne de caractères | 30 |
| 4 | Email du client | Chaîne de caractères | 50 |
| 5 | Téléphone du client | Chaîne de caractères | 10 |
| 6 | Date de naissance du client | Date | - |
| 7 | Identifiant du compte fidélité | Entier | 8 |
| 8 | Nombre de points de fidélité | Entier | 6 |
| 9 | Date d'inscription au programme fidélité | Date | - |
| 10 | Identifiant commande | Entier | 8 |
| 11 | Date de la commande | Date | - |
| 12 | Mode de paiement | Chaîne de caractères | 20 |
| 13 | Numéro de ligne de commande | Entier | 3 |
| 14 | Quantité commandée | Entier | 3 |
| 15 | Prix unitaire au moment de la commande | Décimal | 6,2 |
| 16 | Identifiant produit | Entier | 8 |
| 17 | Nom du produit | Chaîne de caractères | 60 |
| 18 | Description du produit | Chaîne de caractères | 255 |
| 19 | Prix de vente du produit | Décimal | 6,2 |
| 20 | Contenance / volume du produit | Chaîne de caractères | 10 |
| 21 | Identifiant marque | Entier | 5 |
| 22 | Nom de la marque | Chaîne de caractères | 40 |
| 23 | Pays d'origine de la marque | Chaîne de caractères | 30 |
| 24 | Identifiant catégorie | Entier | 4 |
| 25 | Nom de la catégorie | Chaîne de caractères | 30 |
| 26 | Identifiant boutique | Entier | 5 |
| 27 | Nom de la boutique | Chaîne de caractères | 40 |
| 28 | Adresse de la boutique | Chaîne de caractères | 80 |
| 29 | Ville de la boutique | Chaîne de caractères | 30 |
| 30 | Téléphone de la boutique | Chaîne de caractères | 10 |
| 31 | Identifiant employé | Entier | 6 |
| 32 | Nom de l'employé | Chaîne de caractères | 30 |
| 33 | Prénom de l'employé | Chaîne de caractères | 30 |
| 34 | Poste occupé | Chaîne de caractères | 30 |
| 35 | Date d'embauche | Date | - |

### 1.4 Ajustements faits après la première génération

- Le montant total d'une commande a été retiré du dictionnaire : c'est une donnée calculable (somme des quantités × prix unitaires des lignes), donc la stocker romprait la 3FN.
- Le compte de fidélité est devenu une entité à part (identifiant propre), au lieu de simples attributs du client.
- Le responsable de boutique et la date de recommandation ont été retirés pour rester dans la limite de 35 données.

---

## Étape 2 : MCD

Le MCD a été réalisé avec l'outil **Looping** (fichier source : [`mcd.loo`](./mcd.loo)). Image exportée :

![MCD](./mcd.png)

### Entités, identifiants et attributs

| Entité | Identifiant (souligné) | Autres attributs |
|---|---|---|
| Client | id_client | nom_client, prenom_client, email_client, telephone_client, date_naissance_client |
| Fidelite | id_fidelite | points_fidelite, date_inscription_fidelite |
| Commande | id_commande | date_commande, mode_paiement |
| LigneCommande (entité faible) | num_ligne (R) | quantite, prix_unitaire |
| Produit | id_produit | nom_produit, description_produit, prix_produit, contenance_produit |
| Marque | id_marque | nom_marque, pays_origine_marque |
| Categorie | id_categorie | nom_categorie |
| Boutique | id_boutique | nom_boutique, adresse_boutique, ville_boutique, telephone_boutique |
| Employe | id_employe | nom_employe, prenom_employe, poste_employe, date_embauche |

### Associations et cardinalités

| Association | Entité 1 | Cardinalité | Entité 2 | Cardinalité |
|---|---|---|---|---|
| Appartenir | Produit | 1,1 | Marque | 0,n |
| Classer | Produit | 1,1 | Categorie | 0,n |
| Concerner | LigneCommande | 1,1 | Produit | 0,n |
| Contenir | LigneCommande | 1,1 (R) | Commande | 1,n |
| Passer | Commande | 1,1 | Client | 0,n |
| Créer | Fidelite | 1,1 | Client | 0,1 |
| Recommander | Employe | 0,n | Client | 0,n |
| Employer | Employe | 1,1 | Boutique | 1,n |
| Encadrer (récursive) | Employe (managé) | 0,1 | Employe (manager) | 0,n |

### Éléments de modélisation avancée utilisés (2 requis, 2 fournis)

1. **Association récursive** : `Encadrer` relie `Employe` à lui-même. Chaque employé (sauf le directeur général) a un manager qui est aussi un employé ; un manager peut encadrer plusieurs employés.
2. **Entité faible et entité forte** : `LigneCommande` (entité faible) n'a de sens qu'à travers `Commande` (entité forte). Son identifiant `num_ligne` n'est unique qu'au sein d'une commande donnée (identifiant relatif, noté (R)).

*(Bonus, non requis : `Recommander` est une association n:n entre `Employe` et `Client`.)*

### Vérification de la 3FN

- Chaque attribut non-clé dépend uniquement et directement de la clé de son entité. Exemple : `pays_origine_marque` dépend de `id_marque`, pas de `id_produit`.
- Aucun attribut calculable n'est stocké (le total d'une commande se calcule à partir de ses lignes).
- Les noms d'attributs sont uniques dans tout le modèle (suffixes `_client`, `_produit`, etc.).
- Les 35 données du dictionnaire sont toutes présentes dans le MCD, et il n'y en a pas d'autres.
