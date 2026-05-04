//////////SPRINT1
Actualités :
1. Requête listant toutes les actualités de la table des actualités et leur auteur
(login)
SELECT act_id,act_titre,act_contenu,act_description,act_date,cpt_pseudo 
FROM t_actualite_act 
JOIN t_compte_cpt 
USING (cpt_id); 

2. Requête donnant les données dune actualité dont on connaît lidentifiant (n°)
SELECT * FROM t_actualite_act 
WHERE act_id=2; 

3. Requête listant les 5 dernières actualités dans lordre décroissant
SELECT * FROM t_actualite_act 
ORDER BY act_date DESC LIMIT 5;

4. Requête recherchant et donnant la (ou les) actualité(s) contenant un mot
particulier
SELECT * FROM t_actualite_act 
WHERE act_titre LIKE '% mot %' 
OR act_contenu LIKE '% mot %' 
OR act_description LIKE '% mot %'; 


5. Requête listant toutes les actualités postées à une date particulière + le login de
l’auteur
SELECT act_id,act_titre,act_contenu,act_description,cpt_pseudo 
FROM t_actualite_act 
JOIN t_compte_cpt 
USING (cpt_id) 
WHERE DATE(act_date)="2025-10-15"; 
 

Prise de contact :
1. Requête récupérant les données associées à un code de 20 caractères
SELECT *FROM t_message_msg 
WHERE msg_code='VISITEUR202509280100';

2. Requête d’insertion d’une question d’un visiteur (contenant le code de 20
caractères)
INSERT INTO t_message_msg 
VALUES (NULL,"Horaires ouverture jours fériés", curdate(),
"bonjour, j'aimerai connaitre vos horaires d'ouverture en jours fériés svp",NULL,"lina123456vsteroiupm",NULL);


3. Requête donnant la liste de toutes les demandes des visiteurs
SELECT msg_contenu FROM t_message_msg;


4. Requête d’ajout de la réponse d’un administrateur à la question d’un visiteur
UPDATE t_message_msg 
SET cpt_id=2,
     msg_reponse="bonjour, on est ouvert aux horaires habituelles" 
WHERE msg_id=3; 


Profils (administrateurs / membres) :
1. Requête listant toutes les données de tous les profils/comptes classés par statut
SELECT * FROM t_profil_pfl 
ORDER BY pfl_role ;

SELECT * FROM t_compte_cpt 
JOIN t_profil_pfl 
USING (cpt_id)
ORDER BY pfl_role ;
2. Requête donnant tous les nom / prénom / adresse e-mail / n° de téléphone des
adhérents de la structure
SELECT pfl_nom,pfl_prenom,pfl_email,pfl_numero_de_telephone 
FROM t_profil_pfl
WHERE pfl_role='M'; 


3. Requête de vérification des données de connexion (login et mot de passe)
SELECT * FROM t_compte_cpt 
WHERE cpt_pseudo = 'principal' 
AND cpt_mot_de_passe = SHA2('princ25*!ASER',256); 


4. Requête récupérant les données dun profil/compte particulier (utilisateur
connecté)
--pas sur

SELECT * FROM t_compte_cpt WHERE cpt_id = 55 AND cpt_etat='A'; 


5. Requête vérifiant l’existence (ou non) d’un pseudo
SELECT * 
FROM t_compte_cpt
WHERE cpt_pseudo = 'principal'; 

6. Requête dajout des données dun profil/compte administrateur (/ membre)

INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mot_de_passe, cpt_etat)
VALUES ('principal', 'be04b80973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A');

INSERT INTO t_profil_pfl 
VALUES ('Sidennas', 'Lina', '2004-03-15', 'linasidennas5@gmail.com', '0783084173', 'A', 'rue de saint-brieuc', '29200', '1');


7. Requête d’ajout d’un compte invité
INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mot_de_passe, cpt_etat)
VALUES ('invite11', 'abc1230973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A');


/////////////SPRINT2/////////////////////////////////////////////////////////////////////////////////////
RESERVATIONS
2. Requête donnant les réservations lors d’un jour particulier
SELECT * FROM t_reservation_res WHERE DATE(res_date)="2025-10-10"; 

3. Requête (+ code SQL) listant toutes les réservations à venir de l’utilisateur
connecté (+ date, heure, ressource, liste des participants)
--ca marche pas , AFFICHE QUE UNE SEULE RESERVATION
SELECT res_id,res_nom,res_date,rsc_nom , 
GROUP_CONCAT(cpt_pseudo SEPARATOR '\n ') AS participants
FROM t_reservation_res 
JOIN t_ressource_rsc USING (rsc_id) 
JOIN t_inscription_ins USING (res_id) 
JOIN t_compte_cpt USING (cpt_id) 
WHERE res_date >= CURDATE() 
AND  res_id IN (
      SELECT res_id 
      FROM t_inscription_ins
      WHERE cpt_id = 1) ; 




4. Requête (+ code SQL) listant toutes les réservations à venir / en cours / passées
de l’utilisateur connecté (+ date, heure, ressource, liste des participants), de la
plus récente à la plus ancienne


5. Requête listant les réservations à venir (& indisponibilités) d’une ressource
particulière (ID connu)
SELECT rsc_nom, res_id, res_nom,dis_id ,dis_infosupp 
     FROM t_reservation_res
     JOIN t_ressource_rsc USING (rsc_id) 
     JOIN t_association_ast USING (rsc_id)
     JOIN t_indisponibilite_dis USING (dis_id)
     WHERE res_date >= CURRENT_DATE() AND rsc_id=1;


6. Requête vérifiant l’existence (ou non) d’une réservation sur un créneau particulier
(date + heure) pour une ressource particulière (ID connu)
SELECT * FROM t_reservation_res
 WHERE rsc_id = 1 AND res_date = '2025-12-05 18:00:00'; 

7. Requête vérifiant l’existence (ou non) d’une réservation pour l’utilisateur connecté
sur un créneau particulier (date + heure)
SELECT * FROM t_reservation_res 
JOIN t_inscription_ins USING (res_id)
WHERE rsc_id = 1
  AND res_date = '2025-12-05 18:00:00'
  AND cpt_id=1;


8. Requête comptant le nombre de personnes associées à une réservation
particulière
  SELECT COUNT(*) AS NB_associés_reservation 
     FROM t_inscription_ins WHERE res_id = 1; 

9. Requête (ou code SQL) ajoutant une participation de l’utilisateur connecté en tant
que responsable (/participant) à une réservation déjà existante ou à créer si elle
n’existe pas encore



10. Requête retirant une participation à une réservation de l’utilisateur connecté
DELETE FROM t_inscription_ins WHERE cpt_id=5 AND res_id=1;


11. Requête (ou code SQL) permettant à l’utilisateur connecté d’ajouter le bilan à
l’une de ses réservations passées à laquelle il a participé comme responsable


Ressources :
1. Requête listant toutes les ressources réservables
SELECT rsc_id, rsc_nom ,rsc_descriptif FROM t_ressource_rsc 
WHERE rsc_id NOT IN (
		SELECT rsc_id FROM t_association_ast
		JOIN t_indisponibilite_dis USING (dis_id)
    		WHERE CURDATE() BETWEEN dis_date_debut AND dis_date_fin );



2. Requête listant toutes les données d’une ressource particulière (ID connu) et le
récapitulatif du matériel, s’il y en a
SELECT * FROM t_ressource_rsc 
WHERE rsc_id =5;

3. Requête récupérant la jauge maximale (/minimale) d’une ressource particulière
SELECT rsc_jauge_min, rsc_jauge_max FROM t_ressource_rsc
 WHERE rsc_id =5; 

4. Requête d’ajout des données d’une ressource
INSERT INTO t_ressource_rsc (rsc_nom, rsc_descriptif, rsc_jauge_min, rsc_jauge_max, rsc_image, rsc_liste_materiel) 
VALUES ('Studio de coloriage', 'Espace créatif pour enfants et adultes, équipé pour des activités de coloriage et dessin',
 1, 15, NULL, 'Feutres, Crayons, Papier, Tables, Chaises'); 

5. Requête(s) de suppression d’une ressource
DELETE FROM t_association_ast WHERE rsc_id=6;
DELETE FROM t_partcipation_par WHERE res_id
 IN (SELECT res_id FROM t_reservation_res WHERE rsc_id=6);
DELETE FROM t_reservation_res WHERE rsc_id=6;
DELETE FROM t_ressource_rsc WHERE rsc_id=6;
