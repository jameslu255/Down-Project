//
//  FeedEventCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/25/19.
//

import Foundation
import UIKit

class FeedEventCell: SwipeableEventCell {
    override func commonInit() {
        super.commonInit()
        leftSwipeCueLabel.text = "Not Down."
        leftSwipeCueBackground.backgroundColor = .red
        rightSwipeCueLabel.text = "Down."
        rightSwipeCueBackground.backgroundColor = .green
    }
}
