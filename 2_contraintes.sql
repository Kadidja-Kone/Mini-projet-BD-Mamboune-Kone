-- Mini-projet TI503N - sephoraDB
use sephoraDB;
 
-- UNIQUE : valeur sans doublon
alter table CLIENT add constraint uq_client_email unique (email_client);
alter table MARQUE add constraint uq_marque_nom unique (nom_marque);
alter table CATEGORIE add constraint uq_categorie_nom unique (nom_categorie);
 
-- DEFAULT : valeur par defaut si aucune valeur n'est donnee
alter table FIDELITE alter column nombre_points_fidelite set default 0;
alter table COMMANDE alter column mode_paiement set default 'Carte bancaire';
 
-- CHECK avec une comparaison (>= ou >)
alter table FIDELITE add constraint chk_fidelite_points check (nombre_points_fidelite >= 0);
alter table PRODUIT add constraint chk_produit_prix check (prix_produit > 0);
alter table LIGNE_COMMANDE add constraint chk_ligne_prix check (prix_unitaire > 0);
alter table LIGNE_COMMANDE add constraint chk_ligne_num check (num_ligne > 0);
alter table CLIENT add constraint chk_client_naissance check (date_naissance_client >= '1900-01-01');
alter table COMMANDE add constraint chk_commande_date check (date_commande >= '2000-01-01');
alter table EMPLOYE add constraint chk_employe_embauche check (date_embauche >= '1990-01-01');
 
-- CHECK avec BETWEEN
alter table LIGNE_COMMANDE add constraint chk_ligne_quantite check (quantite between 1 and 50);
 
-- CHECK avec IN (liste de valeurs autorisees)
alter table COMMANDE add constraint chk_commande_paiement check (mode_paiement in ('Carte bancaire', 'PayPal', 'Especes', 'Virement'));

-- CHECK avec un format (expression reguliere REGEXP)
-- Telephone : 10 chiffres commencant par 0
alter table CLIENT add constraint chk_client_telephone check (telephone_client regexp '^0[1-9][0-9]{8}$');
alter table BOUTIQUE add constraint chk_boutique_telephone check (telephone_boutique regexp '^0[1-9][0-9]{8}$');
-- E-mail : au format xxx@yyy.zz
alter table CLIENT add constraint chk_client_email check (email_client regexp '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');