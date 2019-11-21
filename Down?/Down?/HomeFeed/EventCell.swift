//
//  EventCellCollectionViewCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/15/19.
//

import UIKit

protocol EventCellDelegate {
    func notDown(event: Event)
    func down(event: Event)
    func tapped(event: Event)
}

class EventCell: UITableViewCell {

    var delegate: EventCellDelegate?
    var event: Event?
        
    var originalCenter = CGPoint()
    var notDownOnDragRelease = false
    var downOnDragRelease = false
    var cueMaragin: CGFloat = 10.0
    var cueWidth: CGFloat = 50.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.cornerRadius = 10
        self.selectionStyle = .none
        setSubviewsConstraints()
        setupGestureRecognizers()
    }

    func setupGestureRecognizers(){
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .began {
            originalCenter = center
        }
        
        if recognizer.state == .changed{
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            notDownOnDragRelease = frame.origin.x < -frame.size.width / 3.0
            downOnDragRelease = frame.origin.x > frame.size.width / 3.0
            
            let cueAlpha = abs(frame.origin.x) / (frame.size.width / 2.0)
            downCueLabel.alpha = cueAlpha
            downCueBackground.alpha = cueAlpha
            notDownCueLabel.alpha = cueAlpha
            notDownCueBackground.alpha = cueAlpha
            
        }
        
        if recognizer.state == .ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            if !notDownOnDragRelease, !downOnDragRelease {
                UIView.animate(withDuration: 0.2) {
                    self.frame = originalFrame
                }
            }
            if notDownOnDragRelease {
                if let delegate = self.delegate, let event = self.event {
                    delegate.notDown(event: event)
                }
            }
            if downOnDragRelease {
                if let delegate = self.delegate, let event = self.event {
                    delegate.down(event: event)
                }
            }
            UIView.animate(withDuration: 0.2){
                self.downCueLabel.alpha = 0
                self.downCueBackground.alpha = 0
                self.notDownCueLabel.alpha = 0
                self.notDownCueBackground.alpha = 0
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        else if gestureRecognizer is UITapGestureRecognizer{
            if let event = self.event {
                self.delegate?.tapped(event: event)
            }
        }
        return false
    }
    
    let downCueBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGreen
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let notDownCueBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemRed
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let downCueLabel: UILabel = {
        let label = UILabel()
        label.text = "Down."
        label.textColor = .white
        label.font = UIFont(name: "Noteworthy", size: 30)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let notDownCueLabel: UILabel = {
        let label = UILabel()
        label.text = "Not Down."
        label.textColor = .white
        label.font = UIFont(name: "Noteworthy", size: 30)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userProfileImageView: UIImageView = {
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
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
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
        label.backgroundColor = .secondarySystemBackground
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
    
    let locationText: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.backgroundColor = .secondarySystemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
