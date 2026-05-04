<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
//$routes->get('/', 'Home::index');


use App\Controllers\Accueil;

//afficher les pseudos
use App\Controllers\Compte;

//afficher les actualites
use App\Controllers\Actualite;

use App\Controllers\Message;


$routes->get('/', [Accueil::class, 'afficher']);

//$routes->get('accueil/afficher/(:segment)', [Accueil::class, 'afficher']);

//afficher les pseudos
$routes->get('compte/lister', [Compte::class, 'lister']);

//afficher les actualites 
$routes->get('actualite/afficher', [Actualite::class, 'afficher']);
$routes->get('actualite/afficher/(:num)', [Actualite::class, 'afficher']);

//suivii message
$routes->get('message/suivre', [Message::class, 'suivre']);
$routes->get('message/suivre/(:segment)', [Message::class, 'suivre']);

//creer un compte 
$routes->get('compte/creer', [Compte::class, 'creer']);
$routes->post('compte/creer', [Compte::class, 'creer']);


//inserer une question

$routes->get('message/inserer', [Message::class, 'inserer']);
$routes->post('message/inserer', [Message::class, 'inserer']);

//verifier la demande en utilisant le champs de saisi 

$routes->get('message/verifier', [Message::class, 'verifier']);
$routes->post('message/verifier', [Message::class, 'verifier']);


$routes->get('compte/connecter', [Compte::class, 'connecter']);
$routes->post('compte/connecter', [Compte::class, 'connecter']);


$routes->get('compte/deconnecter', [Compte::class, 'deconnecter']);
$routes->get('compte/afficher_profil', [Compte::class, 'afficher_profil']);


$routes->get('compte/afficher_reservation', [Compte::class, 'afficher_reservation']);

$routes->get('compte/afficher_message', [Compte::class, 'afficher_message']);




$routes->get('compte/envoyer_reponse/(:segment)', [Compte::class, 'envoyer_reponse']);
$routes->post('compte/envoyer_reponse/(:segment)', [Compte::class, 'envoyer_reponse']);


$routes->get('compte/lister_profil_compte', [Compte::class, 'lister_profil_compte']);

$routes->get('compte/lister_adherents', [Compte::class, 'lister_adherents']);

$routes->get('compte/lister_ressources', [Compte::class, 'lister_ressources']);

$routes->get('compte/creer_ressource', [Compte::class, 'creer_ressource']);
$routes->post('compte/creer_ressource', [Compte::class, 'creer_ressource']);


$routes->get('compte/supprimer_ressource/(:num)', [Compte::class, 'supprimer_ressource']);


$routes->get('compte/reservations_jour', [Compte::class, 'reservations_jour']);
$routes->post('compte/reservations_jour', [Compte::class, 'reservations_jour']);




// Activer un compte
$routes->get('compte/activer_compte/(:num)', [Compte::class, 'activer_compte']);

// Désactiver un compte
$routes->get('compte/desactiver_compte/(:num)',  [Compte::class, 'desactiver_compte']);
