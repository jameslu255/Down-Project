//
//  DownEventCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/25/19.
//

import Foundation
import UIKit

// Make SwipeableEventCell with swiping cues for down events
class DownEventCell: SwipeableEventCell {
    override func commonInit() {
        super.commonInit()
        leftSwipeCueLabel.text = "Nevermind."
        leftSwipeCueBackground.backgroundColor = .systemGray
        rightSwipeCueLabel.text = "Not Down."
        rightSwipeCueBackground.backgroundColor = .systemRed
    }
}

// Make SwipeableEventCell with swiping cues for notDown events
class NotDownEventCell: SwipeableEventCell {
    override func commonInit() {
        super.commonInit()
        leftSwipeCueLabel.text = "Nevermind."
        leftSwipeCueBackground.backgroundColor = .systemGray
        rightSwipeCueLabel.text = "Down."
        rightSwipeCueBackground.backgroundColor = .systemGreen
    }
}
