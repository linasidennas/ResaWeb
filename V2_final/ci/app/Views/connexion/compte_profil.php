<br><br>
<?php $session = session(); ?>

<div class="container">
 

    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">
                Profil de <?= $session->get('user') ?>
            </h5>
        </div>

        <div class="card-body">

            <div class="row mb-2">
                <div class="col-4 fw-bold">Nom :</div>
                <div class="col-8"><?= $profil->pfl_nom ?></div>
            </div>

            <div class="row mb-2">
                <div class="col-4 fw-bold">Prénom :</div>
                <div class="col-8"><?= $profil->pfl_prenom ?></div>
            </div>

            <div class="row mb-2">
                <div class="col-4 fw-bold">Date de naissance :</div>
                <div class="col-8"><?= $profil->pfl_date_de_naissance ?></div>
            </div>

            <div class="row mb-2">
                <div class="col-4 fw-bold">Email :</div>
                <div class="col-8"><?= $profil->pfl_email ?></div>
            </div>

            <div class="row mb-2">
                <div class="col-4 fw-bold">Téléphone :</div>
                <div class="col-8"><?= $profil->pfl_numero_de_telephone ?></div>
            </div>

            <div class="row mb-2">
                <div class="col-4 fw-bold">Adresse :</div>
                <div class="col-8"><?= $profil->pfl_adresse ?></div>
            </div>

            <div class="row mb-2">
                <div class="col-4 fw-bold">Code Postal :</div>
                <div class="col-8"><?= $profil->vil_code_postal ?></div>
            </div>

        </div>
    </div>
</div>
