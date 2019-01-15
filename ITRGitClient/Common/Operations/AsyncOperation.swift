//
//  AsyncOperation.swift
//  ITRStartTask
//
//  Created by Homyakov, Ilya2 on 23/08/2018.
//  Copyright © 2018 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    public enum State: String {
        case ready
        case executing
        case finished

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }

    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    override open var isReady: Bool {
        return super.isReady && state == .ready
    }

    override open var isExecuting: Bool {
        return state == .executing
    }

    override open var isFinished: Bool {
        return state == .finished
    }

    override open var isAsynchronous: Bool {
        return state == .finished
    }

    override func start() {
        if isCancelled {
            state = .finished
            return
        }

        main()
        state = .executing
    }

    override open func cancel() {
        super.cancel()
        state = .finished
    }
}
