<div class="container mt-4">

    <!-- Informations du message -->
    <h2 class="text-center text-primary fw-bold mb-4">Informations du message</h2>

    <div class="card shadow-sm mb-4">
        <div class="card-body">

            <p><strong>Date de la demande :</strong>
                <span class="text-muted"><?php echo $info->msg_date; ?></span>
            </p>

            <p><strong>Email de l'expéditeur :</strong>
                <span class="text-muted"><?php echo $info->msg_email; ?></span>
            </p>

            <p><strong>Sujet :</strong>
                <span class="text-muted"><?php echo $info->msg_sujet; ?></span>
            </p>

            <p><strong>Contenu :</strong><br>
                <span class="text-muted"><?php echo nl2br($info->msg_contenu); ?></span>
            </p>

        </div>
    </div>

    <!-- Formulaire de réponse -->
    <h3 class="text-secondary mb-3">Votre réponse :</h3>

    <?php echo form_open('/compte/envoyer_reponse/'.$msg_code); ?>
    <?= csrf_field() ?>

    <input type="hidden" name="msg_code" value="<?= $msg_code ?>">

    <div class="mb-3">
        <textarea class="form-control" id="reponse" name="reponse" rows="5"
                  placeholder="Rédigez ici votre réponse..."></textarea>
        <?= validation_show_error('reponse') ?>
    </div>

    <div class="d-grid">
        <input type="submit" name="submit" value="Répondre" class="btn btn-primary">
    </div>

    </form>

</div>
