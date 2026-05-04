<?php
/*
    Développeuse: SIDENNAS Lina
    Date: 01-11-2025
    Application de gestion de réservation pour une association culturelle 
*/
namespace App\Models;
use CodeIgniter\Model;
class Db_model extends Model
{
    protected $db;
    public function __construct()
    {
        $this->db = db_connect(); //charger la base de données
        // ou
        // $this->db = \Config\Database::connect();
    }

     /* ---------------------------------------------------------
        Récupère la liste de tous les comptes (pseudo uniquement)
    --------------------------------------------------------- */
    public function get_all_compte()
    {
        $resultat = $this->db->query("SELECT cpt_pseudo FROM t_compte_cpt;");
        return $resultat->getResultArray();
    }
 /* ---------------------------------------------------------
        Récupère une actualité spécifique grâce à son ID
    --------------------------------------------------------- */
    public function get_actualite($numero)
    {
        $requete="SELECT * FROM t_actualite_act WHERE act_id=".$numero.";";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }
 /* ---------------------------------------------------------
        Retourne le nombre total de comptes enregistrés
    --------------------------------------------------------- */
    public function get_number_compte()
    {
        $requete="SELECT COUNT(*) AS nombre_comptes FROM t_compte_cpt ;";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }

      /* ---------------------------------------------------------
        Récupère les actualités actives (A), limitées à 5
    --------------------------------------------------------- */

    public function get_all_actualite()
    {
        $resultat = $this->db->query("SELECT act_titre,act_contenu,act_date,cpt_pseudo 
        FROM t_actualite_act JOIN t_compte_cpt USING (cpt_id)
         WHERE act_etat='A' ORDER BY act_date DESC LIMIT 5 ;");
        return $resultat->getResultArray();
    }
 /* ---------------------------------------------------------
        Récupère un message + suivi via son code unique
    --------------------------------------------------------- */

    public function get_suivi_message($chaine)
    {
        $resultat = $this->db->query("SELECT msg_sujet,msg_contenu,msg_reponse,msg_date,msg_email,cpt_pseudo FROM t_message_msg LEFT JOIN t_compte_cpt using (cpt_id)
         WHERE msg_code='".$chaine."';");
        return $resultat->getRow();
    }
 /* ---------------------------------------------------------
        Insère un nouveau compte utilisateur
    --------------------------------------------------------- */
    public function set_compte($saisie)
    {
        //Récuparation (+ traitement si nécessaire) des données du formulaire
$login = $this->db->escapeString($saisie['pseudo']);
    $mot_de_passe = $this->db->escapeString($saisie['mdp']);

        $mot_de_passe_hache = hash('sha256', $mot_de_passe . 'TKfd95b1dg');
        $sql="INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mot_de_passe, cpt_etat) 
        VALUES('".$login."','".$mot_de_passe_hache."','A');";
        return $this->db->query($sql);
    }
 /* ---------------------------------------------------------
        Vérifie si un pseudo existe déjà dans la base
    --------------------------------------------------------- */
public function pseudo_existe($pseudo)
{
    $pseudo = $this->db->escapeString($pseudo);

    $sql = "SELECT cpt_pseudo 
            FROM t_compte_cpt 
            WHERE cpt_pseudo = '".$pseudo."';";

    $result = $this->db->query($sql)->getResult();

    return !empty($result);
}


  /* ---------------------------------------------------------
        Insère un message et génère un code de suivi
    --------------------------------------------------------- */
     public function set_message($saisie)
    {
        //Récuparation (+ traitement si nécessaire) des données du formulaire
        $sujet=addslashes($saisie['sujet']);
        $contenu=addslashes($saisie['contenu']);
        $code = $saisie['code']; 
        $email=addslashes($saisie['email']);

            $sql = "CALL ajouter_message('".$sujet."', '".$contenu."', '".$email."', '".$code."')";
        $this->db->query($sql);

        return $code;

    } 

 /* ---------------------------------------------------------
        Vérifie la connexion d’un compte (pseudo + mot de passe)
    --------------------------------------------------------- */
public function connect_compte($pseudo, $mdp)
{
    // 1) On cherche l'utilisateur
    $sql = "
        SELECT cpt_id, cpt_pseudo, cpt_mot_de_passe, pfl_role
        FROM t_compte_cpt
        LEFT JOIN t_profil_pfl USING (cpt_id)
        WHERE cpt_pseudo = '".$pseudo."';
    ";

    $row = $this->db->query($sql)->getRow();

    //  Aucun utilisateur trouvé --> PSEUDO INEXISTANT
    if (!$row) {
        return "NO_USER";
    }

    // 2) Vérification du mot de passe HASH
    $verif = hash('sha256', $mdp . 'TKfd95b1dg');

    if ($verif !== $row->cpt_mot_de_passe) {
        //  Pseudo existe mais mot de passe faux
        return "BAD_PASSWORD";
    }

    // 3) ✔ Connexion OK
    return $row;
}


 /* ---------------------------------------------------------
        Récupère toutes les informations du profil d’un utilisateur
    --------------------------------------------------------- */

    public function get_info_profil($u)
    {
        $sql="SELECT * FROM t_profil_pfl
        JOIN t_compte_cpt USING (cpt_id)
        WHERE cpt_pseudo='".$u."'";
        
        $resultat=$this->db->query($sql);
        return $resultat->getRow();

    }
 /* ---------------------------------------------------------
        Récupère les réservations à venir d’un utilisateur
    --------------------------------------------------------- */
  public function get_reservation($pseudo)
{
    $sql = "
        SELECT  res_id,res_nom,res_lieu,res_date,rsc_nom,
            nom_responsable(res_id),
            liste_participants(res_id)
        FROM t_reservation_res
        JOIN t_ressource_rsc USING(rsc_id)
        JOIN t_inscription_ins USING(res_id)
        JOIN t_compte_cpt USING(cpt_id)
        WHERE cpt_pseudo = '".$pseudo."'
          AND res_date >= CURRENT_DATE()
        GROUP BY res_id
        ORDER BY res_date;
    ";

    return $this->db->query($sql)->getResultArray();
}


/* ---------------------------------------------------------
        Récupère tous les messages enregistrés
    --------------------------------------------------------- */
     public function get_all_message()
    {
        $resultat = $this->db->query("SELECT msg_code, msg_sujet, msg_contenu, msg_reponse, msg_date,
               msg_email, cpt_pseudo
         FROM t_message_msg 
         LEFT JOIN t_compte_cpt using (cpt_id)
          ORDER BY msg_date DESC  ;");
        return $resultat->getResultArray();
    } 
/* ---------------------------------------------------------
        Ajoute une réponse à un message et associe l’admin
    --------------------------------------------------------- */
    public function set_reponse_message($code, $reponse, $pseudo)
    {
            $reponse = addslashes($reponse);
        $sql = "UPDATE t_message_msg
            SET msg_reponse = '".$reponse."',
                cpt_id = (SELECT cpt_id FROM t_compte_cpt WHERE cpt_pseudo = '".$pseudo."')
            WHERE msg_code = '".$code."';";

        return $this->db->query($sql);
    }

/* ---------------------------------------------------------
        Récupère tous les comptes + profils (administration)
    --------------------------------------------------------- */
     public function get_all_compte_profil()
    {
        $resultat = $this->db->query("SELECT cpt_id,cpt_pseudo,pfl_nom,pfl_prenom,pfl_email,pfl_role,cpt_etat
         FROM t_compte_cpt LEFT JOIN t_profil_pfl USING (cpt_id)ORDER BY cpt_etat ;");
        return $resultat->getResultArray();
    }
/* ---------------------------------------------------------
        Récupère tous les adhérents via la vue SQL
    --------------------------------------------------------- */
    public function get_all_adherents()
    {
        $resultat = $this->db->query("SELECT * FROM vue_adherents_complets;");
        return $resultat->getResultArray();
    }
    
   
 /* ---------------------------------------------------------
        Récupère les ressources disponibles
    --------------------------------------------------------- */
        public function get_all_ressource()
    {
        $resultat = $this->db->query("SELECT rsc_id, rsc_nom,rsc_descriptif,rsc_jauge_min,rsc_jauge_max,rsc_image
         FROM t_ressource_rsc ;");
        return $resultat->getResultArray();
    }
 /* ---------------------------------------------------------
        Ajoute une nouvelle ressource
    --------------------------------------------------------- */
     public function set_ressource($nom, $descriptif, $jauge_min, $jauge_max, $image)
{
    // Protection des champs texte
    $nom = addslashes($nom);
    $descriptif = addslashes($descriptif);
    $image = addslashes($image);

    $sql = "
        INSERT INTO t_ressource_rsc 
        (rsc_nom, rsc_descriptif, rsc_jauge_min, rsc_jauge_max, rsc_image)
        VALUES (
            '".$nom."', 
            '".$descriptif."', 
            ".$jauge_min.", 
            ".$jauge_max.", 
            '".$image."'
        );
    ";

    return $this->db->query($sql);
}


/* ---------------------------------------------------------
        Supprime une ressource et toutes les données liées
    --------------------------------------------------------- */
    public function delete_ressource($id)
{
    // Supprimer dans t_association_ast
    $sql1 = "DELETE FROM t_association_ast WHERE rsc_id = " . $id . ";";
    $this->db->query($sql1);

    // Supprimer les inscriptions liées aux réservations de cette ressource
    $sql2 = "DELETE FROM t_inscription_ins 
             WHERE res_id IN (SELECT res_id FROM t_reservation_res WHERE rsc_id = " . $id . ");";
    $this->db->query($sql2);

    // Supprimer les réservations
    $sql3 = "DELETE FROM t_reservation_res WHERE rsc_id = " . $id . ";";
    $this->db->query($sql3);

    // Supprimer la ressource
    $sql4 = "DELETE FROM t_ressource_rsc WHERE rsc_id = " . $id . ";";
    return $this->db->query($sql4);
}


 /* ---------------------------------------------------------
        Récupère les réservations pour une journée donnée
    --------------------------------------------------------- */
public function get_reservations_by_day($date)
{
    $sql = "
        SELECT
            rsc_nom ,
            res_id ,
            res_nom ,
            res_lieu ,
            res_date ,
            res_bilan,
            nom_responsable(res_id) AS responsable,
            liste_participants(res_id) AS participants
        FROM t_reservation_res
        JOIN t_ressource_rsc USING(rsc_id)
        WHERE DATE(res_date) = '".$date."'
        ORDER BY rsc_nom, res_date;
    ";

    return $this->db->query($sql)->getResultArray();
}


 /* ---------------------------------------------------------
        Active un compte via la procédure stockée
    --------------------------------------------------------- */
public function activer_compte($id)
{
    $sql = "CALL activer_compte($id)";
    return $this->db->query($sql);
}
 /* ---------------------------------------------------------
        Désactive un compte via la procédure stockée
    --------------------------------------------------------- */
public function desactiver_compte($id)
{
    $sql = "CALL desactiver_compte($id)";
    return $this->db->query($sql);
}

}