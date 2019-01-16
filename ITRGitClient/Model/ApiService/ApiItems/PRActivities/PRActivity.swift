//
//  PRActivitiesValue.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct PRActivity: Codable {

    enum Action: String {
        case commented = "COMMENTED"

        var name: String {
            return rawValue
        }
    }

    let identifier: Int
    let user: ApiUser
    let action: String?
    let commentAction: String?
    let comment: PRComment?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case user
        case action
        case commentAction
        case comment
    }

    var isComment: Bool {
        return action == Action.commented.name
    }
}
