//
//  Login.swift
//  MysteryClient
//
//  Created by Developer on 23/01/2020.
//  Copyright © 2020 Mebius. All rights reserved.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var userView: UIView!
    @IBOutlet var passView: UIView!
    
    @IBOutlet var userText: MYTextField!
    @IBOutlet var passText: MYTextField!
    
    @IBOutlet var saveCredButton: MYButton!
    @IBOutlet private var versLabel: UILabel!

    private var checkImg: UIImage?
    private var saveCred = false
    
    private let kUser = "kUser"
    private let kPass = "kPass"

    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versLabel.text = "Vers.\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        checkImg = saveCredButton.image(for: .normal)
        saveCredButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        userText.delegate = self
        passText.delegate = self
        
        userView.layer.cornerRadius = userView.frame.size.height / 2
        passView.layer.cornerRadius = passView.frame.size.height / 2
        
        saveCredButton.setImage(nil, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userText.text = UserDefaults.standard.object(forKey: kUser) as? String ?? ""
        passText.text = UserDefaults.standard.object(forKey: kPass) as? String ?? ""
        saveCred = userText.text!.count > 0

        updateCheckCredential()

        #if DEBUG
//         userText.text = "utente_gen";   passText.text = "novella18"
        #endif
    }
    
    @IBAction func saveCredTapped () {
        saveCred = !saveCred
        updateCheckCredential()
    }
    
    @IBAction func signInTapped () {
        if userText.text!.isEmpty {
            userText.becomeFirstResponder()
            return
        }
        if passText.text!.isEmpty {
            passText.becomeFirstResponder()
            return
        }
        view.endEditing(true)
        
        getToken({ (token) in
            self.logged(token: token)
        })
    }
    
    @IBAction func signUpTapped () {
        openWeb(Config.Url.Signup)
    }
    
    @IBAction func credRecoverTapped () {
        openWeb(Config.Url.Recover)
    }
    
    private func logged(token: String ) {
        if saveCred {
            UserDefaults.standard.set(userText.text, forKey: kUser)
            UserDefaults.standard.set(passText.text, forKey: kPass)
        }
        else {
            UserDefaults.standard.set("", forKey: kUser)
            UserDefaults.standard.set("", forKey: kPass)
        }
        let url = Config.Url.Shopper + "?token=" + token
        openWeb(url)
    }

    //MARK: - private
    
    private func updateCheckCredential() {
        let img: UIImage? = saveCred == true ? checkImg : nil
        saveCredButton.setImage(img, for: .normal)
    }
    
    private func openWeb(_ url: String ) {
        if let urlWeb = URL(string: url) {
            let vc = SFSafariViewController(url: urlWeb)
            vc.preferredBarTintColor = Config.Color.green
            vc.preferredControlTintColor = .white
            vc.dismissButtonStyle = .close
            vc.delegate = self
            present(vc, animated: true)
        }
        
//        let web = WebAppVC.Instance()
//        web.page = url
//        web.modalPresentationStyle = .overFullScreen
//        present(web, animated: false, completion: nil)
    }
}

extension LoginVC: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        if URL.lastPathComponent == "logout" {
            dismiss(animated: true, completion: nil)
            return
        }
    }
}
//
//MARK:- UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userText {
            passText.becomeFirstResponder()
            return true
        }
        if textField == passText {
            view.endEditing(true)
        }
        return true
    }
}

extension LoginVC {
    func getToken(_ completion: @escaping (String) -> ()) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        
        let param = [
            "grant_type"    : "password",
            "client_id"     : AppConf.client_id,
            "client_secret" : AppConf.client_secret,
            "version"       : "i" + version,
            "username"      : userText.text!,
            "password"      : passText.text!,
        ]
        
        let req = MYReq(Config.Url.grant)
        req.params = param
        req.start { (response) in
            print(response)
            if response.success,
                let tokenDict = response.jsonDict["token"] as? JsonDict,
                let token = tokenDict["access_token"] as? String {
                completion(token)
                return
            }
            self.alert("Errore", message: response.errorDesc)
        }
    }
}
