//
//  CommentsFormatter.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class CommentsFormatter {

    static private let commentSeparator = "\n\n"
    static private let format = "//** %d%@%@%@ **//\n{\n%@\n}"
    static private let investmentLevelFormat = " ** level: %@"
    static private let investmentLevelRoot = "root"
    static private let rootLevel = 0
    static private let parentIdFormat = " ** parent: %d"
    static private let authorFormat = " ** author: %@"

    static func textForComments(_ comments: [LogComment]) -> String {
        let lines = comments.map { lineForComment($0) }
        return lines.joined(separator: commentSeparator)
    }

    static private func lineForComment(_ comment: LogComment) -> String {
        return String(format: format,
                      comment.identifier,
                      labelForAuthor(comment.author.displayName),
                      labelForInvestmentLevel(comment.nestingLevel),
                      labelForParentId(comment.parentId),
                      comment.text)
    }

    static private func labelForInvestmentLevel(_ level: Int) -> String {
        return String(format: investmentLevelFormat, level == 0 ? investmentLevelRoot : String(level))
    }

    static private func labelForParentId(_ parentId: Int?) -> String {
        guard let parentId = parentId else {
            return .empty
        }
        return String(format: parentIdFormat, parentId)
    }

    static private func labelForAuthor(_ author: String) -> String {
        if AppInputData.author.isEmpty {
            return .empty
        }
        return String(format: authorFormat, author)
    }
}
