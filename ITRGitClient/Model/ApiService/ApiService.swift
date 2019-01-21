//
//  ApiService.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

typealias SessionOnCompletion = (Data?, URLResponse?, Error?) -> Void

enum HttpStatusCode: Int {
    case okay = 200

    var code: Int {
        return self.rawValue
    }
}

struct AuthenticationData {

    let login: String
    let password: String

    init(password: String) {
        login = AppInputData.login
        self.password = password
    }
}

protocol ApiService {

    var apiUrl: String { get }

    func sessionFor(authData: AuthenticationData, onFailure: @escaping (Error) -> Void) -> URLSession?
    func decodeData<T: Codable>(_ data: Data?, onSuccess: @escaping (T) -> Void, onFailure: @escaping (Error) -> Void)
}

class DefaultApiService: ApiService {

    private let deserializer = JSONDecoder()

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

    func decodeData<T: Codable>(_ data: Data?,
                                onSuccess: @escaping (T) -> Void,
                                onFailure: @escaping (Error) -> Void) {
        guard let data = data else {
            onFailure(ApiServiceError.unknownError.error())
            return
        }

        do {
            if let decodedObject: T = try deserializer.decodeWith(data: data) {
                onSuccess(decodedObject)
            }
        } catch {
            onFailure(error)
        }
    }
}
