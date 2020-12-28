//
//  UIScrollView.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 18/12/20.
//

import UIKit

extension UIScrollView {
    
    func hasScrolledToBottom() -> Bool {
        bounds.size.height + contentOffset.y >= contentSize.height
    }
    
    func scrollToBottom(animated: Bool = true) {
        setContentOffset(CGPoint(x: 0, y: max(contentSize.height - bounds.size.height, 0)), animated: animated)
    }
}
