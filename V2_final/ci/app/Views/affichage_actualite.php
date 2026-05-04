<div class="container mt-5">
    <h1 class="text-center mb-4 text-primary"><?php echo $titre; ?></h1>

    <div class="d-flex justify-content-center">
        <div class="card shadow-lg w-75">
            <div class="card-body text-center">
                <?php
                if (isset($news)) {
                    echo '<h5 class="card-title text-secondary">ID : ' . $news->act_id . '</h5>';
                    echo '<p class="card-text"><strong>Titre :</strong> ' . $news->act_titre . '</p>';
                    echo '<p class="card-text"><strong>Contenu :</strong> ' . $news->act_contenu . '</p>';
                    echo '<p class="card-text"><strong>Description :</strong> ' . $news->act_description . '</p>';
                    echo '<p class="card-text"><strong>Date :</strong> ' . $news->act_date . '</p>';
                    echo '<p class="card-text"><strong>État(A:Activé/D:Désactivé) :</strong> ' . $news->act_etat . '</p>';
                } else {
                    echo '<div class="alert alert-warning m-0" role="alert">Pas d\'actualité avec cet identifiant !</div>';
                }
                ?>
            </div>
        </div>
    </div>
</div>
<br>