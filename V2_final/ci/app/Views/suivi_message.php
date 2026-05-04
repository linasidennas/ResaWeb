<div class="container mt-5">
    <h1 class="text-center mb-4 text-uppercase fw-bold text-primary">Suivi de votre demande</h1>

    <div class="card shadow-lg border-0">
        <div class="card-body">
           <!-- <h4 class="card-title text-center text-secondary mb-4"><?php //echo $title; ?></h4> -->

            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            <strong>Date de votre demande :</strong>
                            <span class="text-muted"><?php echo $info->msg_date; ?></span>
                        </li>
                        <li class="list-group-item">
                            <strong>Sujet de votre demande :</strong>
                            <span class="text-muted"><?php echo $info->msg_sujet; ?></span>
                        </li>
                        <li class="list-group-item">
                            <strong>Contenu de votre demande :</strong>
                            <p class="mt-2 mb-0 text-muted"><?php echo $info->msg_contenu; ?></p>
                        </li>
                        <li class="list-group-item">
                            <strong>Réponse :</strong>

                            <?php if (!empty($info->msg_reponse)) : ?>
                                <p class="mt-2 mb-0 text-success">
                                    <?php echo $info->msg_reponse; ?>
                                </p>
                            <?php else : ?>
                                <p class="mt-2 mb-0 text-warning">
                                    Vous n'avez pas encore reçu de réponse. Veuillez patienter.
                                </p>
                            <?php endif; ?>
                        </li>

                            <li class="list-group-item">
                            <strong>Admin en charge de la réponse :</strong>

                            <?php if (!empty($info->cpt_pseudo)) : ?>
                                <p class="mt-2 mb-0 text-success">
                                    <?php echo $info->cpt_pseudo; ?>
                                </p>
                            <?php else : ?>
                                <p class="mt-2 mb-0 text-warning">
                                    Aucun administrateur n’est encore assigné à cette demande.
                                </p>
                            <?php endif; ?>
                        </li>

                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>



