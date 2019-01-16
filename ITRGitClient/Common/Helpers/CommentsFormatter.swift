//
//  CommentsFormatter.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class CommentsFormatter {

    static private let format = "//** %d **//\n%@"

    static func stringForComments(_ comments: [PRComment]) -> String {
        let lines = comments.map { String(format: format, $0.identifier, $0.text) }
        return lines.joined(separator: "\n\n")
    }
}
