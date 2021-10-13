//
//  MensagensDeErro.swift
//  Snapchat
//
//  Created by Renilson Santana on 15/07/21.
//

import Foundation

class MensagensDeErro: NSObject{
    func validacaoMensagensDeErro(erro: NSError) -> String{
        guard let codigoErro = erro.userInfo["FIRAuthErrorUserInfoNameKey"] as? String else{ return " " }
        var msgErro = ""
        switch codigoErro {
        case "ERROR_INVALID_EMAIL":
            msgErro = "E-mail inválido!, digite um e-mail válido."
            break
        case "ERROR_WEAK_PASSWORD":
            msgErro = "A senha precisa ter no mínimo 6 caracteres."
            break
        case "ERROR_EMAIL_ALREADY_IN_USE":
            msgErro = "Esse e-mail já esta sendo utilizado."
            break
        default:
            msgErro = "Dados digitados incorreto."
        }
        return msgErro
    }
}
