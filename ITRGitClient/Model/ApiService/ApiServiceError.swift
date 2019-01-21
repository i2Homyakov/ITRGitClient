//
//  ApiServiceError.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

enum ApiServiceError: Int {
    case not200
    case incorrectData
    case incorrectUrl
    case operationCanceled
    case unknownError

    func errorCode() -> Int {
        return self.rawValue
    }

    func errorMessage() -> String {

        switch self {
        case .not200:
            return NSLocalizedString("MessageFailToConnect", comment: .empty)
        case .incorrectData:
            return NSLocalizedString("IncorrectServerData", comment: .empty)
        case .operationCanceled:
            return NSLocalizedString("OperationCanceled", comment: .empty)
        default:
            return NSLocalizedString("UnknownError", comment: .empty)
        }
    }

    func error() -> Error {
        return NSError(domain: "ApiServiceError",
                            code: self.errorCode(),
                            userInfo: [NSLocalizedDescriptionKey: self.errorMessage()])
    }
}
