//
//  PRsProvider.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

protocol PRsProvider {

    typealias CompletionAlias = ([PullRequest], Error?) -> Void

    func getFilteredPRsFor(password: String,
                           onCompletion: @escaping CompletionAlias)
}

struct PRsFilterData {

    var startDate = AppInputData.startDate
    var endDate = AppInputData.endDate
}

class DefaultPRsProvider: PRsProvider {

    let filterData = PRsFilterData()

    func getFilteredPRsFor(password: String,
                           onCompletion: @escaping CompletionAlias) {
        let operation = PRsDownloadOperation(password: password)
        operation.completionBlock = completionBlockForOperation(operation, onCompletion: onCompletion)
        operation.start()
    }

    private func completionBlockForOperation(_ operation: PRsDownloadOperation,
                                             onCompletion: @escaping CompletionAlias) -> (() -> Void) {
        return { [weak self] in
            guard let filterData = self?.filterData else {
                return
            }
            let pullRequests = operation.pullRequests.filter {
                let createdDate = $0.getCreationDate()
                return filterData.startDate <= createdDate && createdDate <= filterData.endDate
            }
            onCompletion(pullRequests, operation.error)
        }
    }
}
