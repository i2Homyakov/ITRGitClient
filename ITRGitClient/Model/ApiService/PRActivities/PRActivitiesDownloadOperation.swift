//
//  PRActivitiesDownloadOperation.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class PRActivitiesDownloadOperation: AsyncOperation {

    private let defaultStartActivity = 0
    private let queue = OperationQueue()
    private let password: String

    private var requestData: PRActivitiesRequestData

    private(set) var activities: [PRActivity]
    private(set) var error: Error?

    init(password: String, prID: Int) {
        requestData = PRActivitiesRequestData(prID: prID, startActivity: defaultStartActivity)
        self.password = password
        activities = []
        super.init()
    }

    override func main() {
        if !isCancelled {
            addNextOperation()
        }
    }

    private func addNextOperation() {
        queue.addOperation(makeOperation())
    }

    private func makeOperation() -> PRActivitiesPageDownloadOperation {
        let operation = PRActivitiesPageDownloadOperation(password: password, requestData: requestData)
        operation.completionBlock = makeCompletionBlockForOperation(operation)

        return operation
    }

    private func makeCompletionBlockForOperation(_ operation: PRActivitiesPageDownloadOperation) -> () -> Void {
        return { [weak self] in
            if let error = operation.error {
                self?.error = error
                self?.state = .finished
                return
            }

            guard let activities = operation.activities else {
                self?.error = ApiServiceError.unknownError.error()
                self?.state = .finished
                return
            }

            self?.activities.append(contentsOf: activities.values)

            if activities.isLastPage {
                self?.state = .finished
                return
            }

            guard let nextPageStart = activities.nextPageStart else {
                self?.state = .finished
                return
            }

            self?.requestData.startActivity = nextPageStart
            self?.addNextOperation()
        }
    }
}
