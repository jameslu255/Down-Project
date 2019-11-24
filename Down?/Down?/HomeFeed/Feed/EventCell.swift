//
//  EventCellCollectionViewCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/15/19.
//

import UIKit

protocol EventCellDelegate {
    func notDown(cell: EventCell)
    func down(cell: EventCell)
    func tapped(event: Event)
}

class EventCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var durationLabelBackgroundView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var CellSpacer: UIView!
    
    
    var delegate: EventCellDelegate?
    var event: Event?
        
    var cellId: Int = 0
    var originalCenter = CGPoint()
    var notDownOnDragRelease = false
    var downOnDragRelease = false
    var cueMaragin: CGFloat = 10.0
    var cueWidth: CGFloat = 50.0

    override func awakeFromNib() {
        self.backgroundColor = .systemBackground
        self.selectionStyle = .none
        
        setupSubviews()
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
        if let event = self.event {
            self.delegate?.tapped(event: event)
        }
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
                if let delegate = self.delegate {
                    delegate.notDown(cell: self)
                }
            }
            if downOnDragRelease {
                if let delegate = self.delegate {
                    delegate.down(cell: self)
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
            return true
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
    
    func setupSubviews(){
        profilePictureImageView.layer.cornerRadius = 5
        durationLabelBackgroundView.layer.cornerRadius = 5
        locationTextView.layer.cornerRadius = 5
    }
}
