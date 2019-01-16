//
//  MainProvider.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

protocol MainProvider {

    typealias CompletionAlias = ([PRComment], Error?) -> Void

    func getFilteredCommentsFor(password: String,
                                onCompletion: @escaping CompletionAlias)
}

class DefaultMainProvider: MainProvider {

    let prsProvider: PRsProvider = DefaultPRsProvider()
    let commentsProvider: PRCommentsProvider = DefaultPRCommentsProvider()

    func getFilteredCommentsFor(password: String,
                                onCompletion: @escaping CompletionAlias) {
        prsProvider.getFilteredPRsFor(password: password) { [weak self] (pullRequests, error) in
            if let error = error {
                onCompletion([], error)
                return
            }

            let prIDs = pullRequests.map { $0.identifier }
            self?.commentsProvider.getFilteredCommentsFor(password: password, prIDs: prIDs, onCompletion: onCompletion)
        }
    }
}
