//
//  Upload.swift
//  MysteryClient
//
//  Created by Developer on 28/01/2020.
//  Copyright © 2020 Mebius. All rights reserved.
//

import UIKit

class Upload {
    func image(_ image: UIImage, url: URL, _ completion: @escaping ((String?)->())) {
        // the image in UIImage type
        let boundary = UUID().uuidString
        
        //    let filename = "avatar.png"
        //    let fieldName = "reqtype"
        //    let fieldValue = "fileupload"
        //    let fieldName2 = "userhash"
        //    let fieldValue2 = "caa3dce4fcb36cfdf9258ad9c"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the reqtype field and its value to the raw http request data
        //    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        //    data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        //    data.append("\(fieldValue)".data(using: .utf8)!)
        //
        //    // Add the userhash field and its value to the raw http reqyest data
        //    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        //    data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        //    data.append("\(fieldValue2)".data(using: .utf8)!)
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        //    data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { data, response, error in
            if error != nil {
                completion(error?.localizedDescription)
                return
            }
            
            if data == nil {
                completion("no response data")
                return
            }
            
            if let responseString = String(data: data!, encoding: .utf8) {
                print(responseString)
                completion(nil)
                return
            }
            completion("errore upload")
        }).resume()
    }
    
    func image1(_ image: UIImage, url: URL, _ completion: @escaping ((String?)->())) {
        let imageData = image.jpegData(compressionQuality: 0.7)
        let session = URLSession(configuration: .default)
        let boundary = UUID().uuidString;

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        let contentType = "multipart/form-data;boundary=\(boundary)"
        req.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var uploadData = Data()
        uploadData.append("\r\n\(boundary)\r\n".data(using: .utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"img\"; filename=\"img.jpg\"\r\n".data(using: .utf8)!)
        uploadData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        uploadData.append(imageData!)
        uploadData.append("\r\n\(boundary)\r\n".data(using: .utf8)!)
        
        req.httpBody = uploadData

        let task = session.dataTask(with: req, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completion(error?.localizedDescription)
                return
            }
            
            if data == nil {
                completion("no response data")
                return
            }
            
            if let responseString = String(data: data!, encoding: .utf8) {
                print(responseString)
                completion(nil)
                return
            }
            completion("errore upload")
        })
        
        task.resume()
    }
}
