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

struct PRFilterData {

    var startDate: Date = Date(timeIntervalSince1970: 1540512000)
    var endDate: Date = Date(timeIntervalSince1970: 1547510400)
}

class DefaultPRsProvider: PRsProvider {

    let filterData = PRFilterData()

    func getFilteredPRsFor(password: String,
                           onCompletion: @escaping CompletionAlias) {
        let operation = PRsDownloadOperation(password: password)
        operation.completionBlock = completionBlockForOperation(operation, onCompletion: onCompletion)
        operation.start()
    }

    private func completionBlockForOperation(_ operation: PRsDownloadOperation,
                                             onCompletion: @escaping CompletionAlias) -> (() -> Void) {
        return { [weak self] in
            let pullRequests = operation.pullRequests.filter {
                guard let filterData = self?.filterData else {
                    return false
                }
                let createdDate = $0.getCreationDate()
                return filterData.startDate <= createdDate && createdDate <= filterData.endDate
            }
            onCompletion(pullRequests, operation.error)
        }
    }
}
