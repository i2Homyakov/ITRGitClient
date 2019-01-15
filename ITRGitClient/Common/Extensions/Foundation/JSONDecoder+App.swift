//
//  JSONDecoder+App.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

extension JSONDecoder {

    func decodeWith <T: Codable>(data: Data)throws -> T? {
        let item: T? = try decode(T.self, from: data)
        return item
    }

    func parseArrayWith <T: Codable>(data: Data) throws -> [T] {
        return try decode([T].self, from: data)
    }
}
