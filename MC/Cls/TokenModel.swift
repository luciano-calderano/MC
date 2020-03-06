//
//  TokenModel.swift
//  MC
//
//  Created by Developer on 06/03/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

struct TokenModel: Codable {
    struct Token: Codable {
        var access_token: String?
        var expires_in: Double?
    }
    var status: String?
    var code: Int?
    var message: String?
    var token: Token?
}
