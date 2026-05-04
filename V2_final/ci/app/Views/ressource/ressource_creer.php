<br><br>
<h1>Créer une ressource </h1>
<?php 
// Formulaire vers /compte/creer_ressource
echo form_open_multipart('/compte/creer_ressource'); 
?>

<?= csrf_field() ?>

<!-- NOM DE LA RESSOURCE -->
<label for="nom">Nom de la ressource :</label>
<input type="text" name="nom" class="form-control" value="<?= set_value('nom') ?>">
<div class="text-danger small"><?= validation_show_error('nom') ?></div>

<!-- DESCRIPTIF -->
<label for="descriptif" class="mt-2">Descriptif :</label>
<textarea name="descriptif" class="form-control" rows="3"><?= set_value('descriptif') ?></textarea>
<div class="text-danger small"><?= validation_show_error('descriptif') ?></div>

<!-- JAUGE MIN -->
<label for="jauge_min" class="mt-2">Jauge minimale :</label>
<input type="number" name="jauge_min" class="form-control" value="<?= set_value('jauge_min') ?>">
<div class="text-danger small"><?= validation_show_error('jauge_min') ?></div>

<!-- JAUGE MAX -->
<label for="jauge_max" class="mt-2">Jauge maximale :</label>
<input type="number" name="jauge_max" class="form-control" value="<?= set_value('jauge_max') ?>">
<div class="text-danger small"><?= validation_show_error('jauge_max') ?></div>

<!-- IMAGE -->
<label for="fichier" class="mt-2">Image de la ressource :</label>
<input type="file" name="fichier" class="form-control">
<div class="text-danger small"><?= validation_show_error('fichier') ?></div>

<!-- BOUTON -->
<input type="submit" name="submit" value="Ajouter la ressource" class="btn btn-primary mt-3">


</form>
