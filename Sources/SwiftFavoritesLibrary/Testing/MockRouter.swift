//
//  MockRouter.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 25/12/20.
//

import Combine

//FOR QUICK N DIRTY in unit testing :- e.g. multiple calls within same tests, different error types etc.

class MockRouter: Router {
    
    var nextResponseOutput: (data: Data, response: URLResponse)?
    var nextResponseError: URLError?
    
    func tearDown() {
        nextResponseOutput = nil
        nextResponseError = nil
    }
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        Future { promise in
            
            assert(self.nextResponseOutput != nil || self.nextResponseError != nil,
                   "MOCK RESPONSE not supplied to MOCK ROUTER")
            
            assert(self.nextResponseOutput == nil || self.nextResponseError == nil,
                   "INCORRECT RESPONSE supplied to MOCK ROUTER - output & error supplied")
            
            
            if let output = self.nextResponseOutput {
                promise(Result.success(output))
                return
            }
            
            if let error = self.nextResponseError {
                promise(Result.failure(error))
                return
            }
            
        }.eraseToAnyPublisher()
    }
}
