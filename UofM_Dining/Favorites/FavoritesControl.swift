//
//  FavoritesControl.swift
//  UofM_Dining
//
//  Created by Maxwell Zawisa on 12/4/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import UIKit

@IBDesignable class FavoritesControl: UIView {
    let manager = FavoriteManager.shared
    
    var currentHearts = [UIButton]()
    
    
    // MARK: Properties
    private var isFavorite = false
    @IBInspectable var menuItemName = "" {
        didSet {
            getFavoriteStatus()
            setupButton()
        }
    }
    
    var heartSize: CGSize = CGSize(width: 36, height: 36)
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        getFavoriteStatus()
        setupButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupButton), name: .favoriteChanged, object: nil)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        getFavoriteStatus()
        setupButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupButton), name: .favoriteChanged, object: nil)
    }
    
    // MARK: Button Action
    @objc func heartButtonTapped(button: UIButton) {
        getFavoriteStatus()
        isFavorite = !isFavorite
        setFavoriteStatus()
        setupButton()
    }
    
    // MARK: Private Methods
     @objc private func setupButton() {
        getFavoriteStatus()
        // Removes any current buttons
        for button in currentHearts {
            button.removeFromSuperview()
        }
        currentHearts.removeAll()
        
        // Load images
        let bundle = Bundle(for: type(of: self))
        let filledHeart = UIImage(named: "filledHeartMaize", in: bundle, compatibleWith: self.traitCollection)
        let emptyHeart = UIImage(named: "emptyHeartMaize", in: bundle, compatibleWith: self.traitCollection)
        let highlightedHeart = UIImage(named: "filledHeartMaize", in: bundle, compatibleWith: self.traitCollection)
        
        
        // Create the heart
        let heart = UIButton()
        
        // Set images
        heart.setImage(emptyHeart, for: .normal)
        heart.setImage(filledHeart, for: .selected)
        heart.setImage(highlightedHeart, for: .highlighted)
        heart.setImage(highlightedHeart, for: [.highlighted, .selected])
        
        heart.isSelected = isFavorite
        
        // Add Constraints
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.heightAnchor.constraint(equalToConstant: heartSize.height).isActive = true
        heart.widthAnchor.constraint(equalToConstant: heartSize.width).isActive = true
        // Setup the button action
        heart.addTarget(self, action: #selector(FavoritesControl.heartButtonTapped(button:)), for: .touchUpInside)
        
        // Creates constraints to center the button in view
        let centerYConstraint = heart.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let centerXConstraint = heart.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let heartCons = [centerXConstraint, centerYConstraint]
        
        // Add the button to the view
        addSubview(heart)
        
        // Sets the center of the heart
        NSLayoutConstraint.activate(heartCons)
        
        currentHearts.append(heart)
    }
    
    private func getFavoriteStatus() {
        isFavorite = manager.favArray.contains(menuItemName)
    }
    
    private func setFavoriteStatus() {
        manager.toggleFavoriteStatus(itemName: menuItemName)
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
