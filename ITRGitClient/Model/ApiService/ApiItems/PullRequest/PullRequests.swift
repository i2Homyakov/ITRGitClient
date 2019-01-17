//
//  PullRequests.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PullRequests: Codable {

    var items: [PullRequest]
    var isLastPage: Bool
    var nextPageStart: Int?

    enum CodingKeys: String, CodingKey {
        case items = "values"
        case isLastPage
        case nextPageStart
    }
}
