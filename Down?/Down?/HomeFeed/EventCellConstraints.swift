//
//  EventCellConstraints.swift
//  Down?
//
//  Created by Caleb Bolton on 11/17/19.
//

import Foundation
import UIKit

extension EventCell {
    func setSubviewsConstraints(){
        self.contentView.addSubview(downCueBackground)
        self.contentView.addSubview(downCueLabel)
        self.contentView.addSubview(notDownCueBackground)
        self.contentView.addSubview(notDownCueLabel)

        downCueLabel.rightAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: -16).isActive = true
        downCueLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        
        notDownCueLabel.leftAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 16).isActive = true
        notDownCueLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        
        downCueBackground.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: 25).isActive = true
        downCueBackground.rightAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        downCueBackground.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        downCueBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        downCueBackground.bottomAnchor.constraint(equalTo: CellSpacer.topAnchor, constant: 0).isActive = true
        
        notDownCueBackground.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: 25).isActive = true
        notDownCueBackground.leftAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        notDownCueBackground.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        notDownCueBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        notDownCueBackground.bottomAnchor.constraint(equalTo: CellSpacer.topAnchor, constant: 0).isActive = true
    }
}
