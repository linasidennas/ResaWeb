<h2><?php //echo $titre; ?></h2>
 <h1 class="text-center mb-4">Créer un compte </h1>

<?php
// Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
echo form_open('/compte/creer'); ?>
<?= csrf_field() ?>
<div class="mb-3">
    <label for="pseudo" class="form-label">Pseudo :</label>
    <input type="text" class="form-control" id="pseudo" name="pseudo" placeholder="Entrez votre pseudo">
    <?= validation_show_error('pseudo') ?>
</div>

<div class="mb-3">
    <label for="mdp" class="form-label">Mot de passe :</label>
    <input type="password" class="form-control" id="mdp" name="mdp" placeholder="Entrez votre mot de passe">
    <?= validation_show_error('mdp') ?>
</div>

<?php if (isset($erreur_pseudo)) : ?>
<div class="alert alert-danger mt-2">
    <?= $erreur_pseudo ?>
</div>
<?php endif; ?>

<div class="d-flex justify-content-between mt-3">
    <input type="submit" name="submit" value="Créer un compte invité" class="btn btn-primary w-50 me-2">

    <button type="button" class="btn btn-secondary w-50 ms-2">
        Créer un compte
    </button>
</div>
<br>
</form>