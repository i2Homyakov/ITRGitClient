//
//  PRActivitiesApiService.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PRActivitiesRequestData {

    var project: String
    var repository: String
    var prID: Int
    var startActivity: Int

    init(prID: Int, startActivity: Int) {
        self.prID = prID
        self.startActivity = startActivity
        project = AppInputData.project
        repository = AppInputData.repository
    }
}

protocol PRActivitiesApiService {

    func getActivitiesFor(requestData: PRActivitiesRequestData,
                          password: String,
                          onSuccess: @escaping (PRActivities) -> Void,
                          onFailure: @escaping (Error) -> Void)
}

class DefaultPRActivitiesApiService: PRActivitiesApiService {

    typealias SessionOnCompletion = (Data?, URLResponse?, Error?) -> Void

    private let parametersFormat = "/projects/%@/repos/%@/pull-requests/%d/activities?start=%d"
    private let apiService: ApiService = DefaultApiService()

    func getActivitiesFor(requestData: PRActivitiesRequestData,
                          password: String,
                          onSuccess: @escaping (PRActivities) -> Void,
                          onFailure: @escaping (Error) -> Void) {
        let urlString = apiService.apiUrl.appendingFormat(
            parametersFormat, requestData.project, requestData.repository, requestData.prID, requestData.startActivity)
        guard let url = URL(string: urlString) else {
            onFailure(ApiServiceError.incorrectUrl.error())
            return
        }

        let session = apiService.sessionFor(authData: AuthenticationData(password: password), onFailure: onFailure)
        session?.dataTask(with: url,
                          completionHandler: taskCompletionHandlerFor(
                            onSuccess: onSuccess, onFailure: onFailure)).resume()
    }

    private func taskCompletionHandlerFor(onSuccess: @escaping (PRActivities) -> Void,
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

            self?.apiService.decodeData(data, onSuccess: onSuccess, onFailure: onFailure)
        }
    }
}
