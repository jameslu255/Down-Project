//
//  HomeFeedTableExtension.swift
//  Down?
//
//  Created by Caleb Bolton on 11/24/19.
//

import Foundation
import UIKit


extension HomeViewController: SwipeableEventCellDelegate {
    func swipeRight(cell: EventCell) {
        removeEventCell(cell, withDirection: .right)
//        if let event = cell.event {
//            ApiEvent.addUserDown(event: event) {}
//        }
    }
    
    func swipeLeft(cell: EventCell) {
        removeEventCell(cell, withDirection: .left)
//        if let event = cell.event {
//            ApiEvent.addUserNotDown(event: event) {}
//        }
    }
    
    func tapped(event: Event) {
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        guard let eventDetailsPopup = storyboard.instantiateViewController(withIdentifier: "eventDetailsPopup") as? EventDetailsPopupViewController else {return}
        eventDetailsPopup.event = event
        self.present(eventDetailsPopup, animated: true) {
            
        }        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setUpFeed(){
        self.Feed.rowHeight = 100
        self.Feed.rowHeight = UITableView.automaticDimension
        self.Feed.estimatedRowHeight = UITableView.automaticDimension
        Feed.register(FeedEventCell.self, forCellReuseIdentifier: "cellId")
        Feed.delegate = self
        Feed.separatorStyle = .none
        Feed.reloadData()
    }
    
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
        eventCell.durationLabel.text = event.stringShortFormat
        eventCell.locationTextView.text = event.location?.place ?? "No Location"
        
        return eventCell
    }
    
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
