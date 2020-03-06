//
//  MyReq.swift
//  MysteryClient
//
//  Created by Developer on 24/01/2020.
//  Copyright © 2020 Mebius. All rights reserved.
//

import Foundation

class MYReq {
    enum MYReqContentType: String {
        case none = ""
        case form = "application/x-www-form-urlencoded"
    }
    enum MYReqType: String {
        case get  = "GET"
        case put  = "PUT"
        case post = "POST"
    }

    var url: URL!
    var contentType = MYReqContentType.form
    var type = MYReqType.post
    var header:JsonDict = [:]
    var params:JsonDict = [:]
    
    struct Response {
        var success = false
        var errorCode = 0
        var errorDesc = ""
        var value: Any?
    }
    
    init(_ urlString: String) {
        url = URL(string: urlString)
    }

    // MARK: - Start
    
    func start(_ completion: @escaping (Response) -> ()) {
        Loader.start()
        let paramsArray: Array = params.compactMap({
            (key, value) -> String in return "\(key)=\(value)"
        })
        
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        if contentType.rawValue.count > 0 {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        for (key, value) in header {
            request.setValue(value as? String, forHTTPHeaderField: key)
        }

        switch type {
        case .get:
            let jsonString = paramsArray.joined(separator: "&")
            let newUrl = url.absoluteString + "?" + jsonString
            request.url = URL(string: newUrl)
        case .put, .post:
            switch contentType {
            case .form:
                let jsonString = paramsArray.joined(separator: "&")
                request.httpBody = jsonString.data(using: .utf8)!
            default:
                break
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                Loader.stop()
                completion(self.elaborate(data, response, error))
            }
        }
        task.resume()
    }
    
    private func elaborate (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Response {
        var resp = Response()
        
        resp.errorCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        if error != nil {
            resp.errorDesc = error?.localizedDescription ?? "Generic error"
            return resp
        }
        if data == nil {
            resp.errorDesc = "Missing data"
            return resp
        }
        if resp.errorCode != 200 {
            resp.errorDesc = "Error: \(resp.errorCode)"
            return resp
        }
        
        guard let value = try? JSONDecoder().decode(TokenModel.self, from: data!) else {
            resp.errorDesc = "Errore decodifica Json"
            return resp
        }
        resp.value = value

        guard let status = value.status else {
            resp.errorDesc = "Errore Json: Status not found"
            return resp
        }

        if status == "ok" {
            resp.success = true
            return resp
        }

        resp.errorDesc = "Generic response error"
        if let errroCode = value.code {
            resp.errorCode = errroCode
        }
        if let errorDesc = value.message {
            resp.errorDesc = errorDesc
        }
        return resp
    }
}
