//
//  AppInputDataFormmatter.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class AppInputDataFormatter {

    static private let dateFormat = "dd-MM-yyyy"
    static private let allParameters = ["project": AppInputData.project,
                                        "repository": AppInputData.repository,
                                        "author": AppInputData.author,
                                        "reviewer": AppInputData.reviewer,
                                        "startDate": AppInputData.startDate.toStringWithFormat(dateFormat),
                                        "endDate": AppInputData.endDate.toStringWithFormat(dateFormat)]
    static private let orderedNames = ["project", "repository", "author", "reviewer", "startDate", "endDate"]

    static func getText () -> String {
        let lines = orderedNames.map { String(format: "%@: %@", $0, allParameters[$0] ?? .empty) }
        return lines.joined(separator: "\n")
    }
}
