<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Accueil extends BaseController
{
    public function afficher()
    {
        $model = model(Db_model::class);
        $data['titre']="Liste de toutes les actualités";
        $data['actu'] = $model->get_all_actualite();

        return view('menu_visiteur', $data)
        . view('affichage_accueil')
       // .view('templates/milieu')
        . view('templates/bas');
    }
}
?>