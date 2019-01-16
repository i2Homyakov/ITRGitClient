//
//  PullRequests.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PullRequests: Codable {

    var values: [PullRequestsValue]
    var isLastPage: Bool
    var nextPageStart: Int?

    enum CodingKeys: String, CodingKey {
        case values
        case isLastPage
        case nextPageStart
    }
}
