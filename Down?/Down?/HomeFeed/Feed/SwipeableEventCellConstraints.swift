//
//  EventCellConstraints.swift
//  Down?
//
//  Created by Caleb Bolton on 11/17/19.
//

import Foundation
import UIKit

extension SwipeableEventCell {
    func setSubviewsConstraints(){
        self.contentView.addSubview(rightSwipeCueBackground)
        self.contentView.addSubview(rightSwipeCueLabel)
        self.contentView.addSubview(leftSwipeCueBackground)
        self.contentView.addSubview(leftSwipeCueLabel)

        rightSwipeCueLabel.rightAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: -16).isActive = true
        rightSwipeCueLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        
        leftSwipeCueLabel.leftAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 16).isActive = true
        leftSwipeCueLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        
        rightSwipeCueBackground.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: 25).isActive = true
        rightSwipeCueBackground.rightAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        rightSwipeCueBackground.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        rightSwipeCueBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        rightSwipeCueBackground.bottomAnchor.constraint(equalTo: CellSpacer.topAnchor, constant: 0).isActive = true
        
        leftSwipeCueBackground.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: 25).isActive = true
        leftSwipeCueBackground.leftAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        leftSwipeCueBackground.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        leftSwipeCueBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        leftSwipeCueBackground.bottomAnchor.constraint(equalTo: CellSpacer.topAnchor, constant: 0).isActive = true
    }
}
