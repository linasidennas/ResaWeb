<!DOCTYPE html>
<html lang="fr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<body class="bg-light">

<div class="container mt-5">
    <h1 class="text-center mb-4">Liste des adhérents</h1>

    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead class="table-dark text-center">
                <tr>
                    <th>Pseudo</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Email</th>
                    <th>Téléphone</th>
                    
                </tr>
            </thead>

            <tbody class="text-center">
                <?php
                if (! empty($adherents) && is_array($adherents))
                {
                    foreach ($adherents as $p)
                    {
                        echo "<tr>";
                        echo "<td>" . $p["cpt_pseudo"] . "</td>";
                        echo "<td>" . $p["pfl_nom"] . "</td>";
                        echo "<td>" . $p["pfl_prenom"] . "</td>";
                        echo "<td>" . $p["pfl_email"] . "</td>";
                        echo "<td>" . $p["pfl_numero_de_telephone"] . "</td>";

                        
                        echo "</tr>";
                    }
                }
                else 
                {
                    echo("<tr><td colspan='6'><h3>Aucun adhérent trouvé</h3></td></tr>");
                }
                ?>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
