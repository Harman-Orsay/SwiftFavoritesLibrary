//
//  String+Email.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 22/12/20.
//

import Foundation

//Apple doc. recommends regex to be cached 
let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,16}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

public extension String {
    var isEmail: Bool {
        __emailPredicate.evaluate(with: self)
    }
}
