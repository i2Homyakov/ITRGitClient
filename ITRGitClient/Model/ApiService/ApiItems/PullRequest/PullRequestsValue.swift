//
//  PullRequestsValue.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PullRequestsValue: Codable {

    let identifier: Int
    let createdDate: Int64

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case createdDate
    }

    func getCreatedDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval.intervalFromMilliseconds(createdDate))
    }
}
