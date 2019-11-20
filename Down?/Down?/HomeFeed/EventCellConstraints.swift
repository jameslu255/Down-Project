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
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(eventTitleLabel)
        addSubview(durationIconImage)
        addSubview(durationLabel)
        addSubview(locationIconImage)
        addSubview(locationText)
                
        // userProfileImageView Constraints
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        userProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        // userNameLabel Constraints
        userNameLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor, constant: 0.0).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 8.0).isActive = true
        
        // eventTitle Constraints
        eventTitleLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4).isActive = true
        eventTitleLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor, constant: 0).isActive = true
        eventTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        
        // durationIcon Constraints
        durationIconImage.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 8).isActive = true
        durationIconImage.rightAnchor.constraint(equalTo: userProfileImageView.centerXAnchor, constant: 0).isActive = true
        
        // durationLabel Constraints
        durationLabel.centerYAnchor.constraint(equalTo: durationIconImage.centerYAnchor, constant: 0).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: durationIconImage.rightAnchor, constant: 4).isActive = true
            
        // locationIcon Constraints
        locationIconImage.centerYAnchor.constraint(equalTo: durationIconImage.centerYAnchor, constant: 0).isActive = true
        locationIconImage.leftAnchor.constraint(equalTo: durationLabel.rightAnchor, constant: 8).isActive = true

        // locationLabel Constraints
        locationText.topAnchor.constraint(equalTo: locationIconImage.topAnchor, constant: 0).isActive = true
        locationText.leftAnchor.constraint(equalTo: locationIconImage.rightAnchor, constant: 4).isActive = true
        locationText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        
        self.bottomAnchor.constraint(equalTo: durationIconImage.bottomAnchor, constant: 8).isActive = true
    }
}
