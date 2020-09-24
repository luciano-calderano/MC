//
//  Login.swift
//  MC
//
//  Created by Developer on 06/03/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class LoginUtil: NSObject {
    class func getToken(_ user:String, _ pass: String, _ completion: @escaping (String?) -> ()) {
        if user.isEmpty || pass.isEmpty {
            completion("")
            return
        }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        
        let param = [
            "grant_type"    : "password",
            "client_id"     : Config.Keys.client_id,
            "client_secret" : Config.Keys.client_secret,
            "version"       : "i" + version,
            "username"      : user,
            "password"      : pass,
        ]
        
        let req = MYReq(Config.Url.grant)
        req.params = param
        req.start { (response) in
            print(response)
            if response.success, let r = response.value as? ResponseModel {
                if r.code == 200 {
                    if let token = r.token?.access_token {
                        let expires_in = r.token?.expires_in ?? 0
                        let date = Date().addingTimeInterval(expires_in)
                        UserDefaults.standard.set(date, forKey: Config.Keys.kExpires)
                        Config.Token.bearer = token
                        completion(nil)
                        return
                    }
                }
            }
            completion(response.errorDesc)
        }
    }
        
    func openWeb(_ url: String = Config.Url.Login + "?token=" + Config.Token.bearer) {
        if let urlWeb = URL(string: url) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                if let sd = scene?.delegate as? SceneDelegate {
                    sd.openWeb(urlWeb)
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
