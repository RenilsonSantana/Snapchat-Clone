//
//  Snap.swift
//  Snapchat
//
//  Created by user on 08/10/21.
//

import Foundation
class Snap {
    
    // MARK: - Atributos
    
    var identificador: String
    var nome: String
    var de: String
    var descricao: String
    var urlImagem: String
    var idImagem: String
    
    // MARK: - Init
    
    init(id: String, nome: String, de: String, descricao: String, urlImagem: String, idImagem: String) {
        self.identificador = id
        self.nome = nome
        self.de = de
        self.descricao = descricao
        self.urlImagem = urlImagem
        self.idImagem = idImagem
    }
    
    init() {
        identificador = ""
        nome = ""
        de = ""
        descricao = ""
        urlImagem = ""
        idImagem = ""
    }
}
