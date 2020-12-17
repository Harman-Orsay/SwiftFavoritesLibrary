//
//  Endpoint.swift
//
//  Created by Rohan Ramsay on 10/12/20.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [ParameterType] { get }
    var headers: HTTPHeaders { get }
    var httpMethod: HTTPMethod { get }
    var timeout: TimeInterval { get }
}

typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

//Parameter & payload
enum ParameterType {
    case url(name: String, value: String)
    case json(value: Data?) //rename to body?
}

extension ParameterType: Equatable {
    static func == (lhs: ParameterType, rhs: ParameterType) -> Bool {
        switch (lhs, rhs) {
        case (.url, .url): return true
        case (.json, .json): return true
        default: return false
        }
    }
}

extension Endpoint {
    
    var timeout: TimeInterval { 10.0 }
    
    func getUrlRequest() throws -> URLRequest?  {
        guard var url = URL(string: baseUrl + path), var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { throw URLError(.badURL) }
        
        urlComponents.queryItems = [URLQueryItem]()
        var jsonParam: Data?
        
        for param in parameters {
            if case let .url(name, value) = param {
                let queryItem = URLQueryItem(name: name,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            
            if case let .json(jsonData) = param {
                if jsonData == nil { throw URLError(.badURL) }
                jsonParam = jsonData
            }
        }
        if let urlWithUrlParams = urlComponents.url {
            url = urlWithUrlParams
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = httpMethod.rawValue
        req.timeoutInterval = timeout
        for (key, value) in headers {
            req.setValue(value, forHTTPHeaderField: key)
        }
        if let json = jsonParam {
            req.httpBody = json
        }
        return req
    }
        
    var urlRequest: URLRequest? {
        try? getUrlRequest()
    }
}
