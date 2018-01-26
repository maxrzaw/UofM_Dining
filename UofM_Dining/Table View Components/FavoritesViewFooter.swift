//
//  FavoritesViewFooter.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 12/9/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

class FavoritesViewFooter: UIView {
    private var isLoaded = false
    
    let label: UILabel = UILabel()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor.white
        self.alpha = 0.0
        
        // Configure label
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.alpha = 0.0
        self.addSubview(label)
    }
    
    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }
    
    //MARK: - Animation
    
    fileprivate func hideFooter() {
        self.alpha = 0.0
        label.alpha = 0.0
    }
    
    fileprivate func showFooter() {
        self.alpha = 1.0
        label.alpha = 1.0
    }
}

extension FavoritesViewFooter {
    //MARK: - Public API
    
    public func hide() {
        hideFooter()
    }
    
    public func displayNoMeal() {
        label.text = "No favorite menu items"
        showFooter()
    }
    
    
}
