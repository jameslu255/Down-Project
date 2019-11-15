//
//  UIStyling.swift
//  Down?
//
//  Custom styling for UI elements
//
//  Created by Maxim Chiao on 11/11/19.
//

import UIKit

class DescriptionBox: UITextView {
  func setup() {
    // Styles UITextView to look like UITextField
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.systemGray4.cgColor
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
}

class RoundButton: UIButton {
  func setup() {
    let height = self.frame.size.height
    self.layer.cornerRadius = height / 2
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
}

