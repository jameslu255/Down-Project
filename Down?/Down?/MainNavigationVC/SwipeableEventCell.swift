//
//  EventCellCollectionViewCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/15/19.
//

import UIKit

protocol SwipeableEventCellDelegate {
    func swipeLeft(cell: EventCell)
    func swipeRight(cell: EventCell)
    func tapped(event: Event)
}

class SwipeableEventCell: EventCell {
    
    var delegate: SwipeableEventCellDelegate?
    
    var originalCenter = CGPoint()
    var notDownOnDragRelease = false
    var downOnDragRelease = false
    var cueMaragin: CGFloat = 10.0
    var cueWidth: CGFloat = 50.0
    
    override func commonInit() {
        super.commonInit()
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
            rightSwipeCueLabel.alpha = cueAlpha
            rightSwipeCueBackground.alpha = cueAlpha
            leftSwipeCueLabel.alpha = cueAlpha
            leftSwipeCueBackground.alpha = cueAlpha
            
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
                    delegate.swipeLeft(cell: self)
                }
            }
            if downOnDragRelease {
                if let delegate = self.delegate {
                    delegate.swipeRight(cell: self)
                }
            }
            UIView.animate(withDuration: 0.2){
                self.rightSwipeCueLabel.alpha = 0
                self.rightSwipeCueBackground.alpha = 0
                self.leftSwipeCueLabel.alpha = 0
                self.leftSwipeCueBackground.alpha = 0
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
    
    let rightSwipeCueBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let leftSwipeCueBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let rightSwipeCueLabel: UILabel = {
        let label = UILabel()
        label.text = "No text"
        label.textColor = .white
        label.font = UIFont(name: "Noteworthy", size: 30)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let leftSwipeCueLabel: UILabel = {
        let label = UILabel()
        label.text = "No text"
        label.textColor = .white
        label.font = UIFont(name: "Noteworthy", size: 30)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
