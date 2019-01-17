//
//  PRsDownloadOperation.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class PRsDownloadOperation: AsyncOperation {

    private let queue = OperationQueue()

    private var startPR: Int
    private var password: String

    private(set) var pullRequests: [PullRequest]
    private(set) var error: Error?

    init(password: String) {
        startPR = 0
        self.password = password
        pullRequests = []
        super.init()
    }

    override func main() {
        if isCancelled {
            return
        }
        addNextOperation()
    }

    private func makeOperationForStartPR(_ startPR: Int) -> PRsPageDownloadOperation {
        let operation = PRsPageDownloadOperation(password: password, startPR: startPR)
        operation.completionBlock = makeCompletionBlockForOperation(operation)

        return operation
    }

    private func addNextOperation() {
        let operation = makeOperationForStartPR(startPR)
        queue.addOperations([operation], waitUntilFinished: false)
    }

    private func makeCompletionBlockForOperation(_ operation: PRsPageDownloadOperation) -> () -> Void {
        return { [weak self] in
            if let error = operation.error {
                self?.error = error
                self?.state = .finished
                return
            }

            guard let pullRequests = operation.pullRequests else {
                self?.error = ApiServiceError.unknownError.error()
                self?.state = .finished
                return
            }

            self?.pullRequests.append(contentsOf: pullRequests.items)

            if pullRequests.isLastPage {
                self?.state = .finished
                return
            }

            guard let nextPageStart = pullRequests.nextPageStart else {
                self?.state = .finished
                return
            }

            self?.startPR = nextPageStart
            self?.addNextOperation()
        }
    }
}
