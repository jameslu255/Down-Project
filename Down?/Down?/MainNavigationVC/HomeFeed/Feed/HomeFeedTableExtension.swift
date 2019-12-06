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

    /// Loads event model data and then calls Feed.reloadData()
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
    }
    
    /// Removes the specified EventCell from the Feed with the specified direction
    func removeEventCell(_ cell: EventCell, withDirection direction: UITableView.RowAnimation){
        guard let indexPath = Feed.indexPath(for: cell) else {
            return
        }
        
        // Removes event and location name from model data arrays
        events.remove(at: indexPath.row)
        locations.remove(at: indexPath.row)
        
        // Let's the Feed remove the cell with an animtion
        Feed.beginUpdates()
        Feed.deleteRows(at: [indexPath], with: direction)
        Feed.endUpdates()
    }
}

// Swiping functionality
extension HomeViewController: SwipeableEventCellDelegate {
    
    func swipeRight(cell: EventCell) {
        removeEventCell(cell, withDirection: .right)
        // Adds the cell's event to the user's list of down events
        if let eventID = cell.event?.autoID, let uid = Auth.auth().currentUser?.uid {
            ApiEvent.addUserDown(eventID: eventID, uid: uid) {}
        }
    }
    
    func swipeLeft(cell: EventCell) {
        removeEventCell(cell, withDirection: .left)
        // Adds the cell's event to the user's list of notDown events
        if let eventID = cell.event?.autoID, let uid = Auth.auth().currentUser?.uid {
            ApiEvent.addUserNotDown(eventID: eventID, uid: uid) {}
        }
    }
    
    // Brings up the detailed view of the event
    func tapped(cell: EventCell) {
        guard let event = cell.event else {
            return
        }
        
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        guard let eventDetailsPopup = storyboard.instantiateViewController(withIdentifier: "eventDetailsPopup") as? EventDetailsPopupViewController else {return}
        eventDetailsPopup.event = event
        // Bad practice, but will fix in a future release when we are passing around a data structure that holds the locationName as well as the event
        eventDetailsPopup.locationName = cell.addressButton.titleLabel?.text
        self.present(eventDetailsPopup, animated: true)
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
        let locationName = locations[indexPath.row] ?? "No Location"
        eventCell.delegate = self
        eventCell.event = event
        eventCell.addressButton.setTitle(locationName, for: .normal)
        return eventCell
    }
}
