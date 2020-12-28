//
//  File.swift
//  
//
//  Created by Rohan Ramsay on 28/12/20.
//

import Foundation

class AppDependencyContainer {
    
    let scene1DI = Scene1DepenedencyContainer()
}

class Scene1DepenedencyContainer {
    let dataFactory: DataFactory1!
}

extension Scene1DepenedencyContainer: Scene1ViewFactory {
    
}

protocol Scene1ViewFactory {
//    func makeVC1() -> VC1
}

protocol DataFactory1 {
//    func makeRepo() -> Repo1
}
