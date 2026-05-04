
<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-6">

            <div class="card p-4 shadow-sm">
                <h2 class="mb-3"><?php echo $titre; ?></h2>

                <?= session()->getFlashdata('error') ?>

                <?php echo form_open('/compte/connecter'); ?>
                <?= csrf_field() ?>

                <div class="mb-3">
                    <label for="pseudo" class="form-label">Pseudo :</label>
                    <input type="text" name="pseudo" class="form-control" value="<?= set_value('pseudo') ?>">
                    <div class="text-danger small"><?= validation_show_error('pseudo') ?></div>
                </div>

                <div class="mb-3">
                    <label for="mdp" class="form-label">Mot de passe :</label>
                    <input type="password" name="mdp" class="form-control">
                    <div class="text-danger small"><?= validation_show_error('mdp') ?></div>
                </div>

                <button type="submit" name="submit" class="btn btn-primary w-100">
                    Se connecter
                </button>

                </form>
            </div>
            <?php if (!empty($erreur)) : ?>
                <div class="alert alert-danger text-center">
                    <?= esc($erreur) ?>
                </div>
            <?php endif; ?>


        </div>
    </div>
</div>
