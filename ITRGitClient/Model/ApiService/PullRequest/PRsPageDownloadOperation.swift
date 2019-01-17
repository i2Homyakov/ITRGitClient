//
//  PRsPageDownloadOperation.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class PRsPageDownloadOperation: AsyncOperation {

    private let apiService: PRApiService = DefaultPRApiService()
    private let requestData: PRRequestData

    private(set) var pullRequests: PullRequests?
    private(set) var error: Error?

    init(password: String, startPR: Int) {
        requestData = PRRequestData(password: password, startPR: startPR)
        super.init()
    }

    override func main() {
        if isCancelled {
            return
        }

        apiService.getPRsFor(requestData: requestData, onSuccess: { [weak self] pullRequests in
            self?.pullRequests = pullRequests
            self?.state = .finished
        }, onFailure: { [weak self] error in
            self?.error = error
            self?.state = .finished
        })
    }
}
