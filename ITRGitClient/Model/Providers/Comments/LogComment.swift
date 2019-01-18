//
//  LogComment.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 17/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct LogComment {

    static private let rootLevel = 0

    let identifier: Int
    let author: ApiUser
    let text: String
    let nestingLevel: Int
    let parentId: Int?

    init(prComment: PRComment, parentId: Int?, nestingLevel: Int) {
        identifier = prComment.identifier
        author = prComment.author
        text = prComment.text
        self.nestingLevel = nestingLevel
        self.parentId = parentId
    }

    static func commentsFromPRComment(_ prComment: PRComment,
                                      parentId: Int? = nil,
                                      nestingLevel: Int = rootLevel) -> [LogComment] {
        let rootComment = LogComment(prComment: prComment,
                                     parentId: parentId,
                                     nestingLevel: nestingLevel)
        if prComment.comments.isEmpty {
            return [rootComment]
        }

        let subComments = prComment.comments.map {
            commentsFromPRComment(
                $0, parentId: prComment.identifier, nestingLevel: nestingLevel + 1)
        }

        return [rootComment] + subComments.reduce([], +)
    }
}
