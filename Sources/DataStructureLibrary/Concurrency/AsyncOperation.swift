//
//  AsyncOperation.swift
//  Tech Demonstrator
//
//  Created by Rohan Ramsay on 8/02/19.
//  Copyright © 2019 Rohan Ramsay. All rights reserved.
//

import Foundation

open class AsyncOperation: Operation {

    public enum State {
        case asyncReady, asyncExecuting, asyncFinished
        
        fileprivate var keyPath: String { //simulate system(OperationQueue) kvo on Operation
            switch self {
            case .asyncReady: return "isReady"
            case .asyncExecuting: return "isExecuting"
            case .asyncFinished: return "isFinished"
            }
        }
    }
    
    public var state: State = .asyncReady {
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
        return super.isReady && state == .asyncReady
    }
    
    override open var isExecuting: Bool {
        return state == .asyncExecuting
    }
    
    override open var isFinished: Bool {
        return state == .asyncFinished
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open func start() {
        if isCancelled {
            state = .asyncFinished
            return
        }
        
        main()// subclass will have an async task in main
        state = .asyncExecuting
    }
    
    override open func cancel() {
        super.cancel()
        state = .asyncFinished
    }
}

//MARK: - Usage

class AnAsyncOperation: AsyncOperation {
    var result: Result<Any, Error>? //replace with specifics

    override func main() {
//        some async task { [unowned self] in
//            populate self.result

            self.state = .asyncFinished
//        }
    }
}
