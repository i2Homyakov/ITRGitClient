//
//  PRCommentsProvider.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

protocol PRCommentsProvider {

    typealias CompletionAlias = ([LogComment], Error?) -> Void

    func getFilteredCommentsFor(password: String,
                                prIDs: [Int],
                                onCompletion: @escaping CompletionAlias)
}

struct CommentsFilterData {

    var reviewer = AppInputData.reviewer
}

class DefaultPRCommentsProvider: PRCommentsProvider {

    let filterData = CommentsFilterData()

    func getFilteredCommentsFor(password: String,
                                prIDs: [Int],
                                onCompletion: @escaping CompletionAlias) {
        let operation = ActivitiesDownloadOperation(password: password, prIDs: prIDs)
        operation.completionBlock = completionBlockForOperation(operation, onCompletion: onCompletion)
        operation.start()
    }

    private func completionBlockForOperation(_ operation: ActivitiesDownloadOperation,
                                             onCompletion: @escaping CompletionAlias) -> () -> Void {
        return { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let prComments = operation.activities.compactMap { $0.isComment ? $0.comment : nil }
            let comments = prComments.map { LogComment.commentsFromPRComment($0) }.reduce([], +)
            let filteredComments = comments.filter { strongSelf.filterData.reviewer == $0.author.slug }
            onCompletion(filteredComments, operation.error)
        }
    }
}
