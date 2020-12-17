//
//  File.swift
//  
//
//  Created by Rohan Ramsay on 15/12/20.
//

import Foundation
import Combine

struct API {
    
    enum Error: LocalizedError {
        
    }
    
    enum Endpoint {
        
    }
    
    private let decoder: JSONDecoder
    private let worker: DispatchQueue // or custom thread or operation queue (Combine.Scheduler)
    
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
