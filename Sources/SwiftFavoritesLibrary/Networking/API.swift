//
//  File.swift
//  
//
//  Created by Rohan Ramsay on 15/12/20.
//

import Foundation
import Combine

struct API {
    
    enum Error: LocalizedError { //if API is not a protocol, else make error a namespace outside (enum for each type of error)
        
    }
    
    enum Endpoint {
        
    }
    
    private let decoder: JSONDecoder
    private let worker: DispatchQueue // or custom thread or operation queue (Combine.Scheduler)
    private let router: Router // for unit test mocking
}

extension API.Endpoint: Endpoint {
    var baseUrl: String {
        ""
    }
    
    var path: String {
        ""
    }
    
    var parameters: [ParameterType] {
        []
    }
    
    var headers: HTTPHeaders {
        [:]
    }
    
    var httpMethod: HTTPMethod {
        .get
    }    
}
