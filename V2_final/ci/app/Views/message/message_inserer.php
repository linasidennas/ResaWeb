<br><h2><?php echo $titre; ?></h2>
<?php
// Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
echo form_open('/message/inserer'); ?>
<?= csrf_field() ?>
<div class="mb-3">
    <label for="email" class="form-label">Email :</label>
    <input type="email" class="form-control" id="email" name="email" placeholder="Entrez votre email">
    <?= validation_show_error('email') ?>
</div>
<div class="mb-3">
    <label for="sujet" class="form-label">Sujet :</label>
    <input type="text" class="form-control" id="sujet" name="sujet" placeholder="Entrez votre sujet">
    <?= validation_show_error('sujet') ?>
</div>

<div class="mb-3">
    <label for="contenu" class="form-label">Contenu :</label>
    <textarea class="form-control" id="contenu" name="contenu" rows="5" placeholder="Entrez votre contenu"></textarea>
        <?= validation_show_error('contenu') ?>
</div>


<div class="d-grid">
    <input type="submit" name="submit" value="Valider" class="btn btn-primary">
</div>
<br>
</form>