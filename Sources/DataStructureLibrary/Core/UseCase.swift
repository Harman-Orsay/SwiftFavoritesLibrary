//
//  File.swift
//  
//
//  Created by Rohan Ramsay on 24/12/20.
//

import Foundation
import Combine

protocol UseCase {
    associatedtype Failure: Error
    associatedtype Output
    
    func execute(onStart: (() -> Void)?) -> AnyPublisher<Output, Failure>
}

typealias CancellableUseCase = UseCase & Cancellable

class DemoCancellableUseCase: CancellableUseCase {
    
    typealias Failure = NSError
    typealias Output = Void
    
    private var cancelled = false
    
    func cancel() {
        cancelled = true
    }
    
    func execute(onStart: (() -> Void)?) -> AnyPublisher<Void, Failure> {
        guard !cancelled else {
            return  Future { promise in
                promise(Result.failure(NSError()))
            }.eraseToAnyPublisher()
        }
        
        return Deferred {
            
            Future { promise in
                
                onStart?()
                
                promise(Result.success(()))
                
                promise(Result.failure(NSError()))
            }
        }.eraseToAnyPublisher()
    }
}
