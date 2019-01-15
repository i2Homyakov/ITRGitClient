//
//  ApiService.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

protocol ApiService {

    var apiUrl: String { get }

    func sessionFor(authData: AuthenticationData, onFailure: @escaping (Error) -> Void) -> URLSession?
}

struct AuthenticationData {

    var login: String
    var password: String

    init(password: String) {
        login = "i2.homyakov"
        self.password = password
    }
}

class DefaultApiService: ApiService {

    let apiUrl = "https://git.itransition.com/rest/api/1.0"

    func sessionFor(authData: AuthenticationData, onFailure: @escaping (Error) -> Void) -> URLSession? {
        let userPasswordString = "\(authData.login):\(authData.password)"
        guard let userPasswordData = userPasswordString.data(using: String.Encoding.utf8) else {
            onFailure(ApiServiceError.unknownError.error())
            return nil
        }
        let base64EncodedCredential = userPasswordData.base64EncodedString(
            options: Data.Base64EncodingOptions(rawValue: 0))
        let authString = "Basic \(String(describing: base64EncodedCredential))"
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": authString]
        return URLSession(configuration: config)
    }
}
