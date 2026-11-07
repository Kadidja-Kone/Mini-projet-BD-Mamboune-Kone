drop schema if exists sephoraDB;
create schema sephoraDB;
use sephoraDB;
 
CREATE TABLE MARQUE(
   id_marque INT AUTO_INCREMENT,
   nom_marque VARCHAR(40) NOT NULL,
   pays_marque VARCHAR(30) NOT NULL,
   PRIMARY KEY(id_marque)
);
 
CREATE TABLE CATEGORIE(
   id_categorie INT AUTO_INCREMENT,
   nom_categorie VARCHAR(30) NOT NULL,
   PRIMARY KEY(id_categorie)
);
 
CREATE TABLE CLIENT(
   id_client INT AUTO_INCREMENT,
   nom_client VARCHAR(30) NOT NULL,
   prenom_client VARCHAR(30) NOT NULL,
   email_client VARCHAR(50) NOT NULL,
   telephone_client VARCHAR(10) NOT NULL,
   date_naissance_client DATE NOT NULL,
   PRIMARY KEY(id_client)
);
 
CREATE TABLE FIDELITE(
   id_fidelite INT AUTO_INCREMENT,
   nombre_points_fidelite INT NOT NULL,
   date_inscription_fidelite DATE NOT NULL,
   id_client INT NOT NULL,
   PRIMARY KEY(id_fidelite),
   UNIQUE(id_client),
   FOREIGN KEY(id_client) REFERENCES CLIENT(id_client) ON UPDATE CASCADE ON DELETE CASCADE
);
 
CREATE TABLE BOUTIQUE(
   id_boutique INT AUTO_INCREMENT,
   nom_boutique VARCHAR(40) NOT NULL,
   adresse_boutique VARCHAR(80) NOT NULL,
   ville_boutique VARCHAR(30) NOT NULL,
   telephone_boutique VARCHAR(10) NOT NULL,
   PRIMARY KEY(id_boutique)
);
 
CREATE TABLE PRODUIT(
   id_produit INT AUTO_INCREMENT,
   prix_produit DECIMAL(6,2) NOT NULL,
   volume_produit VARCHAR(10) NOT NULL,
   nom_produit VARCHAR(60) NOT NULL,
   description_produit VARCHAR(255) NOT NULL,
   id_categorie INT NOT NULL,
   id_marque INT NOT NULL,
   PRIMARY KEY(id_produit),
   FOREIGN KEY(id_categorie) REFERENCES CATEGORIE(id_categorie) ON UPDATE CASCADE ON DELETE CASCADE,
   FOREIGN KEY(id_marque) REFERENCES MARQUE(id_marque) ON UPDATE CASCADE ON DELETE CASCADE
);
 
CREATE TABLE COMMANDE(
   id_commande INT AUTO_INCREMENT,
   date_commande DATE NOT NULL,
   mode_paiement VARCHAR(20) NOT NULL,
   id_client INT NOT NULL,
   PRIMARY KEY(id_commande),
   FOREIGN KEY(id_client) REFERENCES CLIENT(id_client) ON UPDATE CASCADE ON DELETE CASCADE
);
 
CREATE TABLE EMPLOYE(
   id_employe INT AUTO_INCREMENT,
   nom_employe VARCHAR(30) NOT NULL,
   prenom_employe VARCHAR(30) NOT NULL,
   poste_employe VARCHAR(30),
   date_embauche DATE,
   subordonne INT,
   id_boutique INT NOT NULL,
   PRIMARY KEY(id_employe),
   FOREIGN KEY(subordonne) REFERENCES EMPLOYE(id_employe) ON UPDATE CASCADE ON DELETE SET NULL,
   FOREIGN KEY(id_boutique) REFERENCES BOUTIQUE(id_boutique) ON UPDATE CASCADE ON DELETE CASCADE
);
 
CREATE TABLE LIGNE_COMMANDE(
   id_commande INT,
   num_ligne INT,
   quantite INT NOT NULL,
   prix_unitaire DECIMAL(6,2) NOT NULL,
   id_produit INT NOT NULL,
   PRIMARY KEY(id_commande, num_ligne),
   FOREIGN KEY(id_commande) REFERENCES COMMANDE(id_commande) ON UPDATE CASCADE ON DELETE CASCADE,
   FOREIGN KEY(id_produit) REFERENCES PRODUIT(id_produit) ON UPDATE CASCADE ON DELETE CASCADE
);
 
CREATE TABLE RECOMMANDER(
   id_employe INT,
   id_client INT,
   PRIMARY KEY(id_employe, id_client),
   FOREIGN KEY(id_employe) REFERENCES EMPLOYE(id_employe) ON UPDATE CASCADE ON DELETE CASCADE,
   FOREIGN KEY(id_client) REFERENCES CLIENT(id_client) ON UPDATE CASCADE ON DELETE CASCADE
);
 
