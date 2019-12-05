//
//  EventCellModel.swift
//  Down?
//
//  Created by Caleb Bolton on 12/4/19.
//

import UIKit
import MapKit

struct EventCellModel {
    var event: Event
    var user: ApiUser
    var placemark: CLLocation
    
    init(event: Event, user: ApiUser, placemark: CLLocation) {
        self.event = event
        self.user = user
        self.placemark = placemark
    }
}
