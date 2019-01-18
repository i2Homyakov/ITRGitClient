//
//  GroupOperation.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 16/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class GroupOperation: AsyncOperation {

    private let queue = OperationQueue()

    var operations: [Operation] = []

    override func main() {
        if isCancelled {
            return
        }

        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.queue.addOperations(strongSelf.operations, waitUntilFinished: true)
            strongSelf.state = .finished
        }
    }

    override func cancel() {
        queue.cancelAllOperations()
        super.cancel()
    }
}
