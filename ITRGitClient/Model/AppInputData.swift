//
//  AppInputData.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 15/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class AppInputData {

    static private let dateFormat = "dd.MM.yyyy"

    static let project = "discountapp"
    static let repository  = "discountapp-ios"
    static let author = "i2.homyakov"
    //    static let reviewer = "a.sleptsov"
    static let reviewer = "n.pivulski"
    static let startDate = Date.dateFromString("13.08.2018", format: dateFormat) ?? Date()
    static let endDate = Date.dateFromString("14.01.2019", format: dateFormat) ?? Date()
}
