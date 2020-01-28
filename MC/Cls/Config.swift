//
//  Config.swift
//  MysteryClient
//
//  Created by mac on 26/06/17.
//  Copyright © 2017 Mebius. All rights reserved.
//
// git: mcappios@git.mebius.it:projects/mcappios - Pw: Mc4ppIos
// web: mysteryclient.mebius.it - User: utente_gen - Pw: novella18

import UIKit

typealias JsonDict = Dictionary<String, Any>
func Lng(_ key: String) -> String {
    return MYLang.value(key)
}

struct AppConf {
    static let urlHome  = "https://mysteryclient.mebius.it/"
    static let client_id = "mystery_app"
    static let client_secret = "UPqwU7vHXGtHk6JyXrA5"
}

struct Config {
    static var tokenNotification = ""

    struct Url {
        static let Shopper = "https://shopper.mebius.it"
        static let grant = AppConf.urlHome + "default/oauth/grant"
        static let Recover = AppConf.urlHome + "login/retrieve-password/app/1"
        static let Signup  = AppConf.urlHome + "login/register?app=1"

//        static let get   = Config.Url.home + "default/rest/get"
    }
//
//    struct DateFmt {
//        static let Ora           = "HH:mm"
//        static let DataJson      = "yyyy-MM-dd"
//        static let DataOraJson   = "yyyy-MM-dd HH:mm:ss"
//        static let dataOutput    = "dd/MM/yyyy"
//        static let dataOraOutput = "dd/MM/yyyy HH:mm"
//
//    }
//    static let maxPicSize:CGFloat = 1200
}

extension UIViewController {
    
    func alert (_ title:String, message: String, cancelBlock:((UIAlertAction) -> Void)?, okBlock:((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancelBlock))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okBlock))
        alert.modalPresentationStyle = .fullScreen
        
        present(alert, animated: true, completion: nil)
    }
    
    func alert (_ title:String, message: String, okBlock:((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title as String, message: message  as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okBlock))
        
        present(alert, animated: true, completion: nil)
    }
}
