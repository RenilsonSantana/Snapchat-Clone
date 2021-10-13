//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by user on 08/10/21.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class DetalhesSnapViewController: UIViewController {
    
    // MARK: - Atributos
    
    var snap: Snap = Snap()
    
    // MARK: - IBOutlets
    
    @IBOutlet var imagem: UIImageView!
    @IBOutlet var detalhes: UILabel!
    @IBOutlet var contador: UILabel!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeSnap()
        self.removeImagem()
    }
    
    // MARK: - Metodos
    
    func configuraView(){
        detalhes.text = snap.descricao
        
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { imagem, erro, cache, url in
            if erro == nil {
                self.contaTempo()
            }
        }
    }
    
    func removeSnap() {
        guard let idUsuarioLogado = Auth.auth().currentUser?.uid else { return }
        let usuariosRef = Database.database().reference().child("usuarios")
        let snaps = usuariosRef.child(idUsuarioLogado).child("snaps")
        snaps.child(snap.identificador).removeValue()
    }
    
    func removeImagem() {
        let imagensRef = Storage.storage().reference().child("imagens")
        imagensRef.child("\(snap.idImagem).jpg").delete { error in
            
            if error == nil {
                print("Imagem removida com sucesso!")
            } else {
                print("Erro ao remover imagem!")
            }
        }
    }
    
    func contaTempo() {
        var cont = 10
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if cont == 0 {
                timer.invalidate()
                self.dismiss(animated: true, completion: nil)
            } else {
                cont -= 1
                self.contador.text = "\(cont)"
            }
        }
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
