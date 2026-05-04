<br> <h2><?php echo $titre; ?></h2>
<?php
// Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
echo form_open('/message/verifier'); ?>
<?= csrf_field() ?>
<div class="mb-3">
    
    <label for="code" class="form-label">Code :</label>
    <input type="text" class="form-control" id="code" name="code" placeholder="Entrez votre code">
    <?= validation_show_error('code') ?>
</div>


<div class="d-grid">
    <input type="submit" name="submit" value="Visualiser" class="btn btn-primary">
</div>
<br>
</form>