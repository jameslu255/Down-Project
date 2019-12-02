//
//  DecidedEventsTableVC.swift
//  Down?
//
//  Created by Caleb Bolton on 11/24/19.
//

import UIKit
import Firebase
import MapKit

class DecidedEventsTableVC: UITableViewController {

    var cellContents: [[Event]] = [[], []]
    var sections: [String] = ["Down", "Not Down"]
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents()
        tableView.register(DownEventCell.self, forCellReuseIdentifier: "down")
        tableView.register(NotDownEventCell.self, forCellReuseIdentifier: "notDown")
        tableView.reloadData() // See if work without
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadEvents(){
//        let downEventStartDate = Date()
//        let downEventEndDate = downEventStartDate.advanced(by: 3600)
//        let downEvent = Event(displayName: "Sam Harris", uid: "lgefCO4Io2ffOzETaEaAw1GeKvb2", startDate: downEventStartDate, endDate: downEventEndDate, isPublic: true, description: "Just tryna chill with da mindful homies", title: "Meditatin", latitude: 38.540944, longitude: -121.737213, categories: [])
//        cellContents[0] = [downEvent]
//        cellContents[1] = []
        if let uid = Auth.auth().currentUser?.uid {
            ApiEvent.getDownEvents(uid: uid) { events in
                print(events.count)
                self.cellContents[0] = events
                self.tableView.reloadData()
            }
            ApiEvent.getNotDownEvents(uid: uid) { events in
                self.cellContents[1] = events
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "\(sections[section]) (\(cellContents[section].count))"
        return title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellContents[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "down", for: indexPath)
            if let eventCell = cell as? DownEventCell {
                let event = cellContents[indexPath.section][indexPath.row]
                eventCell.delegate = self
                eventCell.eventTitleLabel.text = event.title ?? "No title"
                eventCell.usernameLabel.text = event.originalPoster
                eventCell.durationLabel.text = event.stringShortFormat
                if let lat = event.location?.latitude, let long = event.location?.longitude {
                    let location = CLLocation(latitude: lat, longitude: long)
                    var locationString: String?
                    geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                        if error != nil {return}
                        if let placemark = placemarks?[0] {
                            locationString = placemark.name
                        }
                    }
                    eventCell.locationTextView.text = locationString ?? "No location"
                }
                return eventCell
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notDown", for: indexPath)
            if let eventCell = cell as? NotDownEventCell {
                let event = cellContents[indexPath.section][indexPath.row]
                eventCell.eventTitleLabel.text = event.title ?? "No title"
                eventCell.usernameLabel.text = event.originalPoster
                eventCell.durationLabel.text = event.stringShortFormat
                if let lat = event.location?.latitude, let long = event.location?.longitude {
                    let location = CLLocation(latitude: lat, longitude: long)
                    var locationString: String?
                    geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                        if error != nil {return}
                        if let placemark = placemarks?[0] {
                            locationString = placemark.name
                        }
                    }
                    eventCell.locationTextView.text = locationString ?? "No location"
                }
                return eventCell
            }
            return cell
        }
    }
}

extension DecidedEventsTableVC: SwipeableEventCellDelegate {
    func swipeLeft(cell: EventCell) {
        
        removeEventCell(cell, withDirection: .left)
        guard let event = cell.event, let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
        let category = indexPath.section == 0 ? "down" : "notDown"
        if let eventID = event.autoID {
            ApiEvent.undoEventAction(eventID: eventID, uid: currentUser.uid, from: category) { }
        }
    }
    
    func swipeRight(cell: EventCell) {
        removeEventCell(cell, withDirection: .right)
        guard let event = cell.event, let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
        let category = indexPath.section == 0 ? "down" : "notDown"
        
        if let eventID = event.autoID {
            ApiEvent.undoEventAction(eventID: eventID, uid: currentUser.uid, from: category) { }
            if category == "down" {
                ApiEvent.addUserNotDown(eventID: eventID, uid: currentUser.uid, completion: {})
            }
            else {
                ApiEvent.addUserNotDown(eventID: eventID, uid: currentUser.uid, completion: {})
            }
        }
    }
    
    func tapped(event: Event) {
        
    }
    
    func removeEventCell(_ cell: EventCell, withDirection direction: UITableView.RowAnimation){
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        cellContents[indexPath.section].remove(at: indexPath.row)
        
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: direction)
        let header = self.tableView.headerView(forSection: indexPath.section)
        let eventCount = self.cellContents[indexPath.section].count
        let sectionName = self.sections[indexPath.section]
        let headerTitle = "\(sectionName) (\(eventCount))"
        header?.textLabel?.text = headerTitle
        self.tableView.endUpdates()
    }
}
