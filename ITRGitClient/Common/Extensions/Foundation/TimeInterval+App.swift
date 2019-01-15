//
//  TimeInterval+App.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

extension TimeInterval {

    static let millisecondsInSecond: Int64 = 1000

    static func intervalFromMilliseconds(_ milliseconds: Int64) -> TimeInterval {
        return TimeInterval(milliseconds / millisecondsInSecond)
    }
}
