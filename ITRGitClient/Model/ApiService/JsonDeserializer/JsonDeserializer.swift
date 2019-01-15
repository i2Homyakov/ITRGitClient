//
//  JsonDeserializer.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

protocol JsonDeserializer {

    func parse <T: Codable>(data: Data) throws -> T?
    func parseArray <T: Codable>(data: Data) throws -> [T]

}

class DefaultJsonDeserializer: JsonDeserializer {

    func parse <T: Codable>(data: Data)throws -> T? {
        let item: T? = try JSONDecoder().decode(T.self, from: data)
        return item
    }

    func parseArray <T: Codable>(data: Data) throws -> [T] {
        return try JSONDecoder().decode([T].self, from: data)
    }
}
