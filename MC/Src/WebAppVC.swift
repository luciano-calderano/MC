//
//  WebAppVC.swift
//  MysteryClient
//
//  Created by Developer on 23/01/2020.
//  Copyright © 2020 Mebius. All rights reserved.
//

import UIKit
import WebKit

class WebAppVC: UIViewController {
    class func Instance () -> WebAppVC {
        let sb = UIStoryboard(name: "WebApp", bundle: nil)
        if #available(iOS 13.0, *) {
            return sb.instantiateViewController(identifier: "WebAppVC") as! WebAppVC
        } else {
            return sb.instantiateViewController(withIdentifier: "WebAppVC") as! WebAppVC
        }
    }
    
    var page = ""
    private var webView = WKWebView()
    private var uploadUrl: URL!
    
    @IBOutlet private var container: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.isUserInteractionEnabled = true
        webView.navigationDelegate = self
        let urlPage = page.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let request = URLRequest(url: URL(string: urlPage!)!)
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Loader.start()
    }
}

extension WebAppVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.stop()
        alert("Errore", message: error.localizedDescription) {
            (result) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.stop()
        
        webView.frame = container.bounds
        container.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(navigationResponse.response.url ?? "-")
        
        if let url = navigationResponse.response.url {
            if url.lastPathComponent == "logout" {
                dismiss(animated: true, completion: nil)
                decisionHandler(.allow)
                return
            }
            if url.absoluteString.contains("ios=1") {
                decisionHandler(.cancel)
                let s = url.absoluteString
                let u = s.replacingOccurrences(of: ".it/", with: ".it/api/")
                uploadUrl = URL(string: u)
                let pic = SelectPic(vc: self)
                pic.selected = { img in
                    self.uploadImage(img)
                }
                return
            }
        }
        decisionHandler(.allow)
    }
    
    private func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return nil
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(challenge)
        completionHandler(.useCredential, nil)
    }
}

extension WebAppVC {
    private func uploadImage (_ img: UIImage) {
        Loader.start()
        Upload().image(img, url: uploadUrl) { (errorDesc) in
            Loader.stop()
            if errorDesc == nil {
                self.done()
            }
            else {
                self.error(errorDesc!)
            }
        }
    }
    
    private func done() {
        print("\nUpload done:\n")
        
        let alert = UIAlertController(title: "", message: "Foto caricata", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func error(_ err: String) {
        print("\nUpload error:\n", err)
        
        let alert = UIAlertController(title: "Errore", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
}
