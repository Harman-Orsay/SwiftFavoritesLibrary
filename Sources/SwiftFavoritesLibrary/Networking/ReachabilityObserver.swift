//
//  ReachabilityObserver.swift
//  
//
//  Created by Rohan Ramsay on 29/12/20.
//

import Foundation
import Network

public class ReachabilityObserver: Observer {
    
    public enum State {
        case reachable(isCellular: Bool)
        case notReachable
        
        init(path: NWPath) {
            switch path.status {
            case .satisfied: self = .reachable(isCellular: path.isExpensive)
            case .unsatisfied, .requiresConnection: self = .notReachable
            }
        }
    }
    
    private let monitor: NWPathMonitor
    private let monitorQueue: DispatchQueue
    
    private var isObserving = false {
        didSet {
            if isObserving {monitor.start(queue: monitorQueue)}
            else {monitor.cancel()}
        }
    }
    
    public weak var eventReposponder: EventResponder? {
        willSet {
            if newValue == nil {
                stopObserving()
            }
        }
    }
    
    public init() {
        monitor = NWPathMonitor()
        monitorQueue = DispatchQueue(label: "ReachabilityObserver.monitor")
        monitor.pathUpdateHandler = { [weak self] path in
            self?.processUpdate(path: path)
        }
    }
    
    private func processUpdate(path: NWPath) {
        guard let responder = eventReposponder else {return}
        DispatchQueue.main.async {
            responder.reachabilityStateChanged(to: State(path: path))
        }
    }
}

extension ReachabilityObserver {
    func startObserving() {
        guard !isObserving else {return}
        isObserving = true
    }
    
    func stopObserving() {
        guard isObserving else {return}
        isObserving = false
    }
}

public protocol EventResponder: class {
    func reachabilityStateChanged(to newState: ReachabilityObserver.State)
}

protocol Observer {
    func startObserving()
    func stopObserving()
}

//TODO :- an observer that can recieve multiple responders
//problem - only sending event to the ones who have fired startObserving - register vs startObserving

protocol SharedObserver: Observer {
    associatedtype Responder where Responder: AnyObject
    
    func register(responder: Responder)
    func unregister(responder: Responder)
}
