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

        if events.count == 0{
            DataManager.shared.firstVC.noEventsLabel.isHidden = false
        }
        else{
            DataManager.shared.firstVC.noEventsLabel.isHidden = true
        }
        self.Feed.rowHeight = 100
        self.Feed.rowHeight = UITableView.automaticDimension
        self.Feed.estimatedRowHeight = UITableView.automaticDimension
        Feed.register(FeedEventCell.self, forCellReuseIdentifier: "cellId")
        Feed.delegate = self
        Feed.dataSource = self
        Feed.separatorStyle = .none
        //checks if version is older that ios 10.0 because refresh is not there yet.
        if #available(iOS 10.0, *) {
            Feed.refreshControl = refreshControl
        } else {
            //adds a subview containing the refresh
            Feed.addSubview(refreshControl)
        }
    }

    
    func loadModelData() {
        if let user = Auth.auth().currentUser {
            ApiEvent.getUnviewedEvent(uid: user.uid) { apiEvents in
                events = apiEvents
                events.sort(by: {return $0.dates.startDate < $1.dates.startDate})
                loadLocations() { geoLocations in
                    self.removeSpinner()
                    self.view.isUserInteractionEnabled = true
                    locations = geoLocations
                    self.Feed.reloadData()
                }
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
    
    func removeEventCell(_ cell: EventCell, withDirection direction: UITableView.RowAnimation){
        guard let indexPath = Feed.indexPath(for: cell) else {
            return
        }
        events.remove(at: indexPath.row)
        locations.remove(at: indexPath.row)
        
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
        let name = locations[indexPath.row] ?? "Nil in locations array"
        eventCell.delegate = self
        eventCell.event = event
        eventCell.addressButton.setTitle(name, for: .normal)
        return eventCell
    }
}
