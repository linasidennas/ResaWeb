
<!DOCTYPE html>

<section id="about" class="about section">
<div class="container mt-5">
    <h1 class="text-center mb-4">Liste des actualités</h1>

    <div class="table-responsive">
        
            <tbody>
                <?php
                  //  echo $parametre_url;
                    echo('<br>');
                    //echo base_url();
                    if (! empty($actu) && is_array($actu))
                      {
                        echo '<div class="table-responsive">';
                        echo '<table class="table table-striped table-bordered">';
                        echo '<thead class="table-dark">';
                        echo '<tr>';
                       // echo '<th>ID</th>';
                        echo '<th>Titre</th>';
                        echo '<th>Contenu</th>';
                       // echo '<th>Description</th>';
                        echo '<th>Date</th>';
                        echo '<th>Auteur</th>';
                        echo '</tr>';
                        echo '</thead>';
                        echo '<tbody>';
                        foreach ($actu as $news)
                        {
                            echo "<tr>";
                            //echo "<td>" . $news["act_id"] . "</td>";
                            echo "<td>" . $news["act_titre"] . "</td>";
                            echo "<td>" . $news["act_contenu"] . "</td>";
                           // echo "<td>" . $news["act_description"] . "</td>";
                            echo "<td>" . $news["act_date"] . "</td>";
                            echo "<td>" . $news["cpt_pseudo"] . "</td>";

                           // echo "<td>" . $news["cpt_id"] . "</td>";

                            echo "</tr>";
                        }
                      }
                      else {
                        echo("<tr><td colspan='3' class='text-center'><h3>Aucune actualité pour l'instant !</h3></td></tr>");
                      }
                ?>
            </tbody>
        </table>
    </div>
</div>
                    </section>
</body>
</html>
