//
//  CadastrarViewController.swift
//  Snapchat
//
//  Created by Renilson Santana on 30/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastrarViewController: UIViewController {
    
    // MARK: - Atributos
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textNome: UITextField!
    @IBOutlet weak var textSenha: UITextField!
    @IBOutlet weak var textConfirmaSenha: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func botaoCriarConta(_ sender: Any) {
        criarConta()
    }
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Metodos
    
    func criarConta(){
        guard let email = textEmail.text else{return}
        guard let nome = textNome.text else{return}
        guard let senha = textSenha.text else{return}
        guard let confirmaSenha = textConfirmaSenha.text else{return}
        
        if senha == confirmaSenha {
            if nome != "" {
                Auth.auth().createUser(withEmail: email, password: senha) { usuario, error in
                    if error == nil{
                        if usuario != nil{
                            let database = Database.database().reference()
                            let usuarios = database.child("usuarios")
                            let usuarioDados = ["nome": nome, "email": email]
                            usuarios.child(usuario!.user.uid).setValue(usuarioDados)
                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                        }
                    } else{
                        if let erro = error as NSError?{
                            let msgErro = MensagensDeErro().validacaoMensagensDeErro(erro: erro)
                            let alert = Alerta().alerta(titulo: "Dados inválido", msg: msgErro)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            } else{
                let alert = Alerta().alerta(titulo: "Dados incorretos", msg: "Digite o seu nome para proceguir!")
                present(alert, animated: true, completion: nil)
            }
        } else{
            let alert = Alerta().alerta(titulo: "Senha inconsistente", msg: "As senhas não estão iguais, digite novamente!")
            present(alert, animated: true, completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
