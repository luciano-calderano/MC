//
//  SelectPic.swift
//  MysteryClient
//
//  Created by Developer on 28/01/2020.
//  Copyright © 2020 Mebius. All rights reserved.
//

import UIKit

class SelectPic: NSObject {
    var mainVC: UIViewController!
    var selected:((UIImage)->())?
    
    init(vc: UIViewController) {
        super.init()
        mainVC = vc
        open()
    }
    
    private func open() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary // | .camera
        picker.delegate = self
        
        let alert = UIAlertController(title: "Invia una foto",
                                      message: "",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Scatta una foto",
                                      style: .default,
                                      handler: { (action) in
                                        self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Carica dalla galleria",
                                      style: .default,
                                      handler: { (action) in
                                        self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "Annulla",
                                      style: .cancel,
                                      handler: { (action) in
        }))
        
        mainVC.present(alert, animated: true) { }
        
    }
    
    private func openGallary() {
        presentPicker(type: .photoLibrary)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable (.camera) else {
            let alert = UIAlertController(title: "Camera Not Found",
                                          message: "This device has no Camera",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            mainVC.present(alert, animated: true, completion: nil)
            return
        }
        presentPicker(type: .camera)
    }
    
    private func presentPicker (type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = false
        if type == .camera {
            picker.cameraCaptureMode = .photo
        }
        mainVC.present(picker, animated: true)
    }
}

//MARK:-

extension SelectPic: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func close () {
        mainVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        close()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertDict(info)
        let imgKey = convertKey(UIImagePickerController.InfoKey.originalImage)
        
        if let pickedImage = info[imgKey] as? UIImage {
            selected?(pickedImage)
        }
        close()
    }
    
    fileprivate func convertDict(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

