<!DOCTYPE html>
<html lang="fr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<body class="bg-light">

<div class="container mt-5">
    <h1 class="text-center mb-4">Gestion des comptes/profils</h1>

    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead class="table-dark text-center">
                <tr>
                    <th>Pseudo</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Email</th>
                    <th>Statut</th>
                    <th>État du compte</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody class="text-center">
                <?php
                if (! empty($profils) && is_array($profils))
                {
                    foreach ($profils as $p)
                    {
                        $etatBadge = ($p["cpt_etat"] == "A")
                            ? "<span class='badge bg-success'>Activé</span>"
                            : "<span class='badge bg-danger'>Désactivé</span>";

                        echo "<tr>";
                        echo "<td>" . $p["cpt_pseudo"] . "</td>";
                        echo "<td>" . $p["pfl_nom"] . "</td>";
                        echo "<td>" . $p["pfl_prenom"] . "</td>";
                        echo "<td>" . $p["pfl_email"] . "</td>";
                        echo "<td>" . $p["pfl_role"] . "</td>";
                        echo "<td>" . $etatBadge . "</td>";
                        echo "<td class='text-center'>";

                        // 🔎 Voir détails (pas encore implémenté)
                        echo "<a href='#' class='btn btn-primary btn-sm me-1' title='Voir détails'>
                                <i class='fas fa-eye'></i>
                              </a>";

                        // ✏️ Modifier (pas encore implémenté)
                        echo "<a href='#' class='btn btn-warning btn-sm me-1' title='Modifier'>
                                <i class='fas fa-edit'></i>
                              </a>";

                        // 🔥 ACTIVER / DESACTIVER
                        if ($p["cpt_etat"] == "A") {
                            // Compte ACTIVÉ → bouton Désactiver
                            echo "<a href='".base_url('index.php/compte/desactiver_compte/'.$p["cpt_id"])."'
                                     class='btn btn-secondary btn-sm me-1'
                                     title='Désactiver'>
                                    <i class='fas fa-ban'></i>
                                  </a>";
                        } else {
                            // Compte DÉSACTIVÉ → bouton Activer
                            echo "<a href='".base_url('index.php/compte/activer_compte/'.$p["cpt_id"])."'
                                     class='btn btn-success btn-sm me-1'
                                     title='Activer'>
                                    <i class='fas fa-check'></i>
                                  </a>";
                        }

                        // ❌ Supprimer (pas encore implémenté)
                        echo "<a href='#' class='btn btn-danger btn-sm' title='Supprimer'>
                                <i class='fas fa-trash'></i>
                              </a>";

                        echo "</td>";
                        echo "</tr>";
                    }
                }
                else 
                {
                    echo("<tr><td colspan='7'><h3>Aucun compte pour le moment</h3></td></tr>");
                }
                ?>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
