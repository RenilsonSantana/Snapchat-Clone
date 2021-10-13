//
//  EntrarViewController.swift
//  Snapchat
//
//  Created by Renilson Santana on 30/06/21.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textSenha: UITextField!
    
    // MARK: IBActions
    
    @IBAction func entrar(_ sender: Any) {
        guard let email = textEmail.text else {return}
        guard let senha = textSenha.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: senha) { usuario, error in
            if error == nil{
                if usuario != nil{
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else{
                    let alert = Alerta().alerta(titulo: "Usuario não cadastrado", msg: "Falha ao realizar login, Usuario não cadastrado!")
                    self.present(alert, animated: true, completion: nil)
                }
            } else{
                if let erro = error as NSError?{
                    let msgErro = MensagensDeErro().validacaoMensagensDeErro(erro: erro)
                    let alert = Alerta().alerta(titulo: "Erro ao realizar Login", msg: msgErro)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
