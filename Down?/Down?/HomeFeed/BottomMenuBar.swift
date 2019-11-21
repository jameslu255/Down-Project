//
//  BottomMenuBar.swift
//  Down?
//
//  Created by Caleb Bolton on 11/12/19.
//

import UIKit

class BottomMenuBar: UIView {
    
    override func didMoveToWindow() {
        let borderShadowColor = UIColor.label.cgColor
        
        self.layer.borderWidth = 1
        self.layer.borderColor = borderShadowColor
        self.backgroundColor = UIColor.systemBackground
        self.layer.cornerRadius = 10
        self.layer.shadowColor = borderShadowColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
    }    
}
