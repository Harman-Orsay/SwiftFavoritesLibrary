//
//  UITextfield+Combine.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 22/12/20.
//

import UIKit
import Combine


public extension UITextField {
    var liveTextPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map{($0.object as? UITextField)?.text ?? ""}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
