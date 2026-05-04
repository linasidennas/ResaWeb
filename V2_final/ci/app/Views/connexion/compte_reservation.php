
<!DOCTYPE html>

<section id="about" class="about section">
<div class="container mt-5">
    <h1 class="text-center mb-4">Liste des réservations</h1>

    <div class="table-responsive">
        
            <tbody>
                <?php
                  //  echo $parametre_url;
                    echo('<br>');
                    //echo base_url();
                    if (! empty($reserv) && is_array($reserv))
                      {
                        echo '<div class="table-responsive">';
                        echo '<table class="table table-striped table-bordered">';
                        echo '<thead class="table-dark">';
                        echo '<tr>';
                       // echo '<th>ID</th>';
                        echo '<th>Nom</th>';
                        echo '<th>Lieu</th>';
                       // echo '<th>Description</th>';
                        echo '<th>Date</th>';
                       
                        echo '<th>Participants</th>' ;
                        //echo '<th>Auteur</th>';
                        echo '<th>Ressource</th>';
                        echo '</tr>';
                        echo '</thead>';
                        echo '<tbody>';
                        foreach ($reserv as $res)
                        {
                            echo "<tr>";
                            //echo "<td>" . $res["act_id"] . "</td>";
                            echo "<td>" . $res["res_nom"] . "</td>";
                            echo "<td>" . $res["res_lieu"] . "</td>";
                           // echo "<td>" . $res["act_description"] . "</td>";
                            echo "<td>" . $res["res_date"] . "</td>";
                        
                           
                            echo "<td>" . $res['liste_participants(res_id)'] . "</td>";

                           // echo "<td>" . $res["cpt_id"] . "</td>";
                           echo "<td>" . $res["rsc_nom"] . "</td>";
                           // echo "<td><pre style='margin:0'>" . $res["liste_participants"] . "</pre></td>";

                            echo "</tr>";
                        }
                      }
                      else {
                        echo("<tr><td colspan='3' class='text-center'><h3>Aucune reservation pour l'instant !</h3></td></tr>");
                      }
                ?>
            </tbody>
        </table>
    </div>
</div>
                    </section>
</body>
</html>
