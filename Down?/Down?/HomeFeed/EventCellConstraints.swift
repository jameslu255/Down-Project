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
        self.contentView.addSubview(userProfileImageView)
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(eventTitleLabel)
        self.contentView.addSubview(durationIconImage)
        self.contentView.addSubview(durationLabel)
        self.contentView.addSubview(locationIconImage)
        self.contentView.addSubview(locationText)
                
        // userProfileImageView Constraints
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        userProfileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        
        // userNameLabel Constraints
        userNameLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor, constant: 0.0).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 8.0).isActive = true
        
        // eventTitle Constraints
        eventTitleLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4).isActive = true
        eventTitleLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor, constant: 0).isActive = true
        eventTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        
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
        locationText.centerYAnchor.constraint(equalTo: locationIconImage.centerYAnchor, constant: 0).isActive = true
        locationText.leftAnchor.constraint(equalTo: locationIconImage.rightAnchor, constant: 4).isActive = true
        locationText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        
        locationText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6).isActive = true
    }
}
