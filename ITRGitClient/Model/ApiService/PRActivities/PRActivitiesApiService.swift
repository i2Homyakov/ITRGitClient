//
//  PRActivitiesApiService.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PRActivitiesRequestData {

    let project: String
    let repository: String
    let prID: Int
    var startActivity: Int
    let password: String

    init(password: String, prID: Int, startActivity: Int) {
        self.password = password
        self.prID = prID
        self.startActivity = startActivity
        project = AppInputData.project
        repository = AppInputData.repository
    }
}

protocol PRActivitiesApiService {

    func getActivitiesFor(requestData: PRActivitiesRequestData,
                          onSuccess: @escaping (PRActivities) -> Void,
                          onFailure: @escaping (Error) -> Void)
}

class DefaultPRActivitiesApiService: PRActivitiesApiService {

    private let parametersFormat = "/projects/%@/repos/%@/pull-requests/%d/activities?start=%d"
    private let apiService: ApiService = DefaultApiService()

    func getActivitiesFor(requestData: PRActivitiesRequestData,
                          onSuccess: @escaping (PRActivities) -> Void,
                          onFailure: @escaping (Error) -> Void) {
        let urlString = apiService.apiUrl.appendingFormat(
            parametersFormat, requestData.project, requestData.repository, requestData.prID, requestData.startActivity)
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

    private func sessionCompletionHandlerFor(onSuccess: @escaping (PRActivities) -> Void,
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
