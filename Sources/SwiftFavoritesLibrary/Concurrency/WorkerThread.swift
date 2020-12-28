//
//  DedicatedThread.swift
//  CodeChallenge1BL
//
//  Created by Rohan Ramsay on 8/12/20.
//

import Foundation

@objc class WorkerThread: NSObject {
    private var thread: Thread!
    private var blockQueue = [() -> Void]()
    private let queueCondition = NSCondition()
    
    init(threadName: String) {
        super.init()
        thread = Thread(target: self,
                        selector: #selector(threadWorker),
                        object: nil)
        thread.name = threadName
        thread.start()
    }
    
    @objc private func threadWorker() {
        defer { Thread.exit(); thread = nil }

        while true {
            queueCondition.lock()
        
            while blockQueue.isEmpty && thread != nil && !thread.isCancelled {
                queueCondition.wait()
            }
            
            if thread == nil || thread.isCancelled {
                queueCondition.unlock()
                return
            }
            
            let block = self.blockQueue.remove(at: 0)
            queueCondition.unlock()
            block()
        }
    }
    
    @objc func enqueue(block: @escaping(()->Void)) {
        if !canWork {
            restart()
        }
        queueCondition.lock()
        blockQueue.append(block)
        queueCondition.signal()
        queueCondition.unlock()
    }
    
    var canWork: Bool {
        return thread != nil && !thread.isCancelled
    }
    
    private func restart() {
        guard !canWork else {return}
        thread = Thread(target: self,
                               selector: #selector(threadWorker),
                               object: nil)
        thread.start()
    }

    func invalidate() {
        guard canWork else {return}
        queueCondition.lock()
        thread?.cancel()
        queueCondition.signal()
        queueCondition.unlock()
    }
}

//Usage - worker.enqueue { work }
