//
//  LogsManager.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class LogsManager {

    static private let fileExtension = ".txt"
    static private let timeFormat = "HH-mm-ss dd.MM.yyyy"

    static func saveText(_ text: String,
                         withFileName fileName: String = Date().toStringWithFormat(timeFormat)) -> Bool {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        let path = documentsUrl.appendingPathComponent(fileName + fileExtension).path
        let contents = text.data(using: .utf8)
        return FileManager.default.createFile(atPath: path, contents: contents)
    }
}
