//
//  UsuariosTableViewController.swift
//  Snapchat
//
//  Created by user on 07/10/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsuariosTableViewController: UITableViewController {
    
    // MARK: - Atributos
    
    var listUsuarios: [Usuario] = []
    var urlImagem = ""
    var descricao = ""
    var idImagem = ""

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUsuariosDatabase()
    }
    
    // MARK: - Metodos
    
    func getUsuariosDatabase() {
        let database = Database.database().reference()
        let usuarios = database.child("usuarios")
        
        //Adiciona evento novo usuario adicionado
        usuarios.observe(DataEventType.childAdded) { snapshort in
            let dados = snapshort.value as? NSDictionary
            
            //Recuperar os dados
            let nome = dados?["nome"] as! String
            let email = dados?["email"] as! String
            let id = snapshort.key
            
            let usuario = Usuario(nome: nome, email: email, id: id)
            
            //Adicionar no array usuario que náo seja o que esta logado
            let idUsuarioLogado = self.getIdUsuarioLogado()
            if idUsuarioLogado != usuario.id {
                self.listUsuarios.append(usuario)
                self.tableView.reloadData()
            }
        }
    }
    
    func getIdUsuarioLogado() -> String {
        let autenticacao = Auth.auth()
        guard let idUsuarioLogado = autenticacao.currentUser?.uid else {return ""}
        return idUsuarioLogado
    }
    
    func enviarSnap(para: Usuario) {
        let idUsuarioSelecionado = para.id
        
        let usuarios = Database.database().reference().child("usuarios")
        let snaps = usuarios.child(idUsuarioSelecionado).child("snaps")
        
        let idUsuarioLogado = getIdUsuarioLogado()
     
        let usuarioLogadoRef = usuarios.child(idUsuarioLogado)

        //Recuperar dados do usuario logado
        usuarioLogadoRef.observeSingleEvent(of: .value) { snapshot in
            let dados = snapshot.value as? NSDictionary
            
            let nomeUsuarioLogado = dados?["nome"] as! String
            let emailUsuarioLogado = dados?["email"] as! String
            
            let snap = [
                "de": emailUsuarioLogado,
                "nome": nomeUsuarioLogado,
                "descricao": self.descricao,
                "idImagem": self.idImagem,
                "urlImagem": self.urlImagem
            ]
            
            snaps.childByAutoId().setValue(snap)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listUsuarios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath)
        
        cell.textLabel?.text = self.listUsuarios[indexPath.row].nome
        cell.detailTextLabel?.text = self.listUsuarios[indexPath.row].email

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuarioSelecionado = self.listUsuarios[indexPath.row]
        self.enviarSnap(para: usuarioSelecionado)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
