-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : ven. 05 déc. 2025 à 17:13
-- Version du serveur : 10.11.11-MariaDB-0+deb12u1-log
-- Version de PHP : 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `e22307882_db1`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`e22307882sql`@`%` PROCEDURE `activer_compte` (IN `id_compte` INT)   BEGIN
    UPDATE t_compte_cpt
    SET cpt_etat = 'A'
    WHERE cpt_id = id_compte;
END$$

CREATE DEFINER=`e22307882sql`@`%` PROCEDURE `ajouter_message` (IN `subjet` VARCHAR(255), IN `contenu` TEXT, IN `email` VARCHAR(255), IN `codex` VARCHAR(50))   BEGIN
    INSERT INTO t_message_msg(msg_sujet, msg_date, msg_contenu, msg_email, msg_code)
    VALUES (subjet, NOW(), contenu, email, codex);
END$$

CREATE DEFINER=`e22307882sql`@`%` PROCEDURE `desactiver_compte` (IN `id_compte` INT)   BEGIN
    UPDATE t_compte_cpt
    SET cpt_etat = 'D'
    WHERE cpt_id = id_compte;
END$$

CREATE DEFINER=`e22307882sql`@`%` PROCEDURE `gerer_document` (IN `id_reunion` INT)   BEGIN
    DECLARE nb_participants INT;
    DECLARE nom_reunion VARCHAR(255);
    DECLARE nbdocs INT DEFAULT 0;

    SELECT ren_theme INTO nom_reunion FROM t_reunion_ren WHERE ren_id = id_reunion;

    IF nom_reunion IS NOT NULL THEN
        SET nb_participants = get_nombre_inscrits(id_reunion);

        IF nb_participants = -1 THEN
            SET nb_participants = 0;
        END IF;

        SELECT COUNT(*) INTO nbdocs FROM t_document_doc WHERE ren_id = id_reunion;


        IF nbdocs = 0 THEN
            INSERT INTO t_document_doc (ren_id, doc_url, doc_titre)
            VALUES (
                id_reunion,
                'CR en attente',
                CONCAT('CR ', nom_reunion, '-', nb_participants)
            );
        ELSE
            UPDATE t_document_doc
            SET doc_titre = CONCAT('CR ', nom_reunion, '-', nb_participants)
            WHERE ren_id = id_reunion;
        END IF;
    END IF;

END$$

--
-- Fonctions
--
CREATE DEFINER=`e22307882sql`@`%` FUNCTION `get_nombre_inscrits` (`reunion_id` INT) RETURNS INT(11)  BEGIN
DECLARE nb INT;

    IF (SELECT COUNT(*) FROM t_partcipation_par WHERE ren_id=reunion_id) = 0 THEN
        RETURN -1;
    END IF;

    SELECT COUNT(*) INTO nb
    FROM t_partcipation_par
    WHERE ren_id = reunion_id;

    RETURN nb;
END$$

CREATE DEFINER=`e22307882sql`@`%` FUNCTION `liste_email` (`reunion_id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE emails_reunion TEXT;

    SELECT GROUP_CONCAT(pfl_email SEPARATOR '\n ')
    INTO emails_reunion
    FROM t_profil_pfl
    JOIN t_partcipation_par USING (cpt_id)
    WHERE ren_id = reunion_id;

    RETURN emails_reunion;
END$$

CREATE DEFINER=`e22307882sql`@`%` FUNCTION `liste_participants` (`id_res` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE res TEXT;

    SELECT GROUP_CONCAT(CONCAT(pfl_prenom, ' ', pfl_nom) SEPARATOR ', ')
    INTO res
    FROM t_inscription_ins
    JOIN t_compte_cpt USING(cpt_id)
    JOIN t_profil_pfl USING(cpt_id)
    WHERE res_id = id_res;

    RETURN res;
END$$

CREATE DEFINER=`e22307882sql`@`%` FUNCTION `nom_responsable` (`id_res` INT) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
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

-- --------------------------------------------------------

--
-- Structure de la table `t_actualite_act`
--

CREATE TABLE `t_actualite_act` (
  `act_id` int(11) NOT NULL,
  `act_titre` varchar(100) NOT NULL,
  `act_contenu` varchar(600) DEFAULT NULL,
  `act_description` varchar(250) NOT NULL,
  `act_date` datetime NOT NULL,
  `act_etat` char(1) NOT NULL,
  `cpt_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_actualite_act`
--

INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_description`, `act_date`, `act_etat`, `cpt_id`) VALUES
(1, 'Nouveau spectacle de théâtre en mars', 'Découvrez notre nouvelle pièce de théâtre \"Les Échos du Temps\", une aventure captivante à ne pas manquer.', 'Spectacle de théâtre à réserver dès maintenant.', '2025-10-01 18:00:00', 'A', 1),
(2, 'Concert de musique classique', 'Un concert exceptionnel avec l\'orchestre symphonique de la ville, le samedi 12 octobre.', 'Concert à réserver rapidement.', '2025-10-15 20:00:00', 'A', 1),
(3, 'Atelier de peinture pour débutants', 'Initiez-vous aux arts plastiques avec notre atelier encadré par des artistes professionnels.', 'Atelier peinture pour tous niveaux.', '2025-10-10 14:00:00', 'A', 3),
(4, 'Exposition d\'art plastique contemporaine', 'Venez admirer les œuvres contemporaines réalisées par des artistes locaux.', 'Exposition ouverte pendant tout le mois d\'octobre.', '2025-10-15 10:00:00', 'A', 4),
(5, 'Soirée jazz au théâtre', 'Ambiance chaleureuse garantie avec le groupe jazz \"Blue Notes\" pour une soirée unique.', 'Concert jazz au théâtre à réserver.', '2025-10-20 19:30:00', 'A', 5),
(6, 'Projection spéciale de court-métrages locaux', 'Une soirée dédiée à la découverte de talents locaux à travers une sélection de courts-métrages réalisés par de jeunes cinéastes de la région.', 'Découvrez les nouveaux talents du cinéma local lors d’une soirée exceptionnelle.\r\n\r\n', '2025-11-15 20:58:14', 'A', 2),
(7, 'Rencontre littéraire avec un auteur régional', 'Participez à une rencontre privilégiée avec l’auteur invité, qui présentera son dernier ouvrage et échangera avec le public autour de son parcours artistique.', 'Rencontre littéraire suivie d’une séance de dédicace.', '2025-11-15 21:03:23', 'C', 1);

-- --------------------------------------------------------

--
-- Structure de la table `t_association_ast`
--

CREATE TABLE `t_association_ast` (
  `dis_id` int(11) NOT NULL,
  `rsc_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_association_ast`
--

INSERT INTO `t_association_ast` (`dis_id`, `rsc_id`) VALUES
(1, 2),
(2, 4),
(3, 1),
(4, 5),
(7, 1),
(8, 2),
(9, 5);

-- --------------------------------------------------------

--
-- Structure de la table `t_compte_cpt`
--

CREATE TABLE `t_compte_cpt` (
  `cpt_id` int(11) NOT NULL,
  `cpt_mot_de_passe` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `cpt_etat` char(1) NOT NULL,
  `cpt_pseudo` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_compte_cpt`
--

INSERT INTO `t_compte_cpt` (`cpt_id`, `cpt_mot_de_passe`, `cpt_etat`, `cpt_pseudo`) VALUES
(1, '1fe9e80aed363be1fb921c0d0a04e831a14d39fda2c31e04127cdd544328e9ba', 'A', 'principal'),
(2, '53efd835bf5432a33a5db13090cecfe47ea3468267270b4ce62b49dfa56a2452', 'D', 'bernard.b'),
(3, '1669ae9b8d04e4e0a118738192a7edff14d2660037545936e8fd2130f9399303', 'A', 'thomas.c'),
(4, '1e884f4e8f9b67af6e90ef4b923e6abfc953976dea8284c97b16b67346b948f0', 'A', 'robert.d'),
(5, 'bd21a7431efe85e2f2950483fa6502be4a17f03f363813e00a3bb957cc931b6c', 'A', 'richard.e'),
(6, '0dd224eab434df4782f74303371ebdea01469e793eae4c0ed15e5fbb038e85fc', 'A', 'petit.f'),
(7, '6db4c835d3950ef8ae77e2c30935cfe2d1b262354197679a1e3b2a5449e717f1', 'A', 'durand.g'),
(8, '28ca4402ba52892cfb9ec0cb93cc62354eb58f8dcabbb471bee04e6258f9d805', 'A', 'leroy.h'),
(9, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'moreau.i'),
(10, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'simon.j'),
(11, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'laurent.k'),
(12, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'michel.l'),
(13, '27e4aaaab8410c11cff01b215607d699c07df5ea55a504ebfe58b2e83d99dcd2', 'A', 'garcia.m'),
(14, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'david.m'),
(15, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bertrand.n'),
(16, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'roux.o'),
(17, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'vincent.p'),
(18, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'fournier.q'),
(19, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'morel.r'),
(20, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'girard.s'),
(21, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'andre.t'),
(22, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'lambert.u'),
(23, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bonnet.v'),
(24, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'dupuis.w'),
(25, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'francois.x'),
(26, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'henry.y'),
(27, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'aubry.z'),
(28, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'renard.a'),
(29, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'gautier.b'),
(30, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'barbier.c'),
(31, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'martin.d'),
(32, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bernard.e'),
(33, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'thomas.f'),
(34, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'robert.g'),
(35, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'richard.h'),
(36, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'petit.i'),
(37, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'durand.j'),
(38, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'leroy.k'),
(39, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'moreau.l'),
(40, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'simon.m'),
(41, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'laurent.n'),
(42, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'michel.o'),
(43, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'garcia.p'),
(44, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'david.q'),
(45, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bertrand.r'),
(46, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'roux.s'),
(47, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'vincent.t'),
(48, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'fournier.u'),
(49, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'morel.v'),
(50, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'girard.w'),
(51, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'andre.x'),
(52, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'lambert.y'),
(53, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bonnet.z'),
(54, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'dupuis.a'),
(55, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'francois.l'),
(56, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'henry.c'),
(57, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'aubry.m'),
(58, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'renard.m'),
(59, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'gautier.l'),
(60, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'barbier.e'),
(61, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'martin.a'),
(62, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bernard.c'),
(63, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'thomas.d'),
(64, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'robert.e'),
(65, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'richard.f'),
(66, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'petit.g'),
(67, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'durand.h'),
(68, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'leroy.i'),
(69, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'moreau.j'),
(70, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'simon.k'),
(71, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'laurent.l'),
(72, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'michel.m'),
(73, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'garcia.n'),
(74, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'david.o'),
(75, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bertrand.p'),
(76, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'roux.q'),
(77, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'vincent.r'),
(78, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'fournier.s'),
(79, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'morel.s'),
(80, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'girard.t'),
(81, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'andre.u'),
(82, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'lambert.v'),
(83, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bonnet.w'),
(84, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'dupuis.x'),
(85, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'francois.y'),
(86, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'henry.z'),
(87, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'aubry.a'),
(88, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'renard.b'),
(89, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'gautier.z'),
(90, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'barbier.d'),
(91, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'martin.e'),
(92, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bernard.f'),
(93, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'thomas.g'),
(94, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'robert.h'),
(95, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'richard.i'),
(96, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'petit.j'),
(97, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'durand.k'),
(98, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'leroy.l'),
(99, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'moreau.m'),
(100, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'leroy.u'),
(101, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'laurent.o'),
(102, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'michel.p'),
(103, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'garcia.q'),
(104, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'david.r'),
(105, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bertrand.s'),
(106, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'roux.t'),
(107, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'vincent.u'),
(108, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'fournier.v'),
(109, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'morel.w'),
(110, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'girard.x'),
(111, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'andre.y'),
(112, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'lambert.z'),
(113, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bonnet.a'),
(114, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'dupuis.b'),
(115, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'francois.c'),
(116, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'henry.d'),
(117, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'aubry.e'),
(118, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'renard.f'),
(119, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'gautier.g'),
(120, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'barbier.h'),
(121, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'martin.i'),
(122, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bernard.j'),
(123, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'thomas.k'),
(124, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'robert.l'),
(125, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'richard.m'),
(126, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'petit.n'),
(127, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'durand.o'),
(128, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'leroy.p'),
(129, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'moreau.q'),
(130, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'simon.r'),
(131, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'laurent.s'),
(132, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'michel.t'),
(133, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'garcia.u'),
(134, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'david.v'),
(135, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bertrand.w'),
(136, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'roux.x'),
(137, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'vincent.y'),
(138, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'fournier.z'),
(139, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'morel.a'),
(140, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'girard.b'),
(141, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'andre.c'),
(142, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'lambert.d'),
(143, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bonnet.e'),
(144, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'dupuis.f'),
(145, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'francois.g'),
(146, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'henry.h'),
(147, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'aubry.i'),
(148, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'renard.j'),
(149, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'gautier.k'),
(150, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'barbier.l'),
(151, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'martin.m'),
(152, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bernard.n'),
(153, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'D', 'thomas.o'),
(154, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'robert.p'),
(155, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'richard.q'),
(156, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'petit.r'),
(157, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'durand.s'),
(158, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'leroy.t'),
(159, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'moreau.u'),
(160, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'simon.v'),
(161, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'laurent.w'),
(162, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'michel.x'),
(163, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'garcia.y'),
(164, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'david.z'),
(165, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bertrand.a'),
(166, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'roux.b'),
(167, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'vincent.c'),
(168, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'fournier.d'),
(169, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'morel.e'),
(170, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'girard.f'),
(171, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'andre.g'),
(172, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'lambert.h'),
(173, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bonnet.i'),
(174, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'dupuis.j'),
(175, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'francois.k'),
(176, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'henry.l'),
(177, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'aubry.n'),
(178, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'renard.n'),
(179, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'gautier.o'),
(180, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'barbier.p'),
(181, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'martin.q'),
(182, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bernard.r'),
(183, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'thomas.s'),
(184, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'robert.t'),
(185, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'richard.u'),
(186, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'petit.v'),
(187, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'durand.w'),
(188, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'leroy.x'),
(189, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'moreau.y'),
(190, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'simon.z'),
(191, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'laurent.a'),
(192, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'michel.b'),
(193, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'garcia.c'),
(194, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'david.d'),
(195, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bertrand.e'),
(196, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'roux.f'),
(197, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'vincent.g'),
(198, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'fournier.h'),
(199, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'morel.i'),
(200, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'girard.j'),
(201, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'sid.l'),
(202, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'dupont.j'),
(203, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'martin.s'),
(204, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'bernard.p'),
(205, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'hallal.i'),
(206, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'invite1'),
(207, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'invite2'),
(208, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'invite3'),
(209, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'invite4'),
(210, '88d3a3b9400d44230af9bf743cc49433affb86976bad698ab08bbfd760a443cf', 'A', 'invite5'),
(211, '0904b80973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A', 'invite6'),
(212, '0904b80973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A', 'invite7'),
(213, '0904b80973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A', 'invite8'),
(214, '0904b80973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A', 'invite9'),
(215, '0904b80973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A', 'invite10'),
(218, 'aa3d2fe4f6d301dbd6b8fb2d2fddfb7aeebf3bec53ffff4b39a0967afa88c609', 'A', 'invite12'),
(220, '65034b34cb689b59f971d0b44e2eda2c36b2daf27bdf5ffadd2cc22a68831fe8', 'A', 'invite13'),
(221, '66755272d79b0ebd298042640d36319158971721698a01919af46f4c65fba19d', 'A', 'invite14'),
(222, 'a0b7c9664de9a0f5bb9a9ac50d36d0f515fee4df9755f884edcc065ff0a54bfb', 'A', 'invite15'),
(240, 'ba7a0f2c193041f48ccf8276689630cf358de96d2ae570278b13538d0470dbdc', 'A', 'invite100'),
(241, 'ba7a0f2c193041f48ccf8276689630cf358de96d2ae570278b13538d0470dbdc', 'A', 'invite93'),
(244, 'c6af417625c0df41b590b17566e0022bcbab5ca3402e5353e76f8e5679500069', 'A', 'invite56'),
(245, 'bdcb37bcfca803b0f83ecbcd9e91f8b57b4153ab2b797a73cffd0143c8215340', 'A', 'invit\'ee'),
(246, 'b096741720dd6372e0b8328dc16662e330816ce6ca6f31cd222efac6c96530e0', 'A', 'invite67'),
(247, 'ba7a0f2c193041f48ccf8276689630cf358de96d2ae570278b13538d0470dbdc', 'A', 'ivite33'),
(248, '557c741370bd7ee57a7908fa1bcf5e563f901936f24db75fbb7618e1dfd4caac', 'A', 'invite513');

-- --------------------------------------------------------

--
-- Structure de la table `t_document_doc`
--

CREATE TABLE `t_document_doc` (
  `doc_id` int(11) NOT NULL,
  `doc_titre` varchar(100) NOT NULL,
  `doc_url` varchar(250) NOT NULL,
  `ren_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_document_doc`
--

INSERT INTO `t_document_doc` (`doc_id`, `doc_titre`, `doc_url`, `ren_id`) VALUES
(1, 'CR Préparation du Festival de Théâtre-22', 'https://www.fichier-pdf.fr/2011/09/20/programme-theatre-sept-final/download/', 1),
(2, 'CR Organisation des ateliers de chant-0', 'https://www.fichier-pdf.fr/2019/12/16/fascicule-jamc2019/download/', 2),
(6, 'CR Bilan des activités -1 - CR mis en ligne le 21/10/2025', 'toto.pdf', 5),
(7, 'reunion - CR mis en ligne le 21/10/2025', 'reunion6.pdf', 6);

--
-- Déclencheurs `t_document_doc`
--
DELIMITER $$
CREATE TRIGGER `before_update_pdf` BEFORE UPDATE ON `t_document_doc` FOR EACH ROW BEGIN
    -- Vérifie qu'on passe d'un "CR en attente" à un fichier PDF
    IF OLD.doc_url = 'CR en attente'
       AND NEW.doc_url LIKE '%.pdf' THEN

        -- Ajoute la date au titre
        SET NEW.doc_titre = CONCAT(
            NEW.doc_titre,
            ' - CR mis en ligne le ',
            DATE_FORMAT(CURDATE(), '%d/%m/%Y')
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_indisponibilite_dis`
--

CREATE TABLE `t_indisponibilite_dis` (
  `dis_id` int(11) NOT NULL,
  `dis_infosupp` varchar(600) DEFAULT NULL,
  `dis_date_debut` datetime NOT NULL,
  `dis_date_fin` datetime NOT NULL,
  `mot_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_indisponibilite_dis`
--

INSERT INTO `t_indisponibilite_dis` (`dis_id`, `dis_infosupp`, `dis_date_debut`, `dis_date_fin`, `mot_id`) VALUES
(1, 'Travaux de maintenance prévus dans la salle principale', '2025-10-10 08:00:00', '2025-11-12 18:00:00', 1),
(2, 'L’intervenant théâtre a annulé pour raison médicale', '2025-10-15 09:00:00', '2025-10-15 12:00:00', 2),
(3, 'Annulation de l’atelier faute de participants inscrits', '2025-10-18 14:00:00', '2025-10-18 16:00:00', 3),
(4, 'Vidéo projecteur en panne, séance repoussée', '2025-10-20 10:00:00', '2025-10-20 13:00:00', 4),
(6, 'Travaux de maintenance prévus dans la salle principale', '2025-10-10 08:00:00', '2025-10-12 18:00:00', 1),
(7, 'L’intervenant théâtre a annulé pour raison médicale', '2025-10-15 09:00:00', '2025-10-15 12:00:00', 2),
(8, 'Annulation de l’atelier faute de participants inscrits', '2025-10-18 14:00:00', '2025-10-18 16:00:00', 3),
(9, 'Vidéo projecteur en panne, séance repoussée', '2025-10-20 10:00:00', '2025-10-20 13:00:00', 4);

-- --------------------------------------------------------

--
-- Structure de la table `t_inscription_ins`
--

CREATE TABLE `t_inscription_ins` (
  `cpt_id` int(11) NOT NULL,
  `res_id` int(11) NOT NULL,
  `ins_date_inscription` date NOT NULL,
  `ins_role` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_inscription_ins`
--

INSERT INTO `t_inscription_ins` (`cpt_id`, `res_id`, `ins_date_inscription`, `ins_role`) VALUES
(1, 1, '2025-09-25', 'P'),
(1, 2, '2025-12-02', 'P'),
(1, 5, '2025-12-02', 'P'),
(1, 14, '2025-12-02', 'R'),
(2, 2, '2025-12-04', 'R'),
(2, 10, '2025-12-05', 'R'),
(2, 11, '2025-12-02', 'R'),
(3, 2, '2025-11-29', 'P'),
(3, 14, '2025-12-02', 'P'),
(3, 18, '2025-12-02', 'R'),
(4, 1, '2025-11-29', 'P'),
(5, 1, '2025-11-29', 'P'),
(5, 5, '2025-12-02', 'R'),
(9, 1, '2025-11-29', 'R'),
(9, 5, '2025-12-02', 'P'),
(11, 10, '2025-12-02', 'P'),
(11, 14, '2025-12-02', 'P'),
(11, 18, '2025-12-02', 'P'),
(12, 1, '2025-12-02', 'P'),
(12, 4, '2025-12-02', 'P'),
(12, 5, '2025-12-02', 'P'),
(12, 6, '2025-12-02', 'R'),
(12, 8, '2025-12-02', 'P'),
(12, 11, '2025-12-02', 'P'),
(12, 13, '2025-12-02', 'P'),
(12, 15, '2025-12-02', 'R'),
(18, 1, '2025-12-02', 'P'),
(18, 5, '2025-12-02', 'P'),
(18, 6, '2025-12-02', 'P'),
(18, 11, '2025-12-02', 'P'),
(18, 15, '2025-12-02', 'P'),
(19, 2, '2025-12-02', 'P'),
(19, 7, '2025-12-02', 'R'),
(19, 10, '2025-12-02', 'P'),
(19, 16, '2025-12-02', 'R'),
(19, 18, '2025-12-02', 'P'),
(22, 1, '2025-12-02', 'P'),
(22, 6, '2025-12-02', 'P'),
(22, 11, '2025-12-02', 'P'),
(22, 12, '2025-12-02', 'R'),
(23, 4, '2025-12-02', 'P'),
(23, 8, '2025-12-02', 'P'),
(23, 13, '2025-12-02', 'P'),
(25, 2, '2025-12-02', 'P'),
(25, 7, '2025-12-02', 'P'),
(25, 10, '2025-12-02', 'P'),
(25, 14, '2025-12-02', 'P'),
(25, 16, '2025-12-02', 'P'),
(27, 5, '2025-12-02', 'P'),
(27, 15, '2025-12-02', 'P'),
(30, 1, '2025-12-02', 'P'),
(30, 6, '2025-12-02', 'P'),
(30, 11, '2025-12-02', 'P'),
(30, 12, '2025-12-02', 'P'),
(33, 2, '2025-12-02', 'P'),
(33, 7, '2025-12-02', 'P'),
(33, 10, '2025-12-02', 'P'),
(33, 14, '2025-12-02', 'P'),
(33, 15, '2025-12-02', 'P'),
(33, 16, '2025-12-02', 'P'),
(33, 18, '2025-12-02', 'P'),
(40, 7, '2025-12-02', 'P'),
(41, 4, '2025-12-02', 'P'),
(41, 6, '2025-12-02', 'P'),
(41, 8, '2025-12-02', 'P'),
(41, 13, '2025-12-02', 'P'),
(41, 15, '2025-12-02', 'P'),
(44, 18, '2025-12-02', 'P'),
(45, 1, '2025-12-02', 'P'),
(45, 10, '2025-12-02', 'P'),
(45, 11, '2025-12-02', 'P'),
(45, 14, '2025-12-02', 'P'),
(47, 2, '2025-12-02', 'P'),
(47, 7, '2025-12-02', 'P'),
(47, 12, '2025-12-02', 'P'),
(47, 16, '2025-12-02', 'P'),
(50, 2, '2025-12-02', 'P'),
(52, 1, '2025-12-02', 'P'),
(52, 6, '2025-12-02', 'P'),
(52, 11, '2025-12-02', 'P'),
(52, 15, '2025-12-02', 'P'),
(57, 5, '2025-12-02', 'P'),
(57, 18, '2025-12-02', 'P'),
(58, 4, '2025-12-02', 'P'),
(58, 7, '2025-12-02', 'P'),
(58, 10, '2025-12-02', 'P'),
(58, 12, '2025-12-02', 'P'),
(58, 13, '2025-12-02', 'P'),
(58, 16, '2025-12-02', 'P'),
(60, 2, '2025-12-02', 'P'),
(60, 6, '2025-12-02', 'P'),
(60, 12, '2025-12-02', 'P'),
(60, 14, '2025-12-02', 'P'),
(60, 18, '2025-12-02', 'P'),
(69, 4, '2025-12-02', 'P'),
(69, 8, '2025-12-02', 'P'),
(69, 12, '2025-12-02', 'P'),
(69, 15, '2025-12-02', 'P'),
(69, 16, '2025-12-02', 'P'),
(71, 1, '2025-12-02', 'P'),
(71, 5, '2025-12-02', 'P'),
(71, 7, '2025-12-02', 'P'),
(72, 2, '2025-12-02', 'P'),
(72, 10, '2025-12-02', 'P'),
(72, 14, '2025-12-02', 'P'),
(75, 8, '2025-12-02', 'P'),
(75, 12, '2025-12-02', 'P'),
(75, 13, '2025-12-02', 'P'),
(76, 4, '2025-12-02', 'P'),
(83, 1, '2025-12-02', 'P'),
(83, 6, '2025-12-02', 'P'),
(83, 11, '2025-12-02', 'P'),
(83, 12, '2025-12-02', 'P'),
(83, 13, '2025-12-02', 'P'),
(83, 15, '2025-12-02', 'P'),
(83, 16, '2025-12-02', 'P'),
(84, 2, '2025-12-02', 'P'),
(84, 10, '2025-12-02', 'P'),
(86, 5, '2025-12-02', 'P'),
(86, 7, '2025-12-02', 'P'),
(88, 4, '2025-12-02', 'P'),
(88, 8, '2025-12-02', 'P'),
(91, 6, '2025-12-02', 'P'),
(91, 11, '2025-12-02', 'P'),
(91, 14, '2025-12-02', 'P'),
(91, 18, '2025-12-02', 'P'),
(95, 4, '2025-12-02', 'P'),
(95, 8, '2025-12-02', 'P'),
(95, 12, '2025-12-02', 'P'),
(95, 13, '2025-12-02', 'P'),
(95, 15, '2025-12-02', 'P'),
(101, 1, '2025-12-02', 'P'),
(102, 7, '2025-12-02', 'P'),
(102, 16, '2025-12-02', 'P'),
(102, 18, '2025-12-02', 'P'),
(103, 5, '2025-12-02', 'P'),
(103, 6, '2025-12-02', 'P'),
(110, 11, '2025-12-02', 'P'),
(110, 15, '2025-12-02', 'P'),
(112, 4, '2025-12-02', 'P'),
(112, 8, '2025-12-02', 'P'),
(112, 13, '2025-12-02', 'P'),
(115, 7, '2025-12-02', 'P'),
(115, 18, '2025-12-02', 'P'),
(119, 14, '2025-12-02', 'P'),
(121, 10, '2025-12-02', 'P'),
(121, 16, '2025-12-02', 'P'),
(130, 8, '2025-12-02', 'P'),
(130, 13, '2025-12-02', 'P'),
(140, 1, '2025-11-30', 'P'),
(140, 4, '2025-12-02', 'R'),
(140, 8, '2025-12-02', 'R'),
(140, 12, '2025-12-02', 'P'),
(140, 13, '2025-12-02', 'R'),
(140, 16, '2025-12-02', 'P');

--
-- Déclencheurs `t_inscription_ins`
--
DELIMITER $$
CREATE TRIGGER `inscription_date_auto` BEFORE INSERT ON `t_inscription_ins` FOR EACH ROW BEGIN
    SET NEW.ins_date_inscription = CURRENT_DATE();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_message_msg`
--

CREATE TABLE `t_message_msg` (
  `msg_id` int(11) NOT NULL,
  `msg_sujet` varchar(100) NOT NULL,
  `msg_date` datetime NOT NULL,
  `msg_contenu` varchar(600) NOT NULL,
  `msg_email` varchar(250) NOT NULL,
  `msg_reponse` varchar(600) DEFAULT NULL,
  `msg_code` char(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `cpt_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_message_msg`
--

INSERT INTO `t_message_msg` (`msg_id`, `msg_sujet`, `msg_date`, `msg_contenu`, `msg_email`, `msg_reponse`, `msg_code`, `cpt_id`) VALUES
(1, 'Demande d\'informations sur les spectacles', '2025-09-28 11:15:00', 'Bonjour, faut-il réserver à l’avance pour assister aux spectacles de théâtre ?', 'marie.dupont@gmail.com', NULL, '568794b59f21a6bde123', NULL),
(2, 'Question sur les ateliers pour enfants', '2025-09-28 15:50:00', 'Bonjour, proposez-vous des activités artistiques pour les enfants de moins de 10 ans ?', 'alex.martin@hotmail.org', 'Bonjour, oui on propose des activités pour les enfants de moins de 10 ans .', '6aaa94b59f21a6bde348', 1),
(3, 'Horaires ouverture jours fériés', '2025-10-23 00:00:00', 'bonjour, j\'aimerai connaitre vos horaires d\'ouverture en jours fériés svp', 'contact.service@gmail.com', 'bonjour, on est ouvert aux horaires habituelles', '6sad13259f09a6bde874', 2),
(24, 'l\'adhésion', '2025-11-18 15:04:04', 'prix?', 'vm@toto.fr', 'test\r\n', '58258fdca21e0ae285d6', 1),
(27, 'Demande sur les ateliers de danse', '2025-12-02 22:33:29', 'Bonjour, est-ce que vos ateliers de danse sont accessibles aux débutants ?', 'emma.danse@gmail.com', 'edjifjc\'ncjedkc', 'MSG001-ABCDEFGH11234', 1),
(28, 'Horaires d\'ouverture le week-end', '2025-12-02 22:33:29', 'Bonjour, pouvez-vous me confirmer les horaires du centre le samedi matin ?', 'marc.weekend@gmail.com', 'Bonjour, nous sommes ouverts de 9h à 12h le samedi matin.', 'vdg001-ABCDEFGH11234', 12),
(29, 'Informations matériel studio musique', '2025-12-02 22:33:29', 'Bonjour, le studio de musique possède-t-il une batterie complète ?', 'julien.music@gmail.com', NULL, 'qos001-ABCDEFGH11234', 45),
(30, 'Réservation salle polyvalente', '2025-12-02 22:33:29', 'Bonjour, peut-on réserver la salle polyvalente pour un événement privé ?', 'sarah.event@gmail.com', 'Oui, la salle polyvalente peut être réservée. Merci de préciser votre date.', 'MSG001-ABCDEFGH11plm', 3),
(31, 'Tarifs des ateliers peinture', '2025-12-02 22:33:29', 'Bonjour, quels sont les tarifs pour les ateliers de peinture adultes ?', 'ines.art@gmail.com', NULL, 'huhop1-ABCDEFGH11234', NULL),
(32, 'Problème d\'inscription en ligne', '2025-12-02 22:33:29', 'Je n’arrive pas à finaliser mon inscription. Le bouton reste grisé.', 'contact.user@gmail.com', 'Bonjour, merci de réessayer. Le problème est normalement résolu.', 'MSG040-ghCDEFGH112lk', 58),
(33, 'Annulation séance théâtre', '2025-12-02 22:33:29', 'La séance de théâtre prévue ce mercredi est-elle maintenue ?', 'antoine.theatre@gmail.com', NULL, 'gng001-fBCDEFGH11234', NULL),
(34, 'Accès aux documents PDF', '2025-12-02 22:33:29', 'Je n’arrive pas à ouvrir les comptes rendus. Avez-vous un lien alternatif ?', 'lucie.docs@gmail.com', 'Bonjour, les liens ont été mis à jour. Merci de réessayer.', 'MSG001-xxccEFGH11234', 1),
(36, 'l\'adhésion', '2025-12-03 17:11:22', 'c\'est cher ', 'jaber@gmail.com', 'c\'est tres tres cher ', '45db5ac7ee3c0dc96feb', 1);

-- --------------------------------------------------------

--
-- Structure de la table `t_motif_mot`
--

CREATE TABLE `t_motif_mot` (
  `mot_id` int(11) NOT NULL,
  `mot_motif` varchar(600) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_motif_mot`
--

INSERT INTO `t_motif_mot` (`mot_id`, `mot_motif`) VALUES
(1, 'Indisponibilité de la salle'),
(2, 'Annulation de l’intervenant'),
(3, 'Problème technique ou matériel'),
(4, 'Raison personnelle');

-- --------------------------------------------------------

--
-- Structure de la table `t_partcipation_par`
--

CREATE TABLE `t_partcipation_par` (
  `ren_id` int(11) NOT NULL,
  `cpt_id` int(11) NOT NULL,
  `par_date_inscription` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_partcipation_par`
--

INSERT INTO `t_partcipation_par` (`ren_id`, `cpt_id`, `par_date_inscription`) VALUES
(1, 1, '2025-09-01 10:00:00'),
(1, 2, '2025-09-05 14:30:00'),
(1, 50, '2025-10-21 14:26:32'),
(1, 51, '2025-10-21 14:26:32'),
(1, 52, '2025-10-21 14:26:32'),
(1, 54, '2025-10-21 14:26:32'),
(1, 55, '2025-10-21 14:26:32'),
(1, 56, '2025-10-21 14:26:32'),
(1, 57, '2025-10-21 14:26:32'),
(1, 58, '2025-10-21 14:26:32'),
(1, 59, '2025-10-21 14:26:32'),
(1, 60, '2025-10-21 14:26:32'),
(1, 101, '2025-10-21 14:25:18'),
(1, 102, '2025-10-21 14:25:18'),
(1, 103, '2025-10-21 14:25:18'),
(1, 104, '2025-10-21 14:25:18'),
(1, 105, '2025-10-21 14:25:18'),
(1, 106, '2025-10-21 14:25:18'),
(1, 107, '2025-10-21 14:25:18'),
(1, 108, '2025-10-21 14:25:18'),
(1, 109, '2025-10-21 14:25:18'),
(1, 110, '2025-10-21 14:25:18'),
(5, 5, '2025-09-15 11:20:00'),
(6, 101, '2025-10-21 14:22:28'),
(6, 102, '2025-10-21 14:22:28'),
(6, 103, '2025-10-21 14:22:28'),
(6, 104, '2025-10-21 14:22:28'),
(6, 105, '2025-10-21 14:22:28'),
(6, 106, '2025-10-21 14:22:28'),
(6, 107, '2025-10-21 14:22:28'),
(6, 108, '2025-10-21 14:22:28'),
(6, 109, '2025-10-21 14:22:28'),
(6, 110, '2025-10-21 14:22:28');

--
-- Déclencheurs `t_partcipation_par`
--
DELIMITER $$
CREATE TRIGGER `trg_update_document_after_participation` AFTER INSERT ON `t_partcipation_par` FOR EACH ROW BEGIN

    CALL gerer_document(NEW.ren_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_profil_pfl`
--

CREATE TABLE `t_profil_pfl` (
  `pfl_nom` varchar(80) NOT NULL,
  `pfl_prenom` varchar(80) NOT NULL,
  `pfl_date_de_naissance` date NOT NULL,
  `pfl_email` varchar(250) NOT NULL,
  `pfl_numero_de_telephone` char(12) NOT NULL,
  `pfl_role` char(1) NOT NULL,
  `pfl_adresse` varchar(250) NOT NULL,
  `vil_code_postal` char(5) NOT NULL,
  `cpt_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_profil_pfl`
--

INSERT INTO `t_profil_pfl` (`pfl_nom`, `pfl_prenom`, `pfl_date_de_naissance`, `pfl_email`, `pfl_numero_de_telephone`, `pfl_role`, `pfl_adresse`, `vil_code_postal`, `cpt_id`) VALUES
('Sidennas', 'Lina', '2004-03-15', 'linasidennas5@gmail.com', '0783084173', 'A', 'rue de saint-brieuc', '29200', 1),
('Bernard', 'Bruno', '1979-11-02', 'bruno.bernard2@gmail.com', '0623456702', 'M', '5 avenue Victor Hugo', '75001', 2),
('Thomas', 'Claire', '1992-06-18', 'claire.thomas3@gmail.com', '0634567803', 'A', '3 boulevard Saint-Michel', '75001', 3),
('Robert', 'Damien', '1988-01-25', 'damien.robert4@gmail.com', '0645678904', 'M', '8 rue Lafayette', '75001', 4),
('Richard', 'Emma', '1990-09-10', 'emma.richard5@gmail.com', '0656789005', 'A', '10 rue Carnot', '75001', 5),
('Petit', 'Fabien', '1984-07-30', 'fabien.petit6@gmail.com', '0667890106', 'A', '20 avenue Foch', '75001', 6),
('Durand', 'Giselle', '1977-05-16', 'giselle.durand7@gmail.com', '0678901207', 'M', '15 rue de la République', '75001', 7),
('Leroy', 'Hugo', '1993-12-01', 'hugo.leroy8@gmail.com', '0689012308', 'M', '7 rue des Martyrs', '75001', 8),
('Moreau', 'Ines', '1985-04-04', 'ines.moreau9@gmail.com', '0690123409', 'M', '14 boulevard Haussmann', '75001', 9),
('Simon', 'Julien', '1982-10-20', 'julien.simon10@gmail.com', '0711234510', 'M', '9 rue Saint-Denis', '75001', 10),
('Laurent', 'Karine', '1991-02-13', 'karine.laurent11@gmail.com', '0722345611', 'M', '22 rue du Faubourg', '75001', 11),
('Michel', 'Louis', '1987-08-05', 'louis.michel12@gmail.com', '0613456712', 'M', '18 avenue Jean Jaurès', '75001', 12),
('Garcia', 'Manon', '1994-03-27', 'manon.garcia13@gmail.com', '0624567813', 'M', '5 place de la République', '75001', 13),
('David', 'Marc', '1980-06-19', 'marc.david14@gmail.com', '0635678914', 'M', '12 rue des Fleurs', '75001', 14),
('Bertrand', 'Nina', '1989-11-08', 'nina.bertrand15@gmail.com', '0646789015', 'M', '6 avenue Victor Hugo', '75001', 15),
('Roux', 'Olivier', '1978-01-30', 'olivier.roux16@gmail.com', '0657890126', 'M', '9 rue de la Paix', '75001', 16),
('Vincent', 'Pauline', '1983-09-14', 'pauline.vincent17@gmail.com', '0668901237', 'M', '14 boulevard Voltaire', '75001', 17),
('Fournier', 'Quentin', '1990-05-02', 'quentin.fournier18@gmail.com', '0679012348', 'M', '10 rue Lafayette', '75001', 18),
('Morel', 'Rania', '1986-12-21', 'rania.morel19@gmail.com', '0680123459', 'M', '20 avenue Foch', '75001', 19),
('Girard', 'Sami', '1992-07-09', 'sami.girard20@gmail.com', '0691234560', 'M', '11 place de la Bastille', '75001', 20),
('Andre', 'Tania', '1985-03-15', 'tania.andre21@gmail.com', '0612345611', 'M', '4 rue du Bac', '75001', 21),
('Lambert', 'Ugo', '1976-10-28', 'ugo.lambert22@gmail.com', '0623456722', 'M', '2 rue de l\'Université', '75001', 22),
('Bonnet', 'Valerie', '1993-01-07', 'valerie.bonnet23@gmail.com', '0634566833', 'M', '6 rue de Seine', '75001', 23),
('Dupuis', 'William', '1981-04-18', 'william.dupuis24@gmail.com', '0645676944', 'M', '1 rue du Pont Neuf', '75001', 24),
('Francois', 'Xavier', '1979-09-29', 'xavier.francois25@gmail.com', '0656787055', 'M', '8 rue Mabillon', '75001', 25),
('Henry', 'Yasmine', '1988-02-02', 'yasmine.henry26@gmail.com', '0667897166', 'M', '3 rue de l\'Odéon', '75001', 26),
('Aubry', 'Ziad', '1991-11-19', 'ziad.aubry27@gmail.com', '0678907277', 'M', '9 avenue d\'Italie', '75001', 27),
('Renard', 'Alice', '1984-06-03', 'alice.renard28@gmail.com', '0689017388', 'M', '20 rue du Lycée', '75001', 28),
('Gautier', 'Bruno', '1977-07-27', 'bruno.gautier29@gmail.com', '0690127499', 'M', '21 rue de la Paix', '75001', 29),
('Barbier', 'Claire', '1990-08-16', 'claire.barbier30@gmail.com', '0711234512', 'M', '5 rue du Temple', '75001', 30),
('Martin', 'Damien', '1982-12-05', 'damien.martin31@gmail.com', '0722345613', 'M', '16 rue Montorgueil', '75001', 31),
('Bernard', 'Emma', '1994-04-10', 'emma.bernard32@gmail.com', '0613456714', 'M', '28 rue de Turbigo', '75001', 32),
('Thomas', 'Fabien', '1987-03-21', 'fabien.thomas33@gmail.com', '0624567815', 'M', '33 rue Réaumur', '75001', 33),
('Robert', 'Giselle', '1985-05-06', 'giselle.robert34@gmail.com', '0635678916', 'M', '12 rue des Archives', '75001', 34),
('Richard', 'Hugo', '1978-09-12', 'hugo.richard35@gmail.com', '0646789017', 'M', '7 rue Saint-Honoré', '75001', 35),
('Petit', 'Ines', '1992-10-03', 'ines.petit36@gmail.com', '0657890128', 'M', '4 avenue de Breteuil', '75001', 36),
('Durand', 'Julien', '1983-02-14', 'julien.durand37@gmail.com', '0668901239', 'M', '2 rue de Sèvres', '75001', 37),
('Leroy', 'Karine', '1989-08-25', 'karine.leroy38@gmail.com', '0679012350', 'M', '10 rue de la Convention', '75001', 38),
('Moreau', 'Louis', '1980-01-18', 'louis.moreau39@gmail.com', '0680123461', 'M', '18 rue de la Roquette', '75001', 39),
('Simon', 'Manon', '1991-06-07', 'manon.simon40@gmail.com', '0691234572', 'M', '27 rue de Belleville', '75001', 40),
('Laurent', 'Nicolas', '1975-07-20', 'nicolas.laurent41@gmail.com', '0612345623', 'M', '8 rue de la Harpe', '75001', 41),
('Michel', 'Océane', '1993-09-30', 'oceane.michel42@gmail.com', '0623456734', 'M', '14 quai de la Mégisserie', '75001', 42),
('Garcia', 'Paul', '1986-11-11', 'paul.garcia43@gmail.com', '0634566845', 'M', '29 rue de Richelieu', '75001', 43),
('David', 'Quentin', '1984-02-26', 'quentin.david44@gmail.com', '0645676956', 'M', '17 rue du Faubourg Poissonnière', '75001', 44),
('Bertrand', 'Roxane', '1990-05-04', 'roxane.bertrand45@gmail.com', '0656787067', 'M', '6 rue du Cherche-Midi', '75001', 45),
('Roux', 'Sophie', '1988-12-31', 'sophie.roux46@gmail.com', '0667897178', 'M', '11 rue de l\'Annonciation', '75001', 46),
('Vincent', 'Tom', '1992-08-22', 'tom.vincent47@gmail.com', '0678907289', 'M', '3 place Vendôme', '75001', 47),
('Fournier', 'Ulysse', '1981-03-09', 'ulysse.fournier48@gmail.com', '0689017400', 'M', '36 rue du Bac', '75001', 48),
('Morel', 'Valerie', '1977-10-14', 'valerie.morel49@gmail.com', '0690127511', 'M', '2 rue des Capucines', '75001', 49),
('Girard', 'William', '1985-01-29', 'william.girard50@gmail.com', '0711234520', 'M', '44 rue des Francs Bourgeois', '75001', 50),
('Andre', 'Xavier', '1990-04-13', 'xavier.andre51@gmail.com', '0722345621', 'M', '9 rue de la Roquette', '75001', 51),
('Lambert', 'Yasmina', '1983-12-24', 'yasmina.lambert52@gmail.com', '0613456732', 'M', '21 rue de l\'Université', '75001', 52),
('Bonnet', 'Zoe', '1991-06-16', 'zoe.bonnet53@gmail.com', '0624566843', 'M', '8 rue des Gravilliers', '75001', 53),
('Dupuis', 'Anthony', '1979-08-08', 'anthony.dupuis54@gmail.com', '0635676954', 'M', '20 rue de la Harpe', '75001', 54),
('Francois', 'Lea', '1987-05-01', 'lea.francois55@gmail.com', '0646787065', 'M', '30 boulevard Saint-Germain', '75001', 55),
('Henry', 'Chloe', '1992-09-09', 'chloe.henry56@gmail.com', '0657890176', 'M', '6 rue du Général Leclerc', '75001', 56),
('Aubry', 'Maxime', '1984-11-03', 'maxime.aubry57@gmail.com', '0668901287', 'M', '12 avenue Mac-Mahon', '75001', 57),
('Renard', 'Mathilde', '1990-02-17', 'mathilde.renard58@gmail.com', '0679012398', 'M', '14 rue de la Paix', '75001', 58),
('Gautier', 'Lina', '1982-07-21', 'cyril.gautier59@gmail.com', '0680123409', 'M', '5 rue des Pyramides', '75001', 59),
('Barbier', 'Elodie', '1993-03-02', 'elodie.barbier60@gmail.com', '0691234520', 'M', '7 rue Oberkampf', '75001', 60),
('Martin', 'Alexandre', '1985-10-12', 'alexandre.martin61@gmail.com', '0612345631', 'M', '10 rue de Siam', '29200', 61),
('Bernard', 'Camille', '1991-01-19', 'camille.bernard62@gmail.com', '0623456742', 'M', '4 rue Saint-Louis', '29200', 62),
('Thomas', 'Denis', '1978-04-26', 'denis.thomas63@gmail.com', '0634566853', 'M', '6 rue de Lyon', '29200', 63),
('Robert', 'Emilie', '1989-06-30', 'emilie.robert64@gmail.com', '0645676964', 'M', '12 rue de Strasbourg', '29200', 64),
('Richard', 'Fabien', '1983-09-15', 'fabien.richard65@gmail.com', '0656787075', 'M', '18 rue de Kerbabu', '29200', 65),
('Petit', 'Gaelle', '1990-12-08', 'gaelle.petit66@gmail.com', '0667897186', 'M', '22 rue Jean Jaurès', '29200', 66),
('Durand', 'Hugo', '1984-02-02', 'hugo.durand67@gmail.com', '0678907297', 'M', '2 rue Malherbe', '29200', 67),
('Leroy', 'Iris', '1992-11-11', 'iris.leroy68@gmail.com', '0689017308', 'M', '9 rue Yves Collet', '29200', 68),
('Moreau', 'Julien', '1979-07-07', 'julien.moreau69@gmail.com', '0690127419', 'M', '14 quai de la Douane', '29200', 69),
('Simon', 'Karim', '1986-05-03', 'karim.simon70@gmail.com', '0711234530', 'M', '3 rue Jean Macé', '29200', 70),
('Laurent', 'Lea', '1993-08-21', 'lea.laurent71@gmail.com', '0722345631', 'M', '6 rue de la Porte', '29200', 71),
('Michel', 'Marc', '1980-03-01', 'marc.michel72@gmail.com', '0613456742', 'M', '1 place de la Liberté', '29200', 72),
('Garcia', 'Nora', '1987-10-14', 'nora.garcia73@gmail.com', '0624566853', 'M', '5 rue des Chapeliers', '29200', 73),
('David', 'Olivier', '1976-12-05', 'olivier.david74@gmail.com', '0635676964', 'M', '8 rue de Siam', '29200', 74),
('Bertrand', 'Pauline', '1991-04-28', 'pauline.bertrand75@gmail.com', '0646787075', 'M', '11 rue de Pontaniou', '29200', 75),
('Roux', 'Quentin', '1988-09-12', 'quentin.roux76@gmail.com', '0657897186', 'M', '19 rue de Brest', '29200', 76),
('Vincent', 'Roxane', '1990-02-20', 'roxane.vincent77@gmail.com', '0668907297', 'M', '20 rue Saint-Malo', '29200', 77),
('Fournier', 'Samuel', '1982-06-06', 'samuel.fournier78@gmail.com', '0679017308', 'M', '2 rue d\'Aiguillon', '29200', 78),
('Morel', 'Sophie', '1994-03-09', 'sophie.morel79@gmail.com', '0680127419', 'M', '7 rue Jean Jaurès', '29200', 79),
('Girard', 'Thomas', '1979-11-29', 'thomas.girard80@gmail.com', '0691234530', 'M', '4 rue de la Paix', '29200', 80),
('Andre', 'Ursula', '1986-01-18', 'ursula.andre81@gmail.com', '0711234541', 'M', '12 rue Amiral Ronarc\'h', '29200', 81),
('Lambert', 'Victor', '1992-07-25', 'victor.lambert82@gmail.com', '0722345642', 'M', '3 rue du Château', '29200', 82),
('Bonnet', 'Wendy', '1985-05-05', 'wendy.bonnet83@gmail.com', '0613456753', 'M', '6 rue de la Porte', '29200', 83),
('Dupuis', 'Xavier', '1977-02-14', 'xavier.dupuis84@gmail.com', '0624566864', 'M', '8 rue de Siam', '29200', 84),
('Francois', 'Yves', '1983-08-30', 'yves.francois85@gmail.com', '0635676975', 'M', '10 rue Jean Jaurès', '29200', 85),
('Henry', 'Zoé', '1990-10-09', 'zoe.henry86@gmail.com', '0646787086', 'M', '14 rue Saint-Malo', '29200', 86),
('Aubry', 'Adrien', '1981-04-02', 'adrien.aubry87@gmail.com', '0657897197', 'M', '2 rue de Kerbabu', '29200', 87),
('Renard', 'Baptiste', '1989-12-12', 'baptiste.renard88@gmail.com', '0668907208', 'M', '9 quai des Carmes', '29200', 88),
('Gautier', 'Zohra', '1991-03-19', 'celine.gautier89@gmail.com', '0679017319', 'M', '16 rue de Siam', '29200', 89),
('Barbier', 'Damien', '1978-09-03', 'damien.barbier90@gmail.com', '0680127420', 'M', '21 rue de Pontaniou', '29200', 90),
('Martin', 'Elise', '1987-11-11', 'elise.martin91@gmail.com', '0691234541', 'M', '6 rue de la Paix', '75001', 91),
('Bernard', 'Florian', '1984-06-06', 'florian.bernard92@gmail.com', '0711234552', 'M', '2 rue de la Banque', '75001', 92),
('Thomas', 'Gilles', '1979-01-20', 'gilles.thomas93@gmail.com', '0722345653', 'M', '30 rue La Fayette', '75001', 93),
('Robert', 'Helene', '1990-02-14', 'helene.robert94@gmail.com', '0613456764', 'M', '8 rue des Lombards', '75001', 94),
('Richard', 'Isabelle', '1983-07-22', 'isabelle.richard95@gmail.com', '0624566875', 'M', '4 rue de Rivoli', '75001', 95),
('Petit', 'Jules', '1992-10-01', 'jules.petit96@gmail.com', '0635676986', 'M', '11 rue du Bac', '75001', 96),
('Durand', 'Katia', '1986-04-27', 'katia.durand97@gmail.com', '0646787097', 'M', '7 rue de Varenne', '75001', 97),
('Leroy', 'Leo', '1978-12-08', 'leo.leroy98@gmail.com', '0657897108', 'M', '1 rue de Madrid', '75001', 98),
('Moreau', 'Manuel', '1985-05-30', 'manuel.moreau99@gmail.com', '0668907219', 'M', '10 rue des Capucines', '75001', 99),
('Laurent', 'Oceane', '1991-03-03', 'oceane.laurent101@gmail.com', '0680127431', 'M', '16 rue de Bretagne', '75001', 101),
('Michel', 'Pascal', '1976-09-19', 'pascal.michel102@gmail.com', '0691234552', 'M', '5 rue du Dragon', '75001', 102),
('Garcia', 'Quitterie', '1988-01-26', 'quitterie.garcia103@gmail.com', '0711234563', 'M', '12 rue Mandar', '75001', 103),
('David', 'Raphael', '1982-05-14', 'raphael.david104@gmail.com', '0722345664', 'M', '22 rue de Tolbiac', '75001', 104),
('Bertrand', 'Sophie', '1990-11-30', 'sophie.bertrand105@gmail.com', '0613456775', 'M', '3 rue de Vaugirard', '75001', 105),
('Roux', 'Thomas', '1984-07-07', 'thomas.roux106@gmail.com', '0624566886', 'M', '9 rue de la Pompe', '75001', 106),
('Vincent', 'Ursule', '1993-12-21', 'ursule.vincent107@gmail.com', '0635676997', 'M', '2 rue de la Faisanderie', '75001', 107),
('Fournier', 'Valentin', '1977-04-05', 'valentin.fournier108@gmail.com', '0646787108', 'M', '14 rue Lemercier', '75001', 108),
('Morel', 'Wendy', '1989-02-28', 'wendy.morel109@gmail.com', '0657897219', 'M', '18 rue des Thermopyles', '75001', 109),
('Girard', 'Xavier', '1981-10-06', 'xavier.girard110@gmail.com', '0668907320', 'M', '27 rue de Bagnolet', '75001', 110),
('Andre', 'Yseult', '1990-06-12', 'yseult.andre111@gmail.com', '0679017431', 'M', '6 rue du Regard', '75001', 111),
('Lambert', 'Zinedine', '1983-09-01', 'zinedine.lambert112@gmail.com', '0680127542', 'M', '4 rue de Richelieu', '75001', 112),
('Bonnet', 'Aline', '1979-12-14', 'aline.bonnet113@gmail.com', '0691234563', 'M', '3 rue Saint-André des Arts', '75001', 113),
('Dupuis', 'Brice', '1986-08-24', 'brice.dupuis114@gmail.com', '0711234574', 'M', '7 rue de la Huchette', '75001', 114),
('Francois', 'Coralie', '1992-03-11', 'coralie.francois115@gmail.com', '0722345675', 'M', '10 rue des Saints-Pères', '75001', 115),
('Henry', 'Denise', '1985-07-17', 'denise.henry116@gmail.com', '0613456786', 'M', '20 rue de l\'Université', '75001', 116),
('Aubry', 'Ethan', '1991-02-06', 'ethan.aubry117@gmail.com', '0624566897', 'M', '15 rue de Bourgogne', '75001', 117),
('Renard', 'Fleur', '1988-11-25', 'fleur.renard118@gmail.com', '0635677008', 'M', '9 rue Royale', '75001', 118),
('Gautier', 'Gilles', '1978-05-29', 'gilles.gautier119@gmail.com', '0646787119', 'M', '2 rue de la Michodière', '75001', 119),
('Barbier', 'Hannah', '1993-01-02', 'hannah.barbier120@gmail.com', '0657897220', 'M', '18 rue du Faubourg Montmartre', '75001', 120),
('Martin', 'Igor', '1982-10-19', 'igor.martin121@gmail.com', '0668907331', 'M', '12 rue de la Chaussée d\'Antin', '75001', 121),
('Bernard', 'Julie', '1987-04-04', 'julie.bernard122@gmail.com', '0679017442', 'M', '4 rue du Jardin des Plantes', '75001', 122),
('Thomas', 'Kevin', '1990-09-09', 'kevin.thomas123@gmail.com', '0680127553', 'M', '29 rue des Francs Bourgeois', '75001', 123),
('Robert', 'Lea', '1984-06-30', 'lea.robert124@gmail.com', '0691234564', 'M', '17 avenue de l\'Opéra', '75001', 124),
('Richard', 'Maxime', '1979-03-15', 'maxime.richard125@gmail.com', '0711234575', 'M', '3 rue de la Convention', '75001', 125),
('Petit', 'Nora', '1991-12-20', 'nora.petit126@gmail.com', '0722345676', 'M', '11 rue de Sèvres', '75001', 126),
('Durand', 'Oscar', '1986-05-08', 'oscar.durand127@gmail.com', '0613456787', 'M', '2 avenue Mac-Mahon', '75001', 127),
('Leroy', 'Paul', '1988-02-02', 'paul.leroy128@gmail.com', '0624566898', 'M', '14 rue des Martyrs', '75001', 128),
('Moreau', 'Quentin', '1992-11-13', 'quentin.moreau129@gmail.com', '0635677009', 'M', '6 rue du Faubourg', '75001', 129),
('Simon', 'Rania', '1983-08-21', 'rania.simon130@gmail.com', '0646787120', 'M', '20 rue des Pyrénées', '75001', 130),
('Laurent', 'Samuel', '1977-07-07', 'samuel.laurent131@gmail.com', '0657897331', 'M', '10 rue de Siam', '29200', 131),
('Michel', 'Tina', '1990-10-10', 'tina.michel132@gmail.com', '0668907442', 'M', '4 rue Saint-Louis', '29200', 132),
('Garcia', 'Ugo', '1985-01-15', 'ugo.garcia133@gmail.com', '0679017553', 'M', '6 rue de Lyon', '29200', 133),
('David', 'Valerie', '1979-11-11', 'valerie.david134@gmail.com', '0680127664', 'M', '12 rue de Strasbourg', '29200', 134),
('Bertrand', 'William', '1988-04-04', 'william.bertrand135@gmail.com', '0691234775', 'M', '18 rue de Kerbabu', '29200', 135),
('Roux', 'Xavier', '1991-06-06', 'xavier.roux136@gmail.com', '0711234886', 'M', '22 rue Jean Jaurès', '29200', 136),
('Vincent', 'Yasmine', '1984-09-09', 'yasmine.vincent137@gmail.com', '0722345997', 'M', '2 rue Malherbe', '29200', 137),
('Fournier', 'Zoé', '1993-03-03', 'zoe.fournier138@gmail.com', '0613456008', 'M', '9 rue Yves Collet', '29200', 138),
('Morel', 'Adrien', '1980-12-12', 'adrien.morel139@gmail.com', '0624567119', 'M', '14 quai de la Douane', '29200', 139),
('Girard', 'Baptiste', '1986-02-02', 'baptiste.girard140@gmail.com', '0635677220', 'M', '3 rue Jean Macé', '29200', 140),
('Andre', 'Camille', '1992-08-08', 'camille.andre141@gmail.com', '0646787331', 'M', '1 place de la Liberté', '29200', 141),
('Lambert', 'Delphine', '1978-05-05', 'delphine.lambert142@gmail.com', '0657897442', 'M', '5 rue des Chapeliers', '29200', 142),
('Bonnet', 'Emile', '1987-10-10', 'emile.bonnet143@gmail.com', '0668907553', 'M', '8 rue de Siam', '29200', 143),
('Dupuis', 'Flora', '1990-01-01', 'flora.dupuis144@gmail.com', '0679017664', 'M', '11 rue de Pontaniou', '29200', 144),
('Francois', 'Gautier', '1983-03-03', 'gautier.francois145@gmail.com', '0680127775', 'M', '19 rue de Brest', '29200', 145),
('Henry', 'Helene', '1979-09-09', 'helene.henry146@gmail.com', '0691237886', 'M', '20 rue Saint-Malo', '29200', 146),
('Aubry', 'Ibrahim', '1985-02-02', 'ibrahim.aubry147@gmail.com', '0711237997', 'M', '2 rue d\'Aiguillon', '29200', 147),
('Renard', 'Julie', '1991-07-07', 'julie.renard148@gmail.com', '0722347008', 'M', '7 rue Jean Jaurès', '29200', 148),
('Gautier', 'Kevin', '1986-11-11', 'kevin.gautier149@gmail.com', '0613457119', 'M', '16 rue de Siam', '29200', 149),
('Barbier', 'Lea', '1992-04-04', 'lea.barbier150@gmail.com', '0624567220', 'M', '21 rue de Pontaniou', '29200', 150),
('Martin', 'Manu', '1984-05-16', 'manu.martin151@gmail.com', '0635677331', 'M', '6 rue de la Paix', '75001', 151),
('Bernard', 'Nora', '1990-09-18', 'nora.bernard152@gmail.com', '0646787442', 'M', '4 rue de la Banque', '75001', 152),
('Thomas', 'Omar', '1982-02-20', 'omar.thomas153@gmail.com', '0657897553', 'M', '30 rue La Fayette', '75001', 153),
('Robert', 'Pauline', '1993-12-12', 'pauline.robert154@gmail.com', '0668907664', 'M', '8 rue des Lombards', '75001', 154),
('Richard', 'Quentin', '1978-06-06', 'quentin.richard155@gmail.com', '0679017775', 'M', '4 rue de Rivoli', '75001', 155),
('Petit', 'Romain', '1989-08-08', 'romain.petit156@gmail.com', '0680127886', 'M', '11 rue du Bac', '75001', 156),
('Durand', 'Sarah', '1985-10-10', 'sarah.durand157@gmail.com', '0691237997', 'M', '7 rue de Varenne', '75001', 157),
('Leroy', 'Thibault', '1991-01-01', 'thibault.leroy158@gmail.com', '0711237008', 'M', '1 rue de Madrid', '75001', 158),
('Moreau', 'Ulysse', '1983-03-03', 'ulysse.moreau159@gmail.com', '0722347119', 'M', '10 rue des Capucines', '75001', 159),
('Simon', 'Valerie', '1977-07-07', 'valerie.simon160@gmail.com', '0613457220', 'M', '28 rue du Faubourg', '75001', 160),
('Laurent', 'William', '1988-08-08', 'william.laurent161@gmail.com', '0624567331', 'M', '16 rue de Bretagne', '75001', 161),
('Michel', 'Xenia', '1990-10-10', 'xenia.michel162@gmail.com', '0635677442', 'M', '5 rue du Dragon', '75001', 162),
('Garcia', 'Yann', '1984-04-04', 'yann.garcia163@gmail.com', '0646787553', 'M', '12 rue Mandar', '75001', 163),
('David', 'Zoé', '1992-02-02', 'zoe.david164@gmail.com', '0657897664', 'M', '22 rue de Tolbiac', '75001', 164),
('Bertrand', 'Axel', '1986-06-06', 'axel.bertrand165@gmail.com', '0668907775', 'M', '3 rue de Vaugirard', '75001', 165),
('Roux', 'Brune', '1991-11-11', 'brune.roux166@gmail.com', '0679017886', 'M', '9 rue de la Pompe', '75001', 166),
('Vincent', 'Cyril', '1980-01-01', 'cyril.vincent167@gmail.com', '0680127997', 'M', '15 rue de Bourgogne', '75001', 167),
('Fournier', 'Delphine', '1987-05-05', 'delphine.fournier168@gmail.com', '0691237008', 'M', '9 rue Royale', '75001', 168),
('Morel', 'Emmanuel', '1979-09-09', 'emmanuel.morel169@gmail.com', '0711237119', 'M', '2 rue de la Michodière', '75001', 169),
('Girard', 'Fanny', '1993-03-03', 'fanny.girard170@gmail.com', '0722347220', 'M', '18 rue du Faubourg Montmartre', '75001', 170),
('Andre', 'Gilles', '1985-07-07', 'gilles.andre171@gmail.com', '0612347741', 'M', '12 rue de la Chaussée d\'Antin', '75001', 171),
('Lambert', 'Helene', '1990-11-11', 'helene.lambert172@gmail.com', '0623457852', 'M', '4 rue du Jardin des Plantes', '75001', 172),
('Bonnet', 'Igor', '1978-08-08', 'igor.bonnet173@gmail.com', '0634567963', 'M', '29 rue des Francs Bourgeois', '75001', 173),
('Dupuis', 'Julie', '1984-02-02', 'julie.dupuis174@gmail.com', '0645677074', 'M', '17 avenue de l\'Opéra', '75001', 174),
('Francois', 'Kevin', '1991-06-06', 'kevin.francois175@gmail.com', '0656787185', 'M', '3 rue de la Convention', '75001', 175),
('Henry', 'Lola', '1986-10-10', 'lola.henry176@gmail.com', '0667897296', 'M', '11 rue de Sèvres', '75001', 176),
('Aubry', 'Narc', '1982-01-01', 'marc.aubry177@gmail.com', '0678907307', 'M', '2 avenue Mac-Mahon', '75001', 177),
('Renard', 'Nina', '1993-05-05', 'nina.renard178@gmail.com', '0689017418', 'M', '14 rue des Martyrs', '75001', 178),
('Gautier', 'Olivier', '1979-09-09', 'olivier.gautier179@gmail.com', '0690127529', 'M', '6 rue du Faubourg', '75001', 179),
('Barbier', 'Paul', '1987-03-03', 'paul.barbier180@gmail.com', '0711237630', 'M', '20 rue des Pyrénées', '75001', 180),
('Martin', 'Quentin', '1990-12-12', 'quentin.martin181@gmail.com', '0722347741', 'M', '10 rue de Siam', '29200', 181),
('Bernard', 'Roxane', '1985-04-04', 'roxane.bernard182@gmail.com', '0613457852', 'M', '4 rue Saint-Louis', '29200', 182),
('Thomas', 'Sebastien', '1978-08-08', 'sebastien.thomas183@gmail.com', '0624567963', 'M', '6 rue de Lyon', '29200', 183),
('Robert', 'Therese', '1984-02-02', 'therese.robert184@gmail.com', '0635677074', 'M', '12 rue de Strasbourg', '29200', 184),
('Richard', 'Ugo', '1991-06-06', 'ugo.richard185@gmail.com', '0646787185', 'M', '18 rue de Kerbabu', '29200', 185),
('Petit', 'Violette', '1986-10-10', 'violette.petit186@gmail.com', '0657897296', 'M', '22 rue Jean Jaurès', '29200', 186),
('Durand', 'William', '1982-01-01', 'william.durand187@gmail.com', '0668907307', 'M', '2 rue Malherbe', '29200', 187),
('Leroy', 'Xavier', '1993-05-05', 'xavier.leroy188@gmail.com', '0679017418', 'M', '9 rue Yves Collet', '29200', 188),
('Moreau', 'Yasmine', '1979-09-09', 'yasmine.moreau189@gmail.com', '0680127529', 'M', '14 quai de la Douane', '29200', 189),
('Simon', 'Zoé', '1987-03-03', 'zoe.simon190@gmail.com', '0691237630', 'M', '3 rue Jean Macé', '29200', 190),
('Laurent', 'Aurelien', '1990-07-07', 'aurelien.laurent191@gmail.com', '0711237741', 'M', '1 place de la Liberté', '29200', 191),
('Michel', 'Beatrice', '1985-11-11', 'beatrice.michel192@gmail.com', '0722347852', 'M', '5 rue des Chapeliers', '29200', 192),
('Garcia', 'Cedric', '1978-04-04', 'cedric.garcia193@gmail.com', '0613457963', 'M', '8 rue de Siam', '29200', 193),
('David', 'Delphine', '1984-09-09', 'delphine.david194@gmail.com', '0624567074', 'M', '11 rue de Pontaniou', '29200', 194),
('Bertrand', 'Etienne', '1991-02-02', 'etienne.bertrand195@gmail.com', '0635677185', 'M', '19 rue de Brest', '29200', 195),
('Roux', 'Fiona', '1986-06-06', 'fiona.roux196@gmail.com', '0646787296', 'M', '20 rue Saint-Malo', '29200', 196),
('Vincent', 'Gauthier', '1982-10-10', 'gauthier.vincent197@gmail.com', '0657897307', 'M', '2 rue d\'Aiguillon', '29200', 197),
('Fournier', 'Hana', '1993-03-03', 'hana.fournier198@gmail.com', '0668907418', 'M', '7 rue Jean Jaurès', '29200', 198),
('Morel', 'Ilan', '1979-08-08', 'ilan.morel199@gmail.com', '0679017529', 'M', '16 rue de Siam', '29200', 199),
('Girard', 'Julie', '1987-01-01', 'julie.girard200@gmail.com', '0680127630', 'M', '21 rue de Pontaniou', '29200', 200),
('Sid', 'Lilya', '2004-03-15', 'linasidennas5@gmail.com', '0783084173', 'M', 'rue de saint-brieuc', '29200', 201),
('Dupont', 'Jean', '1990-07-10', 'jean.dupont@example.com', '0612345678', 'M', '10 avenue des Champs', '75001', 202),
('Martin', 'Sophie', '1985-12-05', 'sophie.martin@example.com', '0698765432', 'M', '45 boulevard Saint-Michel', '29200', 203),
('Bernard', 'Paul', '1978-09-23', 'paul.bernard@example.com', '0678901234', 'M', '12 rue de la Paix', '29200', 204),
('Hallal', 'Inas', '2001-03-10', 'inashallal@gmail.com', '0783084174', 'M', 'rue de saint-brieuc', '29200', 205);

--
-- Déclencheurs `t_profil_pfl`
--
DELIMITER $$
CREATE TRIGGER `after_delete_admin_bonus` AFTER DELETE ON `t_profil_pfl` FOR EACH ROW BEGIN
    DECLARE principal_id INT;

    IF OLD.pfl_role = 'A' THEN 
        -- Supprimer les atualites 
        DELETE FROM t_actualite_act
        WHERE cpt_id = OLD.cpt_id;

      -- Récupérer ID du compte principal
        SELECT cpt_id INTO principal_id
        FROM t_compte_cpt
        WHERE cpt_pseudo = 'principal'
        LIMIT 1;

        -- modifier lauteur a principal
        UPDATE t_message_msg 
        SET cpt_id=principal_id
        WHERE cpt_id = OLD.cpt_id;
    END IF; 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_reservation_res`
--

CREATE TABLE `t_reservation_res` (
  `res_id` int(11) NOT NULL,
  `res_bilan` varchar(600) DEFAULT NULL,
  `res_nom` varchar(100) NOT NULL,
  `res_lieu` varchar(100) NOT NULL,
  `res_date` datetime NOT NULL,
  `rsc_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_reservation_res`
--

INSERT INTO `t_reservation_res` (`res_id`, `res_bilan`, `res_nom`, `res_lieu`, `res_date`, `rsc_id`) VALUES
(1, '', 'Répétition Hamlet', 'Salle de théâtre principale', '2025-12-05 18:00:00', 1),
(2, '', 'Concert Jazz privé', 'Salle de théâtre principale', '2024-12-05 20:00:00', 1),
(4, 'Magnifique vernissage, rien à signaler ', 'Vernissage exposition', 'Galerie d\'exposition', '2025-11-30 18:30:00', 4),
(5, '', 'Réunion association', 'Salle polyvalente', '2025-10-15 19:00:00', 5),
(6, '', 'Atelier Théâtre - Session 1', 'Salle de théâtre principale', '2023-04-12 18:00:00', 1),
(7, 'Très bonne participation', 'Cours de musique – Groupe 2', 'Studio de musique', '2025-11-30 20:00:00', 2),
(8, '', 'Exposition locale – Printemps', 'Galerie d\'exposition', '2024-03-18 14:00:00', 4),
(10, '', 'Réunion administrative', 'Salle polyvalente', '2026-01-01 09:00:00', 5),
(11, '', 'Répétition scène finale', 'Salle théâtre principale', '2025-12-12 19:00:00', 1),
(12, '', 'Session improvisation musicale', 'Studio de musique', '2025-12-15 17:30:00', 2),
(13, 'Bonne ambiance', 'Atelier exposition – Préparation', 'Galerie d\'exposition', '2025-11-30 16:00:00', 4),
(14, '', 'Conférence interne', 'Salle polyvalente', '2025-12-20 14:00:00', 5),
(15, '', 'Spectacle de fin d\'année', 'Salle de théâtre principale', '2025-12-05 20:00:00', 1),
(16, '', 'Masterclass Jazz', 'Studio de musique', '2026-03-05 18:30:00', 2),
(17, '', 'Vernissage Art Contemporain', 'Galerie d\'exposition', '2026-04-14 19:00:00', 4),
(18, '', 'Assemblée générale annuelle', 'Salle polyvalente', '2026-05-22 09:00:00', 5);

--
-- Déclencheurs `t_reservation_res`
--
DELIMITER $$
CREATE TRIGGER `auto_delete_inscriptions` BEFORE DELETE ON `t_reservation_res` FOR EACH ROW BEGIN
    DELETE FROM t_inscription_ins WHERE res_id = OLD.res_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_ressource_rsc`
--

CREATE TABLE `t_ressource_rsc` (
  `rsc_id` int(11) NOT NULL,
  `rsc_nom` varchar(80) NOT NULL,
  `rsc_descriptif` varchar(600) NOT NULL,
  `rsc_jauge_min` int(11) NOT NULL,
  `rsc_jauge_max` int(11) NOT NULL,
  `rsc_image` varchar(250) DEFAULT NULL,
  `rsc_liste_materiel` varchar(600) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_ressource_rsc`
--

INSERT INTO `t_ressource_rsc` (`rsc_id`, `rsc_nom`, `rsc_descriptif`, `rsc_jauge_min`, `rsc_jauge_max`, `rsc_image`, `rsc_liste_materiel`) VALUES
(1, 'Salle de théâtre principale', 'Grande salle équipée d\'un système de son et lumière professionnel, idéale pour les représentations théâtrales.', 1, 30, 'theatre.jpg', 'Chaises, projecteurs, micros, système son'),
(2, 'Studio de musique', 'Espace insonorisé pour répétitions et petits concerts, équipé de matériel audio professionnel.', 1, 20, 'musique.jpg', 'Amplificateurs, micros, batterie, claviers'),
(4, 'Galerie d\'exposition', 'Espace d\'exposition pour montrer les œuvres des artistes locaux, avec un éclairage adapté.', 1, 21, 'galerie.webp', 'Supports d\'accrochage, éclairage, vitrines'),
(5, 'Salle polyvalente', 'Salle modulable pouvant accueillir des ateliers, réunions, ou événements culturels divers.', 1, 30, 'salle.jpg', ''),
(6, 'Espace extérieur de performances', 'Cour extérieure utilisée pour des spectacles en plein air et événements culturels.', 1, 25, 'escpace.webp', 'Scène mobile, éclairage extérieur, sonorisation'),
(21, 'studio 513', 'c\'est un grand studio ', 3, 10, '1764778804_ac277a52dcc950428b45.jpg', '');

-- --------------------------------------------------------

--
-- Structure de la table `t_reunion_ren`
--

CREATE TABLE `t_reunion_ren` (
  `ren_id` int(11) NOT NULL,
  `ren_salle` varchar(80) NOT NULL,
  `ren_date` datetime NOT NULL,
  `ren_theme` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_reunion_ren`
--

INSERT INTO `t_reunion_ren` (`ren_id`, `ren_salle`, `ren_date`, `ren_theme`) VALUES
(1, 'Salle Polyvalente', '2025-10-05 18:00:00', 'Préparation du Festival de Théâtre'),
(2, 'Salle Musique', '2025-10-10 17:00:00', 'Organisation des ateliers de chant'),
(5, 'Salle Polyvalente', '2025-10-25 18:30:00', 'Bilan trimestriel des activités culturelles'),
(6, 'salle B', '2025-10-07 00:00:00', 'Réunion générale');

--
-- Déclencheurs `t_reunion_ren`
--
DELIMITER $$
CREATE TRIGGER `before_delete_reunion` BEFORE DELETE ON `t_reunion_ren` FOR EACH ROW BEGIN
    -- Supprimer les participations liées à la réunion supprimée
    DELETE FROM t_partcipation_par
    WHERE ren_id = OLD.ren_id;

    -- Supprimer le document associé à la réunion
    DELETE FROM t_document_doc
    WHERE ren_id = OLD.ren_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_ville_vil`
--

CREATE TABLE `t_ville_vil` (
  `vil_code_postal` char(5) NOT NULL,
  `vil_nom` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_ville_vil`
--

INSERT INTO `t_ville_vil` (`vil_code_postal`, `vil_nom`) VALUES
('13001', 'Marseille'),
('29200', 'Brest'),
('31000', 'Toulouse'),
('69001', 'Lyon'),
('75001', 'Paris');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_adherents_complets`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_adherents_complets` (
`cpt_pseudo` varchar(80)
,`pfl_nom` varchar(80)
,`pfl_prenom` varchar(80)
,`pfl_email` varchar(250)
,`pfl_numero_de_telephone` char(12)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_admins`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_admins` (
`cpt_pseudo` varchar(80)
,`pfl_nom` varchar(80)
,`pfl_prenom` varchar(80)
,`pfl_email` varchar(250)
);

-- --------------------------------------------------------

--
-- Structure de la vue `vue_adherents_complets`
--
DROP TABLE IF EXISTS `vue_adherents_complets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`e22307882sql`@`%` SQL SECURITY DEFINER VIEW `vue_adherents_complets`  AS SELECT `t_compte_cpt`.`cpt_pseudo` AS `cpt_pseudo`, `t_profil_pfl`.`pfl_nom` AS `pfl_nom`, `t_profil_pfl`.`pfl_prenom` AS `pfl_prenom`, `t_profil_pfl`.`pfl_email` AS `pfl_email`, `t_profil_pfl`.`pfl_numero_de_telephone` AS `pfl_numero_de_telephone` FROM (`t_compte_cpt` join `t_profil_pfl` on(`t_compte_cpt`.`cpt_id` = `t_profil_pfl`.`cpt_id`)) WHERE `t_profil_pfl`.`pfl_role` = 'M' ;

-- --------------------------------------------------------

--
-- Structure de la vue `vue_admins`
--
DROP TABLE IF EXISTS `vue_admins`;

CREATE ALGORITHM=UNDEFINED DEFINER=`e22307882sql`@`%` SQL SECURITY DEFINER VIEW `vue_admins`  AS SELECT `t_compte_cpt`.`cpt_pseudo` AS `cpt_pseudo`, `t_profil_pfl`.`pfl_nom` AS `pfl_nom`, `t_profil_pfl`.`pfl_prenom` AS `pfl_prenom`, `t_profil_pfl`.`pfl_email` AS `pfl_email` FROM (`t_compte_cpt` join `t_profil_pfl` on(`t_compte_cpt`.`cpt_id` = `t_profil_pfl`.`cpt_id`)) WHERE `t_profil_pfl`.`pfl_role` = 'A' ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD PRIMARY KEY (`act_id`),
  ADD KEY `fk_t_actualite_act_t_compte-cpt1_idx` (`cpt_id`);

--
-- Index pour la table `t_association_ast`
--
ALTER TABLE `t_association_ast`
  ADD PRIMARY KEY (`dis_id`,`rsc_id`),
  ADD KEY `fk_t_indisponibilite_dis_has_t_ressource_rsc_t_ressource_rs_idx` (`rsc_id`),
  ADD KEY `fk_t_indisponibilite_dis_has_t_ressource_rsc_t_indisponibil_idx` (`dis_id`);

--
-- Index pour la table `t_compte_cpt`
--
ALTER TABLE `t_compte_cpt`
  ADD PRIMARY KEY (`cpt_id`),
  ADD UNIQUE KEY `cpt_pseudo_UNIQUE` (`cpt_pseudo`);

--
-- Index pour la table `t_document_doc`
--
ALTER TABLE `t_document_doc`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `fk_t_document_doc_t_reunion_ren1_idx` (`ren_id`);

--
-- Index pour la table `t_indisponibilite_dis`
--
ALTER TABLE `t_indisponibilite_dis`
  ADD PRIMARY KEY (`dis_id`),
  ADD KEY `fk_t_indisponibilite_dis_t_motif_mot1_idx` (`mot_id`);

--
-- Index pour la table `t_inscription_ins`
--
ALTER TABLE `t_inscription_ins`
  ADD PRIMARY KEY (`cpt_id`,`res_id`),
  ADD KEY `fk_t_compte-cpt_has_t_reservation_res_t_reservation_res1_idx` (`res_id`),
  ADD KEY `fk_t_compte-cpt_has_t_reservation_res_t_compte-cpt1_idx` (`cpt_id`);

--
-- Index pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  ADD PRIMARY KEY (`msg_id`),
  ADD UNIQUE KEY `msg_code` (`msg_code`),
  ADD KEY `fk_t_message_msg_t_compte-cpt_idx` (`cpt_id`);

--
-- Index pour la table `t_motif_mot`
--
ALTER TABLE `t_motif_mot`
  ADD PRIMARY KEY (`mot_id`);

--
-- Index pour la table `t_partcipation_par`
--
ALTER TABLE `t_partcipation_par`
  ADD PRIMARY KEY (`ren_id`,`cpt_id`),
  ADD KEY `fk_t_reunion_ren_has_t_compte-cpt_t_compte-cpt1_idx` (`cpt_id`),
  ADD KEY `fk_t_reunion_ren_has_t_compte-cpt_t_reunion_ren1_idx` (`ren_id`);

--
-- Index pour la table `t_profil_pfl`
--
ALTER TABLE `t_profil_pfl`
  ADD PRIMARY KEY (`cpt_id`),
  ADD KEY `fk_t_profil_pfl_t_ville_vil1_idx` (`vil_code_postal`);

--
-- Index pour la table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  ADD PRIMARY KEY (`res_id`),
  ADD KEY `fk_t_reservation_res_t_ressource_rsc1_idx` (`rsc_id`);

--
-- Index pour la table `t_ressource_rsc`
--
ALTER TABLE `t_ressource_rsc`
  ADD PRIMARY KEY (`rsc_id`);

--
-- Index pour la table `t_reunion_ren`
--
ALTER TABLE `t_reunion_ren`
  ADD PRIMARY KEY (`ren_id`);

--
-- Index pour la table `t_ville_vil`
--
ALTER TABLE `t_ville_vil`
  ADD PRIMARY KEY (`vil_code_postal`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  MODIFY `act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `t_compte_cpt`
--
ALTER TABLE `t_compte_cpt`
  MODIFY `cpt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=249;

--
-- AUTO_INCREMENT pour la table `t_document_doc`
--
ALTER TABLE `t_document_doc`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `t_indisponibilite_dis`
--
ALTER TABLE `t_indisponibilite_dis`
  MODIFY `dis_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  MODIFY `msg_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT pour la table `t_motif_mot`
--
ALTER TABLE `t_motif_mot`
  MODIFY `mot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  MODIFY `res_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `t_ressource_rsc`
--
ALTER TABLE `t_ressource_rsc`
  MODIFY `rsc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `t_reunion_ren`
--
ALTER TABLE `t_reunion_ren`
  MODIFY `ren_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD CONSTRAINT `fk_t_actualite_act_t_compte-cpt1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_association_ast`
--
ALTER TABLE `t_association_ast`
  ADD CONSTRAINT `fk_t_indisponibilite_dis_has_t_ressource_rsc_t_indisponibilit1` FOREIGN KEY (`dis_id`) REFERENCES `t_indisponibilite_dis` (`dis_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_indisponibilite_dis_has_t_ressource_rsc_t_ressource_rsc1` FOREIGN KEY (`rsc_id`) REFERENCES `t_ressource_rsc` (`rsc_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_document_doc`
--
ALTER TABLE `t_document_doc`
  ADD CONSTRAINT `fk_t_document_doc_t_reunion_ren1` FOREIGN KEY (`ren_id`) REFERENCES `t_reunion_ren` (`ren_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_indisponibilite_dis`
--
ALTER TABLE `t_indisponibilite_dis`
  ADD CONSTRAINT `fk_t_indisponibilite_dis_t_motif_mot1` FOREIGN KEY (`mot_id`) REFERENCES `t_motif_mot` (`mot_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_inscription_ins`
--
ALTER TABLE `t_inscription_ins`
  ADD CONSTRAINT `fk_t_compte-cpt_has_t_reservation_res_t_compte-cpt1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_compte-cpt_has_t_reservation_res_t_reservation_res1` FOREIGN KEY (`res_id`) REFERENCES `t_reservation_res` (`res_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  ADD CONSTRAINT `fk_t_message_msg_t_compte-cpt` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_partcipation_par`
--
ALTER TABLE `t_partcipation_par`
  ADD CONSTRAINT `fk_t_reunion_ren_has_t_compte-cpt_t_compte-cpt1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_reunion_ren_has_t_compte-cpt_t_reunion_ren1` FOREIGN KEY (`ren_id`) REFERENCES `t_reunion_ren` (`ren_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_profil_pfl`
--
ALTER TABLE `t_profil_pfl`
  ADD CONSTRAINT `fk_t_profil_pfl_t_compte-cpt1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_profil_pfl_t_ville_vil1` FOREIGN KEY (`vil_code_postal`) REFERENCES `t_ville_vil` (`vil_code_postal`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  ADD CONSTRAINT `fk_t_reservation_res_t_ressource_rsc1` FOREIGN KEY (`rsc_id`) REFERENCES `t_ressource_rsc` (`rsc_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
