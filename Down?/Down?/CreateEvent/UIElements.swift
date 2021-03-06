//
//  UIElements.swift
//  Down?
//
//  Custom configs for UI elements
//
//  Created by Maxim Chiao on 11/11/19.
//

import UIKit
import MapKit

// Adds a place holder for UITextView that matches that of UITextField
extension UITextView: UITextViewDelegate {
  func addPlaceHolder() {
    self.textColor = .lightGray
    self.text = "Add description"
  }
}

class CategoryCell: UICollectionViewCell {
  var label: UILabel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  private func setup() {
    // Sets up style preferences of category pills in create event screen
    self.layer.cornerRadius = 12
    self.layer.borderColor = UIColor.lightGray.cgColor
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 0.9))
    label.textColor = .white
    label.textAlignment = .center
    label.tag = 1337
    label.font = UIFont(name: "Hiragino Sans", size: 16)
    self.addSubview(label)
  }
  
  func setLabel(width: CGFloat, height: CGFloat, text: String) {
    if let label = self.viewWithTag(1337) as? UILabel {
      label.text = text
    }
  }
  
  func toggleBorder(isSelected: Bool) {
    if (isSelected) {
      self.layer.borderWidth = 3
    }
    else {
      self.layer.borderWidth = 0
    }
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

// Custom annotation for pins on Search Location map
class LocationPin: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  
  init(title: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate
    super.init()
  }
}
