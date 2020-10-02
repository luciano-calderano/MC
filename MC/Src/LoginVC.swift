//
//  Login.swift
//  MysteryClient
//
//  Created by Developer on 23/01/2020.
//  Copyright © 2020 Mebius. All rights reserved.
//

import UIKit
//import SafariServices

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
    
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let press = UILongPressGestureRecognizer(target: self, action: #selector(versPressed))
        versLabel.addGestureRecognizer(press)
        versLabel.isUserInteractionEnabled = true;
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
        
        userText.text = UserDefaults.standard.object(forKey: Config.Keys.kUser) as? String ?? ""
        passText.text = UserDefaults.standard.object(forKey: Config.Keys.kPass) as? String ?? ""
        saveCred = userText.text!.count > 0

        updateCheckCredential()

        #if DEBUG
         userText.text = "utente_gen";   passText.text = "nov&lla18"
        #endif
    }
    
    @objc func versPressed() {
        self.alert("UIDD", message: Config.Token.notification)
        UIPasteboard.general.string = Config.Token.notification
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
        
        LoginUtil.loginWith(userText.text!, passText.text!, {
            (responseError) in
            if let err = responseError {
                if err.count > 0 {
                    self.alert("Errore", message: err)
                }
                return
            }
            self.logged()
        })
    }
    
    @IBAction func signUpTapped () {
        LoginUtil().openWeb(Config.Url.Signup)
    }
    
    @IBAction func credRecoverTapped () {
        LoginUtil().openWeb(Config.Url.Recover)
    }
    
    private func logged() {
        if saveCred {
            UserDefaults.standard.set(userText.text, forKey: Config.Keys.kUser)
            UserDefaults.standard.set(passText.text, forKey: Config.Keys.kPass)
        }
        else {
            UserDefaults.standard.set("", forKey: Config.Keys.kUser)
            UserDefaults.standard.set("", forKey: Config.Keys.kPass)
        }
        LoginUtil().openWeb()
        sendTokenPush()
    }

    //MARK: - private
    
    private func updateCheckCredential() {
        let img: UIImage? = saveCred == true ? checkImg : nil
        saveCredButton.setImage(img, for: .normal)
    }
}

//MARK:- UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userText:
            passText.becomeFirstResponder()
        case passText:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
}

extension LoginVC {
    private func sendTokenPush() {
        let param = [
            "object"    : "notification_token",
            "object_id" : Config.Token.notification
        ]
        
        let req = MYReq(Config.Url.put)
        req.params = param
        req.type = .put
        req.header = [
            "Authorization" :  "Bearer \(Config.Token.bearer)"
        ]
        req.start { (response) in
            print(param, response)
            if response.success == false {
                self.alert("Errore", message: response.errorDesc)
            }
        }
    }
}
