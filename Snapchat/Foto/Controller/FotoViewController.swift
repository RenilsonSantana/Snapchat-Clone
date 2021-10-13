//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Renilson Santana on 15/07/21.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Atributos
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var textDescricao: UITextField!
    @IBOutlet var btnEnviar: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func selecionarFoto(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func enviarImagem(_ sender: Any) {
        btnEnviar.isEnabled = false
        
        btnEnviar.setTitle("Enviando...", for: .normal)
        
        let armazenamento = Storage.storage().reference()
        let imageRef = armazenamento.child("imagens").child("\(idImagem).jpg")
        
        //Recuperar imagem
        if let imagemSelecionada = imagem.image {
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.5){
                imageRef.putData(imagemDados, metadata: nil) { metaDados, erro in
                    if erro == nil{
                        imageRef.downloadURL { url, error in
                            if error == nil{
                                if let downloadUrl = url {
                                    let downloadUrlString = downloadUrl.absoluteString
                                    self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: downloadUrlString)
                                }
                            } else {
                                let alert = Alerta().alerta(titulo: "Falha ao recuperar URL", msg: "Erro ao tentar recuperar url da imagem, tente novamente!")
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } else{
                        let alert = Alerta().alerta(titulo: "Upload falhou", msg: "Erro ao salvar arquivo, tente novamente!")
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.btnEnviar.isEnabled = true
                    self.btnEnviar.setTitle("Enviar", for: .normal)
                }
            }
        }
    }
    
    // Quando o teclado esta aberto e clica em algum lugar da tela, o teclado fecha
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - UIStoryboardSegue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue" {
            let viewController = segue.destination as? UsuariosTableViewController
            viewController?.idImagem = idImagem
            viewController?.descricao = textDescricao.text!
            viewController?.urlImagem = sender as! String
        }
        
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        
        btnEnviar.isEnabled = false
        btnEnviar.backgroundColor = .gray
    }
    
    // MARK: - UIImagePickerController
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagemRecuperada = info[.originalImage] as? UIImage
        
        imagem.image = imagemRecuperada
        
        btnEnviar.isEnabled = true
        btnEnviar.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
        picker.dismiss(animated: true, completion: nil)
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
