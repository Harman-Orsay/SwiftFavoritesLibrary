//
//  LoadingIndicatorTableHeaderFooterView.swift
//  CodeChallenge1
//
//  Created by Rohan Ramsay on 21/10/20.
//  Copyright © 2020 Harman Orsay. All rights reserved.
//

import UIKit

class LoadingIndicatorTableHeaderFooterView: UITableViewHeaderFooterView {
    
    enum State {
        case loading
        case completed(message: String?)
    }
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    var state: State = .completed(message: nil) {
        didSet {
            self.alterUIBasedOn(state: state)
        }
    }
    
    var section: Int = -1
    
    func alterUIBasedOn(state: State) {
        switch state {
        case .loading:
            indicatorView.isAnimating ? () : self.indicatorView.startAnimating()
            mainLabel.isHidden = true
        case .completed(let message):
            self.indicatorView.isAnimating ? self.indicatorView.stopAnimating() : ()
            mainLabel.isHidden = false
            mainLabel.text = message
        }
    }
    
    //MARK: - Load from NIB
    var view: UIView!
    
    convenience init() {
        self.init(reuseIdentifier: nil)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.width, height: self.view.intrinsicContentSize.height)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LoadingIndicatorTableHeaderFooterView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        contentView.addSubview(view)
        indicatorView.hidesWhenStopped = true
        alterUIBasedOn(state: state)
    }
}
