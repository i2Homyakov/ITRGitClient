//
//  PRApiService.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PRRequestData {

    let project: String
    let repository: String
    let author: String
    let startPR: Int
    let password: String

    init(password: String, startPR: Int) {
        self.password = password
        self.startPR = startPR
        project = AppInputData.project
        repository = AppInputData.repository
        author = AppInputData.author
    }
}

protocol PRApiService {

    func getPRsFor(requestData: PRRequestData,
                   onSuccess: @escaping (PullRequests) -> Void,
                   onFailure: @escaping (Error) -> Void)
}

class DefaultPRApiService: PRApiService {

    private let parametersFormat = "/projects/%@/repos/%@/pull-requests?state=ALL&author=%@&start=%d"
    private let deserializer = JSONDecoder()
    private let apiService: ApiService = DefaultApiService()

    func getPRsFor(requestData: PRRequestData,
                   onSuccess: @escaping (PullRequests) -> Void,
                   onFailure: @escaping (Error) -> Void) {
        let urlString = apiService.apiUrl.appendingFormat(
            parametersFormat, requestData.project, requestData.repository, requestData.author, requestData.startPR)
        guard let url = URL(string: urlString) else {
            onFailure(ApiServiceError.incorrectUrl.error())
            return
        }

        let session = apiService.sessionFor(authData: AuthenticationData(password: requestData.password),
                                            onFailure: onFailure)
        session?.dataTask(with: url,
                          completionHandler: sessionCompletionHandlerFor(
                            onSuccess: onSuccess, onFailure: onFailure)).resume()
    }

    private func sessionCompletionHandlerFor(onSuccess: @escaping (PullRequests) -> Void,
                                             onFailure: @escaping (Error) -> Void) -> SessionOnCompletion {
        return { [weak self] (data, response, error) in
            if let error = error {
                onFailure(error)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == HttpStatusCode.okay.code else {
                onFailure(ApiServiceError.not200.error())
                return
            }

            self?.apiService.decodeData(data, onSuccess: onSuccess, onFailure: onFailure)
        }
    }

}
