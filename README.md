# ResaWeb – Application de gestion de réservations

## Description

ResaWeb est une application web de gestion de réservations destinée à une association ou à une structure proposant des ressources réservables : salles, équipements, créneaux, activités, réunions, documents ou autres ressources.

L’application permet aux visiteurs, membres et administrateurs de consulter les ressources disponibles, effectuer des réservations, gérer les comptes utilisateurs et administrer l’ensemble des données depuis une interface web.

## Objectifs

L’objectif principal est de centraliser la gestion des réservations afin de remplacer une organisation manuelle ou papier par une solution numérique simple, fiable et accessible.

L’application permet notamment de :

- Consulter les ressources disponibles
- Réserver une ressource en ligne
- Gérer les utilisateurs et les membres
- Administrer les ressources, réunions, documents et actualités
- Éviter les conflits de réservation
- Faciliter le suivi des demandes et des disponibilités

## Fonctionnalités principales

### Visiteurs

Les visiteurs peuvent :

- Accéder à l’application web
- Consulter les informations publiques
- Voir les ressources disponibles
- Remplir un formulaire de contact
- Demander une inscription à l’association

### Membres

Les membres peuvent :

- Se connecter à leur compte
- Consulter les ressources réservables
- Effectuer une réservation
- Consulter leurs réservations
- Modifier ou annuler une réservation selon les règles définies
- Accéder aux documents, réunions et actualités de l’association
- Mettre à jour certaines informations de leur profil

### Administrateurs

Les administrateurs peuvent :

- Se connecter à un espace d’administration
- Gérer les utilisateurs et les membres
- Valider, modifier ou supprimer des comptes
- Ajouter, modifier ou supprimer des ressources
- Gérer les réservations
- Consulter les réservations effectuées
- Gérer les réunions, documents et actualités
- Gérer les demandes de contact
- Superviser l’ensemble de l’application

## Cas d’utilisation

L’application couvre plusieurs cas d’utilisation :

- Authentification d’un administrateur ou d’un membre
- Création, modification et suppression d’un compte
- Ajout d’une ressource réservable
- Modification ou suppression d’une ressource
- Création d’une réservation
- Consultation des réservations
- Annulation ou modification d’une réservation
- Ajout de documents, réunions et actualités
- Consultation des informations publiques par les visiteurs

## Règles métier

- Un utilisateur doit être connecté pour effectuer une réservation.
- Une ressource ne peut pas être réservée deux fois sur le même créneau.
- Une réservation doit être associée à une ressource, un utilisateur et une date.
- Les administrateurs peuvent gérer toutes les réservations.
- Les membres peuvent uniquement gérer leurs propres réservations.
- Certaines actions sensibles sont réservées aux administrateurs.
- Les documents confidentiels ne sont accessibles qu’aux membres autorisés.

## Technologies utilisées

Le projet peut être développé avec les technologies suivantes :

- Frontend : HTML, CSS, JavaScript
- Backend : PHP
- Base de données : MySQL
- Serveur local : XAMPP / WAMP / MAMP
- Versioning : Git et GitLab


