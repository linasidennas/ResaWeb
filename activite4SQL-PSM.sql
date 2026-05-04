--vue_adherents_complets

CREATE VIEW vue_adherents_complets AS
SELECT 
   
    cpt_pseudo ,
    pfl_nom     ,
    pfl_prenom   ,
    pfl_email   ,
    pfl_numero_de_telephone
FROM t_compte_cpt
JOIN t_profil_pfl USING(cpt_id)
WHERE pfl_role = 'M';


--vue admin
CREATE VIEW vue_admins AS
SELECT 
    cpt_pseudo  ,
    pfl_nom     ,
    pfl_prenom  ,
    pfl_email 
FROM t_compte_cpt
JOIN t_profil_pfl USING(cpt_id)
WHERE pfl_role = 'A';



--fonction liste des participants 
DELIMITER $$

CREATE FUNCTION liste_participants(id_res INT)
RETURNS TEXT
BEGIN
    DECLARE res TEXT;

    SELECT GROUP_CONCAT(CONCAT(pfl_prenom, ' ', pfl_nom) SEPARATOR ', ')
    INTO res
    FROM t_inscription_ins
    JOIN t_compte_cpt USING(cpt_id)
    JOIN t_profil_pfl USING(cpt_id)
    WHERE res_id = id_res;

    RETURN res;
END$$

DELIMITER ;


--nom du responsable 
DELIMITER $$

CREATE FUNCTION nom_responsable(id_res INT)
RETURNS VARCHAR(255)
BEGIN
    DECLARE res VARCHAR(255);

    SELECT CONCAT(pfl_prenom, ' ', pfl_nom) INTO res
    FROM t_inscription_ins
    JOIN t_profil_pfl USING(cpt_id)
    WHERE res_id = id_res
      AND ins_role = 'R'
    LIMIT 1;

    RETURN res;
END$$

DELIMITER ;




--desactiver un compte 
DELIMITER $$

CREATE PROCEDURE desactiver_compte(IN id_compte INT)
BEGIN
    UPDATE t_compte_cpt
    SET cpt_etat = 'D'
    WHERE cpt_id = id_compte;
END$$

DELIMITER ;

--activer un compte 

DELIMITER $$

CREATE PROCEDURE activer_compte(IN id_compte INT)
BEGIN
    UPDATE t_compte_cpt
    SET cpt_etat = 'A'
    WHERE cpt_id = id_compte;
END$$

DELIMITER ;

--REMPLIR AUTOMATIQUEMENT DATE INSCRIPTION 
DELIMITER $$

CREATE TRIGGER inscription_date_auto
BEFORE INSERT ON t_inscription_ins
FOR EACH ROW
BEGIN
    SET NEW.ins_date_inscription = CURRENT_DATE();
END$$

DELIMITER ;

--SUPPRIMER INSCRIPTIONS QUAND ON SUPP UNE RESERVATION 
DELIMITER $$

CREATE TRIGGER auto_delete_inscriptions
BEFORE DELETE ON t_reservation_res
FOR EACH ROW
BEGIN
    DELETE FROM t_inscription_ins WHERE res_id = OLD.res_id;
END$$

DELIMITER ;



--procedure ajout message 

DELIMITER $$

CREATE PROCEDURE ajouter_message(
    IN subjet VARCHAR(255),
    IN contenu TEXT,
    IN email VARCHAR(255),
    IN codex VARCHAR(50)
)
BEGIN
    INSERT INTO t_message_msg(msg_sujet, msg_date, msg_contenu, msg_email, msg_code)
    VALUES (subjet, NOW(), contenu, email, codex);
END$$

DELIMITER ;
