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
    //let geoCoder = CLGeocoder()
    //sync loading of down and not down events
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadModelData()
        tableView.register(DownEventCell.self, forCellReuseIdentifier: "down")
        tableView.register(NotDownEventCell.self, forCellReuseIdentifier: "notDown")
        	
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showSpinner(onView: self.view)
        self.view.isUserInteractionEnabled = false
        getDownEvents()
        getNotDownEvents()
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    func reloadModelData(){
//        let downEventStartDate = Date()
//        let downEventEndDate = downEventStartDate.advanced(by: 3600)
//        let downEvent = Event(displayName: "Sam Harris", uid: "lgefCO4Io2ffOzETaEaAw1GeKvb2", startDate: downEventStartDate, endDate: downEventEndDate, isPublic: true, description: "Just tryna chill with da mindful homies", title: "Meditatin", latitude: 38.540944, longitude: -121.737213, categories: [])
//        cellContents[0] = [downEvent]
//        cellContents[1] = []

        getDownEvents()
        getNotDownEvents()
    }
    
    func getDownEvents() {
        guard let user = Auth.auth().currentUser else {
            print("Invalid user in DecidedEventsTableVC")
            return
        }
        group.enter()
        ApiEvent.getDownEvents(uid: user.uid) { events in
            self.removeSpinner()
            self.view.isUserInteractionEnabled = true
            self.cellContents[0] = events
            self.group.leave()
        }
    }

    func getNotDownEvents() {
        guard let user = Auth.auth().currentUser else {
            print("Invalid user in DecidedEventsTableVC")
            return
        }
        group.enter()
        ApiEvent.getNotDownEvents(uid: user.uid) { events in
            self.removeSpinner()
            self.view.isUserInteractionEnabled = true
            self.cellContents[1] = events
            self.group.leave()
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
                eventCell.event = event
                eventCell.delegate = self
                eventCell.eventTitleLabel.text = event.title ?? "No title"
                eventCell.numDownLabel.text = String(event.numDown)
                eventCell.usernameLabel.text = event.originalPoster
                eventCell.durationLabel.text = event.stringShortFormat
                if let lat = event.location?.latitude, let long = event.location?.longitude {
                    let location = CLLocation(latitude: lat, longitude: long)
                    var locationString: String?
                    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                        if error != nil {return}
                        if let placemark = placemarks?[0] {
                            locationString = placemark.name
                          eventCell.locationTextView.text = locationString ?? "No location"
                        }
                    }
                    
                }
                return eventCell
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notDown", for: indexPath)
            if let eventCell = cell as? NotDownEventCell {
                let event = cellContents[indexPath.section][indexPath.row]
                eventCell.event = event
                eventCell.delegate = self
                eventCell.eventTitleLabel.text = event.title ?? "No title"
                eventCell.numDownLabel.text = String(event.numDown)
                eventCell.usernameLabel.text = event.originalPoster
                eventCell.durationLabel.text = event.stringShortFormat
                if let lat = event.location?.latitude, let long = event.location?.longitude {
                    let location = CLLocation(latitude: lat, longitude: long)
                    var locationString: String?
                    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                        if error != nil {return}
                        if let placemark = placemarks?[0] {
                            locationString = placemark.name
                          eventCell.locationTextView.text = locationString ?? "No location"
                        }
                    }
                    
                }
                return eventCell
            }
            return cell
        }
    }
}

extension DecidedEventsTableVC: SwipeableEventCellDelegate {
    func swipeLeft(cell: EventCell) {
        
        guard let event = cell.event, let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else {
            return }
        let category = indexPath.section == 0 ? "down" : "not_down"
        if let eventID = event.autoID {
            ApiEvent.undoEventAction(eventID: eventID, uid: currentUser.uid, from: category) { print("api complete") }
        }
        removeEventCell(cell, withDirection: .left)
    }
    
    func swipeRight(cell: EventCell) {
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
        removeEventCell(cell, withDirection: .right)
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
