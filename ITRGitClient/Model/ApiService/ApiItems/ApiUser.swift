//
//  ApiUser.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

struct ApiUser: Codable {

    let identifier: Int
    let name: String
    let slug: String
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case slug
        case displayName
    }
}
