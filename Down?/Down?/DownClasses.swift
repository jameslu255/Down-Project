//
//  DownClasses.swift
//  Down?
//
//  Created by Caleb Bolton on 11/17/19.
//

import Foundation
import UIKit

class Event {
    
    init(user: DownUser, title: String, duration: Duration, description: String?, numDown: Int, location: String, coordinates: Coordinates?, isPublic: Bool) {
        self.user = user
        self.title = title
        self.duration = duration
        self.description = description
        self.numDown = numDown
        self.location = location
        self.coordinates = coordinates
        self.isPublic = isPublic
    }
    
    var user: DownUser
    var title: String
    var duration: Duration
    var description: String?
    var numDown: Int
    var location: String
    var coordinates: Coordinates?
    var isPublic: Bool
}

struct Duration {
    
    init(startTime: Date, endTime: Date) {
        self.startTime = startTime
        self.endTime = endTime
    }
    var startTime: Date
    var endTime: Date
    var stringFormat: String {
        get{
            var result: String = ""
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let start = formatter.string(from: startTime)
            let end = formatter.string(from: endTime)
            result = "\(start) - \(end)"
            result = result.replacingOccurrences(of: ":00", with: "")
            return result
        }
    }
}

struct Coordinates {
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var latitude: Double
    var longitude: Double
}

class DownUser {
    
    init(name: String, profilePicture: UIImage? = nil) {
        self.name = name
        if let profilePicture = profilePicture {
            self.profilePicture = profilePicture
        }
        else {
            // Using bang here because if it can't find the picture, we want to know at compile time that we didn't set up the image resource correctly
            self.profilePicture = UIImage(named: "Default.ProfilePicture")!
        }
    }
    
    var name: String
    var profilePicture: UIImage
}
