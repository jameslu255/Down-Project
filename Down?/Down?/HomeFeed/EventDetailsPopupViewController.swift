//
//  EventDetailsPopupViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/18/19.
//

import UIKit

class EventDetailsPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let durationIconImage: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13)
        let image = UIImage(systemName: "clock", withConfiguration: imageConfig)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationIconImage: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13)
        let image = UIImage(systemName: "mappin.and.ellipse", withConfiguration: imageConfig)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let locationText: UITextView = {
        let textView = UITextView()
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 13)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .address
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT)))
        var newFrame: CGRect = textView.frame
        newFrame.size = CGSize(width: newFrame.width, height: newSize.height)
        textView.frame = newFrame
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let descriptionText: UITextView = {
        let text = UITextView()
        text.text = "asdf"
        text.backgroundColor = .tertiarySystemBackground
        text.textColor = .tertiaryLabel
        text.layer.cornerRadius = 5
        text.isEditable = false
        text.isSelectable = false
        text.isScrollEnabled = false
        let newSize = text.sizeThatFits(CGSize(width: text.frame.width, height: CGFloat(MAXFLOAT)))
        var newFrame: CGRect = text.frame
        newFrame.size = CGSize(width: newFrame.width, height: newSize.height)
        text.frame = newFrame
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let downButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 500, height: 75))
        let color = UIColor.secondaryLabel
        button.setTitle("Down?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(UIColor.tertiaryLabel, for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}


extension EventDetailsPopupViewController {
    
    private func setupSubviewsConstraints(){
        
    }
    
}
