//
//  PRActivitiesPageDownloadOperation.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class PRActivitiesPageDownloadOperation: AsyncOperation {

    private let apiService: PRActivitiesApiService = DefaultPRActivitiesApiService()
    private let requestData: PRActivitiesRequestData

    private(set) var activities: PRActivities?
    private(set) var error: Error?

    init(requestData: PRActivitiesRequestData) {
        self.requestData = requestData
        super.init()
    }

    override func main() {
        if isCancelled {
            return
        }

        apiService.getActivitiesFor(requestData: requestData, onSuccess: { [weak self] activities in
            self?.activities = activities
            self?.state = .finished
            }, onFailure: { [weak self] error in
                self?.error = error
                self?.state = .finished
        })
    }
}
