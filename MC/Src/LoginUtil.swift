//
//  Login.swift
//  MC
//
//  Created by Developer on 06/03/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class LoginUtil: NSObject {
    class func getToken(_ completion: @escaping (String?) -> ()) {
        let user = UserDefaults.standard.object(forKey: Config.Keys.kUser) as? String ?? ""
        let pass = UserDefaults.standard.object(forKey: Config.Keys.kPass) as? String ?? ""
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
            if response.success,
                let r = response.value as? ResponseModel,
                let token = r.token?.access_token {
                let expires_in = r.token?.expires_in ?? 0
                let date = Date().addingTimeInterval(expires_in)
                UserDefaults.standard.set(date, forKey: Config.Keys.kExpires)
                Config.Token.bearer = token
                completion(nil)
                return
            }
            completion(response.errorDesc)
        }
    }
        
    func openWeb(_ url: String = Config.Url.Login + "?token=" + Config.Token.bearer) {
        if let urlWeb = URL(string: url) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd = scene?.delegate as? SceneDelegate {
                sd.openWeb(urlWeb)
            }
        }
    }
}
