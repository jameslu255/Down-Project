//
//  DownEventCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/25/19.
//

import Foundation
import UIKit

class DownEventCell: SwipeableEventCell {
    override func commonInit() {
        super.commonInit()
        leftSwipeCueLabel.text = "Nevermind."
        leftSwipeCueBackground.backgroundColor = .systemGray
        rightSwipeCueLabel.text = "Not Down."
        rightSwipeCueBackground.backgroundColor = .systemRed
    }
}

class NotDownEventCell: SwipeableEventCell {
    override func commonInit() {
        super.commonInit()
        leftSwipeCueLabel.text = "Nevermind."
        leftSwipeCueBackground.backgroundColor = .systemGray
        rightSwipeCueLabel.text = "Down."
        rightSwipeCueBackground.backgroundColor = .systemGreen
    }
}
