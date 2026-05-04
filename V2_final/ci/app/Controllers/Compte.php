<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Compte extends BaseController
{
public function __construct()
{
    helper('form');
    $this->model = model(Db_model::class);
}

public function lister()
{
    //$this->model = model(Db_model::class);
    $data['titre']="Liste de tous les comptes ";
    $data['logins'] = $this->model->get_all_compte();
    $data['number'] = $this->model->get_number_compte();

    return view('templates/haut', $data)
    . view('affichage_comptes')
    . view('templates/bas');
}

public function creer()
{
    $session = session();
    if (! $session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
    //helper('form');
    //$this->model = model(Db_model::class);
    // L’utilisateur a validé le formulaire en cliquant sur le bouton
    if ($this->request->getMethod()=="POST")
    {
        if ($this->model->pseudo_existe($this->request->getPost('pseudo'))) {
    return view('menu_administrateur', [
        'titre' => 'Créer un compte',
        'erreur_pseudo' => ' Ce pseudo existe déjà !'
    ])
    . view('compte/compte_creer')
    . view('templates/bas2');
}

        if (! $this->validate([
        'pseudo' => 'required|max_length[255]|min_length[2]',
        'mdp' => 'required|max_length[255]|min_length[8]'
        ],
        [ // Configuration des messages d’erreurs
            'pseudo' => [
            'required' => 'Veuillez entrer un pseudo pour le compte !',
            ],
            'mdp' => [
            'required' => 'Veuillez entrer un mot de passe !',
            'min_length' => 'Le mot de passe saisi est trop court !',
            ],
            ]
        ))
        {
            // La validation du formulaire a échoué, retour au formulaire !
            return view('menu_administrateur', ['titre' => 'Créer un compte'])
            . view('compte/compte_creer')
            . view('templates/bas2');
        }
        // La validation du formulaire a réussi, traitement du formulaire
        $recuperation = $this->validator->getValidated();
        $this->model->set_compte($recuperation);
        
        $data['le_compte']=$recuperation['pseudo'];
        $data['le_message']="Nouveau nombre de comptes : ";
        //Appel de la fonction créée dans le précédent tutoriel :
        $data['le_total']=$this->model->get_number_compte();
        return view('menu_administrateur', $data)
        . view('compte/compte_succes')
        . view('templates/bas2');
    }
    // L’utilisateur veut afficher le formulaire pour créer un compte
    return view('menu_administrateur', ['titre' => 'Créer un compte'])
    . view('compte/compte_creer')
    . view('templates/bas2');
}



       public function connecter()
    {
        $session = session();

        // Déjà connecté → afficher accueil selon rôle
        if ($session->has('user') && $session->has('role') && $this->request->getMethod() == "GET")
        {
            $pseudo = $session->get('user');
            $role   = $session->get('role');

            $data['reserv'] = $this->model->get_reservation($pseudo);
            $data['titre']  = "Mes réservations";

            if ($role == 'A') {
                return view('menu_administrateur')
                    . view('connexion/compte_accueil')
                    . view('connexion/compte_reservation', $data)
                    . view('templates/bas2');
            }
            else if($role == 'M'){
                return view('menu_membre')
                . view('connexion/compte_accueil')
                . view('connexion/compte_reservation', $data)
                . view('templates/bas2');
            }
            return view('menu_invite')
                . view('connexion/compte_accueil')
                . view('connexion/compte_reservation', $data)
                . view('templates/bas2');
            
        }

        // Formulaire soumis
        if ($this->request->getMethod() == "POST")
        {
            if (! $this->validate([
                'pseudo' => 'required',
                'mdp'    => 'required'
            ],
            [
                'pseudo' => [
                    'required' => 'Veuillez entrer votre pseudo !'
                ],
                'mdp' => [
                    'required' => 'Veuillez entrer votre mot de passe !'
                ]
            ]))
            {
                return view('menu_visiteur', ['titre' => 'Se connecter'])
                    . view('connexion/compte_connecter')
                    . view('templates/bas');
            }

            $username = $this->request->getVar('pseudo');
            $password = $this->request->getVar('mdp');

            // 🔥 Vérification via le modèle (hash + password_verify)
            $user = $this->model->connect_compte($username, $password);
            if ($user === "NO_USER") {
                    return view('menu_visiteur', ['titre' => 'Se connecter'])
                        . view('connexion/compte_connecter', ['erreur' => 'Ce pseudo n’existe pas !'])
                        . view('templates/bas');
                }

                // Login FAIL : mauvais mot de passe
                if ($user === "BAD_PASSWORD") {
                    return view('menu_visiteur', ['titre' => 'Se connecter'])
                        . view('connexion/compte_connecter', ['erreur' => 'Mot de passe incorrect !'])
                        . view('templates/bas');
                }
            if ($user)  // Login OK
            {
                $session->set('user', $user->cpt_pseudo);
                $session->set('role', $user->pfl_role);

                $data['reserv'] = $this->model->get_reservation($username);
                $data['titre']  = "Mes réservations";

                if ($user->pfl_role == 'A') {
                    return view('menu_administrateur')
                        . view('connexion/compte_accueil')
                        . view('connexion/compte_reservation', $data)
                        . view('templates/bas2');
                }else if ($user->pfl_role == 'M') {
                    return view('menu_membre')
                    . view('connexion/compte_accueil')
                    . view('connexion/compte_reservation', $data)
                    . view('templates/bas2');
                }

                return view('menu_invite')
                    . view('connexion/compte_accueil')
                    . view('connexion/compte_reservation', $data)
                    . view('templates/bas2');
            }

            
        }

        // GET : afficher formulaire
        return view('menu_visiteur', ['titre' => 'Se connecter'])
            . view('connexion/compte_connecter')
            . view('templates/bas');
    }

public function afficher_profil()
{
    $session = session();

    if ($session->has('user')) {

        $pseudo = $session->get('user');
        $role = $session->get('role'); // 🔥 On récupère le rôle

        // 🔥 Récupération des infos du profil
        $data['profil'] = $this->model->get_info_profil($pseudo);

        // 🔥 MENU SELON LE RÔLE
        if ($role == 'A') {
            return view('menu_administrateur', $data)
                . view('connexion/compte_profil')
                . view('templates/bas2');
        }

        if ($role == 'M') {
            return view('menu_membre', $data)
                . view('connexion/compte_profil')
                . view('templates/bas2');
        }

        // Optionnel si jamais un rôle inconnu apparaît
        //return redirect()->to(base_url('index.php/compte/connecter'));
    }

    // Pas connecté → retour login
    return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');
}



    public function deconnecter()
    {
        $session=session();
        $session->destroy();
        return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');
    }


    public function afficher_reservation()
    {

        $session=session();
        if ($session->has('user'))
        {
            $pseudo = $session->get('user');

            $model = model(Db_model::class);
            $data['titre']="Liste de toutes les réservations à venir ";
            $data['reserv'] = $model->get_reservation($pseudo);

            return view('menu_administrateur', $data)
            . view('connexion/compte_reservation')
            // .view('templates/milieu')
            . view('templates/bas2');
        }
        return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');
    }

    public function afficher_message()
    {
         $session=session();
        if ($session->has('user'))
        {
            $model = model(Db_model::class);
            $data['titre']="Liste de tous les messages ";
            $data['mes'] = $model->get_all_message();

            return view('menu_administrateur', $data)
            . view('connexion/compte_message')
            // .view('templates/milieu')
            . view('templates/bas2');
        }
        return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');
    }

public function envoyer_reponse($code)
    {

          $session=session();
        if (! $session->has('user') || $session->get('role') != 'A') {
          return redirect()->to(base_url('index.php/compte/connecter'));
        }

        if ($session->has('user'))
        {
        $model = model(Db_model::class);
        $session = session();

        // 🔥 Charger les informations du message
        $info = $model->get_suivi_message($code);

        // Si formulaire envoyé (POST)
        if ($this->request->getMethod() == "POST")
        {
            if (! $this->validate([
                'reponse' => 'required'
            ]))
            {
                // Réaffiche la vue avec erreurs
                return view('menu_administrateur')
                    . view('reponse/reponse_inserer', [
                        'msg_code' => $code,
                        'info' => $info
                    ])
                    . view('templates/bas2');
            }

            // Récupérer la réponse
            $reponse = $this->request->getVar('reponse');

            // Récupérer l’admin connecté
            $pseudo = $session->get('user');

            // ⚡ Enregistrer la réponse + cpt_id admin
            $model->set_reponse_message($code, $reponse, $pseudo);

            return redirect()->to(base_url("index.php/compte/afficher_message"));
        }

        // 🔥 AFFICHAGE du formulaire + infos du message
        return view('menu_administrateur')
            . view('reponse/reponse_inserer', [
                'msg_code' => $code,
                'info' => $info
            ])
            . view('templates/bas2');


            }
        return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');
    }

public function lister_profil_compte()
    {
        $session = session();
        if (! $session->has('user') || $session->get('role') != 'A') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

          
        if ($session->has('user'))
        {
        //$this->model = model(Db_model::class);
    //    $data['titre']="Liste de tous les comptes/profil ";
        $data['profils'] = $this->model->get_all_compte_profil();
       // $data['number'] = $this->model->get_number_compte();

        return view('menu_administrateur', $data)
        . view('compte/compte_creer')
        . view('affichage_comptes')
        . view('templates/bas2');
        }
        return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');
    }

    public function lister_adherents()
    {
        $session = session();
        if (! $session->has('user') || $session->get('role') != 'M') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        
        if ($session->has('user'))
        {
            //$this->model = model(Db_model::class);
        //    $data['titre']="Liste de tous les comptes/profil ";
            $data['adherents'] = $this->model->get_all_adherents();
        // $data['number'] = $this->model->get_number_compte();

            return view('menu_membre', $data)
            . view('affichage_adherent')
            . view('templates/bas2');


        }

        return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');

        
    }


    public function lister_ressources()
    {
        $session = session();
        if (! $session->has('user') || $session->get('role') != 'A') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        if ($session->has('user'))
        {
        //$this->model = model(Db_model::class);
    //    $data['titre']="Liste de tous les comptes/profil ";
        $data['ressources'] = $this->model->get_all_ressource();
       // $data['number'] = $this->model->get_number_compte();

        return view('menu_administrateur', $data)
        
        . view('connexion/compte_ressource')
        . view('templates/bas2');
        }
        return view('templates/haut', ['titre' => 'Se connecter'])
        . view('connexion/compte_connecter')
        . view('templates/bas');
    }

    


  public function creer_ressource()
{
    $session = session();

    // Sécurisation : seulement admin
    if (! $session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

    // Si formulaire envoyé
    if ($this->request->getMethod() == "POST") 
    {
        // 🔥 VALIDATION DES CHAMPS
        if (! $this->validate([
            'nom'        => 'required|min_length[2]|max_length[255]',
            'descriptif' => 'required|min_length[2]',
            'jauge_min'  => 'required|integer',
            'jauge_max'  => 'required|integer',
            'fichier' => [
                'label' => 'Fichier image',
                'rules' => [ 
                    'uploaded[fichier]',
                    'is_image[fichier]',
                    'mime_in[fichier,image/jpg,image/jpeg,image/png,image/webp]',
                    'max_size[fichier,4096]',       // 4 Mo
                ]
            ]
        ],
        [
            'nom' => [
                'required' => 'Veuillez entrer un nom pour la ressource.'
            ],
            'descriptif' => [
                'required' => 'Veuillez entrer un descriptif.'
            ],
            'jauge_min' => [
                'required' => 'Veuillez entrer la jauge minimale.'
            ],
            'jauge_max' => [
                'required' => 'Veuillez entrer la jauge maximale.'
            ],
            'fichier' => [
                'uploaded' => 'Veuillez choisir une image.',
                'is_image' => 'Le fichier doit être une image.',
            ]
        ]))
        {
            $data['ressources'] = $this->model->get_all_ressource();

            // Retour au formulaire avec erreurs
            return view('menu_administrateur')
                . view('ressource/ressource_creer')   // ← TA VUE DU FORMULAIRE
                . view('templates/bas2');
        }

        // 🔥 TRAITEMENT → RÉCUPÉRATION DES DONNÉES
        $nom         = $this->request->getVar('nom');
        $desc        = $this->request->getVar('descriptif');
        $jauge_min   = $this->request->getVar('jauge_min');
        $jauge_max   = $this->request->getVar('jauge_max');

        // 🔥 UPLOAD DE L’IMAGE
        $fichier = $this->request->getFile('fichier');
        $nom_image = $fichier->getRandomName();     // nom unique
        $fichier->move('bootstrap/assets/img', $nom_image);        // déplacement dans /public/images

     $this->model->set_ressource($nom, $desc, $jauge_min, $jauge_max, $nom_image);

        // 🔥 Page de succès
        return view('menu_administrateur')
            . view('ressource/ressource_succes', ['nom' => $nom])
            . view('templates/bas2');
    }
    $data['ressources'] = $this->model->get_all_ressource();
    // 🔥 Sinon : afficher le formulaire
    return view('menu_administrateur')
        . view('ressource/ressource_creer')  // ← TA VUE DU FORMULAIRE  

        . view('templates/bas2');
}



public function supprimer_ressource($id)
{
    $session = session();

    if (! $session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

    $this->model->delete_ressource($id);

    return redirect()->to(base_url('index.php/compte/lister_ressources'));
}




public function reservations_jour()
{
    $session = session();

    // Vérifier que l'utilisateur est connecté (membre ou admin)
    if (! $session->has('user')) {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

    $role = $session->get('role');  // 'M' ou 'A'

    // Sélection du menu en fonction du rôle
    $menu = ($role == 'M') ? 'menu_membre' : 'menu_administrateur';

    // 👉 Si GET : afficher seulement le formulaire avec input date
    if ($this->request->getMethod() == "GET") {
        return view($menu)
            . view('reservation/reservationdate')
            . view('templates/bas2');
    }

    // 👉 Si POST : on récupère la date envoyée par le membre/admin
    $date = $this->request->getVar('date');

    // Charger le modèle
    $model = model(Db_model::class);

    // Appeler la fonction SQL qui retourne les réservations du jour choisi
    $data['reservations'] = $model->get_reservations_by_day($date);
    $data['date'] = $date;

    // Retourner la vue récapitulative
    return view($menu)
        . view('reservation/reservationdatesucces', $data)
        . view('templates/bas2');
}


public function activer_compte($id)
{
    $session = session();

    //  Sécurité : seulement admin
    if (! $session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

    // Appel du modèle
    $this->model->activer_compte((int)$id);

    // Retour à la liste
    return redirect()->to(base_url('index.php/compte/lister_profil_compte'));
}

public function desactiver_compte($id)
{
    $session = session();

    // 🔐 Sécurité : seulement admin
    if (! $session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

    // Appel du modèle
    $this->model->desactiver_compte((int)$id);

    // Retour à la liste
    return redirect()->to(base_url('index.php/compte/lister_profil_compte'));
}



}

