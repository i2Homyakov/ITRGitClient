//
//  PRComment.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PRComment: Codable {

    let identifier: Int
    let author: ApiUser
    let text: String
    let comments: [PRComment]

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case author
        case text
        case comments
    }
}
