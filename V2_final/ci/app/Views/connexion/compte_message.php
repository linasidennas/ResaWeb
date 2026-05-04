<!DOCTYPE html>

<section id="about" class="about section">
<div class="container mt-5">
    <h1 class="text-center mb-4"><?php echo $titre; ?></h1>

    <div class="table-responsive">

        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Sujet</th>
                    <th>Contenu</th>
                    <th>Email</th>
                    <th>Date</th>
                    <th>État</th>
                    <th>Répondre</th>
                </tr>
            </thead>

            <tbody>
                <?php
                if (! empty($mes) && is_array($mes))
                {
                    foreach ($mes as $m)
                    {
                        // Mise en avant visuelle des messages sans réponse
                        $style = "";
                        if ($m["msg_reponse"] == NULL || $m["msg_reponse"] == "")
                        {
                            $style = "style='background:#ffe6e6;font-weight:bold;'";
                            $etat = "<span class='badge bg-danger'>En attente</span>";
                        }
                        else
                        {
                            $etat = "<span class='badge bg-success'>Répondu</span>";
                        }

                        echo "<tr $style>";

                        echo "<td>" . $m["msg_sujet"] . "</td>";
                        echo "<td>" . $m["msg_contenu"] . "</td>";
                        echo "<td>" . $m["msg_email"] . "</td>";
                        echo "<td>" . $m["msg_date"] . "</td>";
                        echo "<td>" . $etat . "</td>";

                        echo "<td>
                            <a class='btn btn-primary btn-sm' 
                            href='".base_url("index.php/compte/envoyer_reponse/".$m["msg_code"])."'>
                            Répondre
                            </a>
                        </td>";
                        
                        echo "</tr>";
                    }
                }
                else
                {
                    echo("<tr><td colspan='6' class='text-center'>
                            <h3>Aucun message pour l'instant !</h3>
                          </td></tr>");
                }
                ?>
            </tbody>
        </table>

    </div>
</div>
</section>
</body>
</html>
