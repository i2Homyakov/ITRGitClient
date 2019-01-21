//
//  PRActivities.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PRActivities: Codable {

    var values: [PRActivity]
    var isLastPage: Bool
    var nextPageStart: Int?

    enum CodingKeys: String, CodingKey {
        case values
        case isLastPage
        case nextPageStart
    }
}
