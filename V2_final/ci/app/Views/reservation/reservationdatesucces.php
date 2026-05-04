<br> <br><div class="container mt-4">
    <h2>Réservations du <?= $date ?></h2>

    <?php if (empty($reservations)): ?>

        <p>Aucune réservation pour cette date.</p>

    <?php else: ?>

        <?php
        // regrouper par ressource
        $groupes = [];
        foreach ($reservations as $r) {
            $groupes[$r['rsc_nom']][] = $r;
        }
        ?>

        <?php foreach ($groupes as $ressource => $liste): ?>


            <ul class="list-group">

                <?php foreach ($liste as $r): ?>

              <li class="list-group-item">

                <strong>Nom :</strong> <?= $r['res_nom'] ?><br>
                <strong>Date de début :</strong> <?= $r['res_date'] ?><br>
                <strong>Bilan :</strong> <?= $r['res_bilan'] ?><br>

                <strong>Responsable :</strong> <?= $r['responsable'] ?><br>
                <strong>Participants :</strong> <?= $r['participants'] ?>

            </li>

                <?php endforeach; ?>

            </ul>

        <?php endforeach; ?>

    <?php endif; ?>
</div>
