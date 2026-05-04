<!DOCTYPE html>
<html lang="fr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<body class="bg-light">

<br> 

<div class="container mt-5">
        <h3 class="text-center mb-4">Appuyer ici pour ajouter une ressource :</h3>

    <a href="<?= base_url('index.php/compte/creer_ressource') ?>" 
   class="btn btn-success mb-2 ">
    + Ajouter une ressource
</a>
    <h1 class="text-center mb-4">Liste des ressources</h1>

    <div class="row">

        <?php
        if (! empty($ressources) && is_array($ressources))
        {
            foreach ($ressources as $r)
            {
                $img = !empty($r['rsc_image']) ? $r['rsc_image'] : "defaut.png";

                echo "
                <div class='col-md-4 mb-4'>
                    <div class='card shadow-sm h-100'>

                        <img src='" . base_url("bootstrap/assets/img/" . $img) . "' 
                             class='card-img-top'
                             alt='image ressource'
                             style='height:220px; object-fit:cover;'>

                        <div class='card-body'>
                            <h5 class='card-title'>" . $r['rsc_nom'] . "</h5>
                        <a class='btn btn-secondary btn-sm disabled' href='#'>
                            Information détaillées
                        </a>
                           <p class='mt-2'>
                            <span class='badge bg-success'>Jauge min : " . $r['rsc_jauge_min'] . "</span><br>
                            <span class='badge bg-danger'>Jauge max : " . $r['rsc_jauge_max'] . "</span>
                        </p>
                        </div>
                        <a href='" . base_url('index.php/compte/supprimer_ressource/' . $r['rsc_id']) . "'
       onclick='return confirm(\"Supprimer cette ressource ?\");'
       class='btn btn-danger btn-sm'>
        <i class='fa-solid fa-trash'></i> Supprimer
    </a>

                    </div>
                </div>";
            }
        }
        else 
        {
            echo "<div class='col-12 text-center'><h3>Aucune ressource trouvée</h3></div>";
        }
        ?>

    </div>

</div>

</body>
</html>
