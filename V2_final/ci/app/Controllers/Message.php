<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Message extends BaseController
{
public function __construct()
{
    helper('form');
    $this->model = model(Db_model::class);}

public function suivre($chaine = null)
{
        if ($chaine == null)
        {
           return redirect()->to('/');

           /* echo view('menu_visiteur');
            echo '
            <div class="container mt-5">
                <div class="alert alert-danger text-center shadow-sm">
                    Veuillez entrer un code pour suivre votre demande.
                </div>
            </div>';
            echo view('templates/bas');return;*/
        }

        //recuperer le res de la requete dans info 
        $info = $this->model->get_suivi_message($chaine);
        if ($info){
            $data['title']="Les informations liées à votre demande : ";
            $data['info'] = $info;

            return view('menu_visiteur', $data)
            . view('suivi_message')
            . view('templates/bas');
        }else if (strlen($chaine) !== 20) {
            echo view('menu_visiteur');
            echo '
            <div class="container mt-5">
                <div class="alert alert-danger text-center shadow-sm">
                    Le code doit avoir 20 caractères.
                </div>
            </div>';
            echo view('templates/bas');

        }else{ 
          //si info est null donc code incorect
            echo view('menu_visiteur');
            echo '
            <div class="container mt-5">
                <div class="alert alert-danger text-center shadow-sm">
                    Aucun message trouvé pour le code saisi. 
                    <br>
                    Veuillez réessayer avec le bon code ! 
                </div>
            </div>';
            echo view('templates/bas');
        }
    
}


public function verifier()
{
    //$this->model = model(Db_model::class);
    // L’utilisateur a validé le formulaire en cliquant sur le bouton
    if ($this->request->getMethod()=="POST")
    {
        if (! $this->validate([
        'code' => 'required|max_length[20]|min_length[20]',
        ],
        [ // Configuration des messages d’erreurs
            'code' => [
            'required' => 'Veuillez remplir le formulaire !',
            'min_length' => 'Le code doit avoir 20 caractères !',
            'max_length' => 'Le code doit avoir 20 caractères !',
            ],
            ]
        ))
        {
            // La validation du formulaire a échoué, retour au formulaire !
            return view('menu_visiteur', ['titre' => 'Verifier votre demande '])
            . view('message/message_verifier')
            . view('templates/bas');
        }
            $code = $this->request->getPost('code');
            $info = $this->model->get_suivi_message($code);
            if ($info){
                $data['title']="Les informations liées à votre demande : ";
                $data['info'] = $info;


                 return view('menu_visiteur', $data)
                . view('suivi_message')
                 . view('templates/bas');
            }else{ 
                echo view('menu_visiteur',['titre' => 'Verifier votre demande ']);
                echo '
                <div class="container mt-5">
                    <div class="alert alert-danger text-center shadow-sm">
                        Aucun message trouvé pour le code saisi. 
                        <br>Veuillez réessayer avec le bon code !
                    </div>
                </div>';
                echo view('message/message_verifier')
                . view('templates/bas');
                return;
            }
        }
    // L’utilisateur veut afficher le formulaire pour créer un compte
    return view('menu_visiteur', ['titre' => 'Verifier votre demande'])
    . view('message/message_verifier')
    . view('templates/bas');

}


public function inserer()
{
    //$this->model = model(Db_model::class);
    // L’utilisateur a validé le formulaire en cliquant sur le bouton
    if ($this->request->getMethod()=="POST")
    {
        if (! $this->validate([
        'sujet' => 'required|max_length[255]',
        'contenu' => 'required|max_length[255]|min_length[0]',
        'email' => 'required|max_length[255]|min_length[0]',
        ],
        [ // Configuration des messages d’erreurs
            'sujet' => [
            'required' => 'Veuillez remplir les champs de saisie',
            ],
            'contenu' => [
            'required' => 'Veuillez remplir les champs de saisie',
            ],
            'email' => [
            'required' => 'Veuillez remplir les champs de saisie',
            ],
            ]
        ))
        {
            // La validation du formulaire a échoué, retour au formulaire !
            return view('menu_visiteur', ['titre' => 'Envoyer un message '])
            . view('message/message_inserer')
            . view('templates/bas');
        }
        // La validation du formulaire a réussi, traitement du formulaire
        $recuperation = $this->validator->getValidated();
        $recuperation['code'] = bin2hex(random_bytes(10)); 
        $this->model->set_message($recuperation);
        $data['le_message']="Voici votre code pour suivre votre demande : ";
        $data['le_code']=$recuperation['code'];
        //Appel de la fonction créée dans le précédent tutoriel :
        //$data['le_total']=$this->model->get_number_compte();
        return view('menu_visiteur', $data)
        . view('message/message_succes')
        . view('templates/bas');
    }
    // L’utilisateur veut afficher le formulaire pour créer un compte
    return view('menu_visiteur', ['titre' => 'Envoyer un message'])
    . view('message/message_inserer')
    . view('templates/bas');
    }
}

