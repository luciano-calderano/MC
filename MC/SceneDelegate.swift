//
//  SceneDelegate.swift
//  MC
//
//  Created by Developer on 06/03/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import SafariServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var safariVC: SFSafariViewController!

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let d = UserDefaults.standard.object(forKey: Config.Keys.kExpires) as? Date, Date() > d {
            let user = UserDefaults.standard.object(forKey: Config.Keys.kUser) as? String ?? ""
            let pass = UserDefaults.standard.object(forKey: Config.Keys.kPass) as? String ?? ""

            LoginUtil.loginWith(user, pass, { (responseError) in
                if responseError == nil {
                    self.getRootVC()?.dismiss(animated: false, completion: nil)
                    LoginUtil().openWeb()
                }
            })
        }
    }
}

extension SceneDelegate {
    func openWeb(_ url: URL) {
        safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = Config.Color.green
        safariVC.preferredControlTintColor = .white
        safariVC.dismissButtonStyle = .close
        safariVC.delegate = self
        getRootVC()?.present(safariVC, animated: true, completion: nil)
    }
    
    func getRootVC () -> UIViewController? {
        let w = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return w?.rootViewController
    }
}

extension SceneDelegate: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
        if URL.lastPathComponent == "logout" {
            getRootVC()?.dismiss(animated: true, completion: nil)
            UserDefaults.standard.removeObject(forKey: Config.Keys.kExpires)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("finish")
        UserDefaults.standard.removeObject(forKey: Config.Keys.kExpires)
    }
}

