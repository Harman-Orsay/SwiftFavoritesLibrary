//
//  File.swift
//  
//
//  Created by Rohan Ramsay on 16/12/20.
//

import Foundation

enum Result<Output, Failure> where Failure: Error {
    case success(Output)
    case failure(Failure)
}
