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
                let tokenDict = response.jsonDict["token"] as? JsonDict,
                let token = tokenDict["access_token"] as? String {
                let expires_in = tokenDict["expires_in"]  as? Double
                let date = Date().addingTimeInterval(expires_in ?? 0)
                UserDefaults.standard.set(date, forKey: Config.Keys.kExpires)
                Config.tokenBearer = token
                completion(nil)
                return
            }
            completion(response.errorDesc)
        }
    }
        
    func openWeb(_ url: String = Config.Url.Shopper + "?token=" + Config.tokenBearer) {
        if let urlWeb = URL(string: url) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd = scene?.delegate as? SceneDelegate {
                sd.openWeb(urlWeb)
            }
        }
    }
}
