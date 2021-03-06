//
//  SearchNoResultsFooter.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/10/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

/*
-Inspired by: https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started

Permission & Copyright Notice below:
/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
*/


import UIKit

class SearchNoResultsFooter: UIView {

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
        alpha = 0.0
        
        // Configure label
        label.textAlignment = .center
        label.textColor = UIColor.black
        addSubview(label)
        label.alpha = 0.0
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
extension SearchNoResultsFooter {
    //MARK: - Public API
    
    public func hide() {
        hideFooter()
    }
    
    public func displayNoRecentSearches() {
        label.text = "No recent searches"
        showFooter()
    }
    
    public func displayNoSearchResults() {
        label.text = "No menu items for your search"
        showFooter()
    }
    
    
}
