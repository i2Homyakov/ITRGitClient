//
//  PRApiService.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

protocol PRApiService {

    func getPRsFor(requestData: PRRequestData,
                   password: String,
                   onSuccess: @escaping (PullRequests) -> Void,
                   onFailure: @escaping (Error) -> Void)
}

struct PRRequestData {

    var project: String
    var repository: String
    var author: String
    var startPR: Int

    init(startPR: Int) {
        self.startPR = startPR
        project = AppInputData.project
        repository = AppInputData.repository
        author = AppInputData.author
    }
}

class DefaultPRApiService: PRApiService {

    private let parametersFormat = "/projects/%@/repos/%@/pull-requests?state=ALL&author=%@&start=%d"
    private let deserializer = JSONDecoder()
    private let apiService: ApiService = DefaultApiService()

    func getPRsFor(requestData: PRRequestData,
                   password: String,
                   onSuccess: @escaping (PullRequests) -> Void,
                   onFailure: @escaping (Error) -> Void) {
        let urlString = apiService.apiUrl.appendingFormat(
            parametersFormat, requestData.project, requestData.repository, requestData.author, requestData.startPR)
        guard let url = URL(string: urlString) else {
            onFailure(ApiServiceError.incorrectUrl.error())
            return
        }

        let session = apiService.sessionFor(authData: AuthenticationData(password: password), onFailure: onFailure)
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
