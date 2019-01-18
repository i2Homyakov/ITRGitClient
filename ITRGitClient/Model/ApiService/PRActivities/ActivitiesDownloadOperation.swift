//
//  ActivitiesDownloadOperation.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class ActivitiesDownloadOperation: GroupOperation {

    private let activitiesQueue = DispatchQueue(label: "activities")

    private(set) var activities: [PRActivity]
    private(set) var error: Error?

    init(password: String, prIDs: [Int]) {
        activities = []
        super.init()
        self.operations = makeOperations(password: password, prIDs: prIDs)
    }

    private func makeOperations(password: String, prIDs: [Int]) -> [PRActivitiesDownloadOperation] {
        return prIDs.map { makeOperationFor(password: password, prID: $0) }
    }

    private func makeOperationFor(password: String, prID: Int) -> PRActivitiesDownloadOperation {
        let operation = PRActivitiesDownloadOperation(password: password, prID: prID)
        operation.completionBlock = makeCompletionBlockForOperation(operation)

        return operation
    }

    private func makeCompletionBlockForOperation(_ operation: PRActivitiesDownloadOperation) -> () -> Void {
        return { [weak self] in
            if let error = operation.error {
                self?.error = error
                self?.cancel()
                return
            }

            self?.addActivities(operation.activities)
        }
    }

    private func addActivities(_ activities: [PRActivity]) {
        activitiesQueue.sync { [weak self] in
            self?.activities.append(contentsOf: activities)
        }
    }
}
