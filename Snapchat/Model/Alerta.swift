//
//  Alerta.swift
//  Snapchat
//
//  Created by Renilson Santana on 15/07/21.
//

import UIKit

class Alerta: UIViewController {
    func alerta(titulo: String, msg: String) -> UIAlertController{
        let alerta = UIAlertController(title: titulo, message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alerta.addAction(ok)
        
        return alerta
    }
}
