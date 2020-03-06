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

enum Config {
    static var tokenNotification = ""
    static var tokenBearer = ""
    enum Keys {
        static let client_id = "mystery_app"
        static let client_secret = "UPqwU7vHXGtHk6JyXrA5"
        static let kUser = "kUser"
        static let kPass = "kPass"
        static let kExpires = "kExpires"
    }
    enum Color {
        static let green = UIColor(red: 173/255, green: 209/255, blue: 75/255, alpha: 1)
    }
    enum Url {
        static let Home  = "https://mysteryclient.mebius.it/"
        static let Shopper = "https://shopper.mebius.it"
        static let grant = Url.Home + "default/oauth/grant"
        static let put   = Url.Home + "default/rest/put"
        static let Recover = Url.Home + "login/retrieve-password/app/1"
        static let Signup  = Url.Home + "login/register?app=1"
    }
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
