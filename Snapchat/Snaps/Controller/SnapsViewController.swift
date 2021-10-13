//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Renilson Santana on 15/07/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Atributos
    
    var listSnaps: [Snap] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func sair(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch{
            print("Erro ao deslogar")
        }
    }
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getSnaps()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Metodos
    
    func getSnaps(){
        guard let idUsuario = Auth.auth().currentUser?.uid else { return }
        let snapsRef = Database.database().reference().child("usuarios").child(idUsuario).child("snaps")
        snapsRef.observe(.childAdded, with: { snapshot in
            let dados = snapshot.value as? NSDictionary
            
            let id = snapshot.key
            let de = dados?["de"] as! String
            let descricao = dados?["descricao"] as! String
            let idImagem = dados?["idImagem"] as! String
            let nome = dados?["nome"] as! String
            let urlImagem = dados?["urlImagem"] as! String
            
            let snap = Snap(id: id, nome: nome, de: de, descricao: descricao, urlImagem: urlImagem, idImagem: idImagem)
            
            self.listSnaps.append(snap)
            self.tableView.reloadData()
        })
        
        snapsRef.observe(.childRemoved, with: { snapshot in
            print(snapshot)
            var index = 0
            for snap in self.listSnaps {
                if snap.identificador == snapshot.key {
                    self.listSnaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listSnaps.count == 0 {
            return 1
        }
        return listSnaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSnaps", for: indexPath)
        
        if listSnaps.count == 0 {
            cell.textLabel?.text = "Não há nenhum snap para você :("
        } else {
            cell.textLabel?.text = listSnaps[indexPath.row].nome
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listSnaps.count > 0 {
            let snap = listSnaps[indexPath.row]
            self.performSegue(withIdentifier: "detalhesSnapSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesSnapSegue" {
            let viewController = segue.destination as? DetalhesSnapViewController
            let snap = sender as! Snap
            
            viewController?.snap = snap
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
