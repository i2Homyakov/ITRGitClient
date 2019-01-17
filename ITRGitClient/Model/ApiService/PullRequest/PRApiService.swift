//
//  PRApiService.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PRRequestData {

    var project: String
    var repository: String
    var author: String
    var startPR: Int
    var password: String

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

    typealias SessionOnCompletion = (Data?, URLResponse?, Error?) -> Void

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

        let session = apiService.sessionFor(authData: AuthenticationData(password: requestData.password), onFailure: onFailure)
        session?.dataTask(with: url,
                          completionHandler: taskCompletionHandlerFor(
                            onSuccess: onSuccess, onFailure: onFailure)).resume()
    }

    private func taskCompletionHandlerFor(onSuccess: @escaping (PullRequests) -> Void,
                                          onFailure: @escaping (Error) -> Void) -> SessionOnCompletion {
        return { [weak self] (data, response, error) in
            if let error = error {
                onFailure(error)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                onFailure(ApiServiceError.not200.error())
                return
            }

            self?.decodeData(data, onSuccess: onSuccess, onFailure: onFailure)
        }
    }

    private func decodeData(_ data: Data?,
                            onSuccess: @escaping (PullRequests) -> Void,
                            onFailure: @escaping (Error) -> Void) {
        guard let data = data else {
            onFailure(ApiServiceError.unknownError.error())
            return
        }

        do {
            if let pullRequests: PullRequests = try deserializer.decodeWith(data: data) {
                onSuccess(pullRequests)
            }
        } catch let error as NSError {
            onFailure(error)
        }
    }

}
