//
//  HomeFeedTableExtension.swift
//  Down?
//
//  Created by Caleb Bolton on 11/24/19.
//

import Foundation
import UIKit
import MapKit
import Firebase

// General feed functions
extension HomeViewController {
    func setUpFeed(){
        self.Feed.rowHeight = 100
        self.Feed.rowHeight = UITableView.automaticDimension
        self.Feed.estimatedRowHeight = UITableView.automaticDimension
        Feed.register(FeedEventCell.self, forCellReuseIdentifier: "cellId")
        Feed.delegate = self
        Feed.dataSource = self
        Feed.separatorStyle = .none
        
        loadModelData()
    }
    
    func loadModelData() {
        if let user = Auth.auth().currentUser {
            ApiEvent.getUnviewedEvent(uid: user.uid) { apiEvents in
                events = apiEvents
                events.sort(by: {return $0.dates.startDate < $1.dates.startDate})
                }
            }
        
//         To be used in future releases
        
//        if let user = Auth.auth().currentUser {
//            var events = [Event]()
//            var placemarks = [CLPlacemark]()
//            group.enter()
//            ApiEvent.getUnviewedEvent(uid: user.uid) { apiEvents in
//                events = apiEvents
//                events.sort(by: {return $0.dates.startDate < $1.dates.startDate})
//                self.loadPlacemarks(events: events) { placemarks in
//
//                }
//                self.group.leave()
//            }
//        }
    }
//    func loadPlacemarks(events: [Event], completion: @escaping ([CLPlacemark]) -> ()){
//        let geoLocator = CLGeocoder()
//        let locationGroup = DispatchGroup()
//        var placemarks = [CLPlacemark]()
//        for event in events {
//            if let location =  event.location {
//                let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//                locationGroup.enter()
//                geoLocator.reverseGeocodeLocation(clLocation) { pMarks, error in
//                    if error != nil {
//                        locationGroup.leave()
//                        return
//                    }
//
//                    if let pMarks = pMarks {
//                        let placemark = pMarks[0]
//                        placemarks.append(placemark)
//                    }
//                    locationGroup.leave()
//                }
//            }
//        }
//        locationGroup.notify(queue: .main) {
//            completion(placemarks)
//        }
//    }
    
    func removeEventCell(_ cell: EventCell, withDirection direction: UITableView.RowAnimation){
        guard let indexPath = Feed.indexPath(for: cell) else {
            return
        }
        events.remove(at: indexPath.row)
        
        Feed.beginUpdates()
        Feed.deleteRows(at: [indexPath], with: direction)
        Feed.endUpdates()
    }
}

// Swiping functionality
extension HomeViewController: SwipeableEventCellDelegate {
    
    func swipeRight(cell: EventCell) {
        removeEventCell(cell, withDirection: .right)
        if let eventID = cell.event?.autoID, let uid = Auth.auth().currentUser?.uid {
            ApiEvent.addUserDown(eventID: eventID, uid: uid) {}
        }
    }
    
    func swipeLeft(cell: EventCell) {
        removeEventCell(cell, withDirection: .left)
        if let eventID = cell.event?.autoID, let uid = Auth.auth().currentUser?.uid {
            ApiEvent.addUserNotDown(eventID: eventID, uid: uid) {}
        }
    }
    
    func tapped(event: Event) {
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        guard let eventDetailsPopup = storyboard.instantiateViewController(withIdentifier: "eventDetailsPopup") as? EventDetailsPopupViewController else {return}
        eventDetailsPopup.event = event
        self.present(eventDetailsPopup, animated: true) {
            
        }        
    }
}

// Datasource and Delegate functions
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Feed.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        guard let eventCell = cell as? SwipeableEventCell else {
            print("ISSUE")
            return cell
        }
                
        let event = events[indexPath.row]
        eventCell.delegate = self
        eventCell.event = event
        eventCell.profilePictureImageView.image = UIImage(named: "Default.ProfilePicture")
        eventCell.usernameLabel.text = event.originalPoster
        eventCell.eventTitleLabel.text = event.title == "" ? "No title" : event.title ?? "No title"
        eventCell.numDownLabel.text = String(event.numDown)
        eventCell.durationLabel.text = event.stringShortFormat
        if let lat = event.location?.latitude, let long = event.location?.longitude {
            let location = CLLocation(latitude: lat, longitude: long)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if error != nil {
                  eventCell.locationTextView.text = "No location"
                  return
                  
              }
                if let placemark = placemarks?[0], let name = placemark.name {
                    var address: String = ""
                    if let street = placemark.postalAddress?.street {
                        address = street
                        print(address)
                        if address.isEmpty {
                            print("yote")
                        }
                    }
                    else if let _ = placemark.postalAddress?.city, let _ = placemark.postalAddress?.subLocality {
                        print("here")
                    }
                    eventCell.addressTextView.text = address
                    eventCell.locationTextView.text = name
                }
              else {
                eventCell.locationTextView.text = "No location"
              }
            }
        }
        else {
            eventCell.locationTextView.text = "No location"
        }
        return eventCell
    }
}
