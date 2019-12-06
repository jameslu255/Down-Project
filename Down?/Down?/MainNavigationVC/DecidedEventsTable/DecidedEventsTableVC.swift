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
    var locationNames: [[String?]] = [[], []]
    var sections: [String] = ["Down", "Not Down"]
    //let geoCoder = CLGeocoder()
    //sync loading of down and not down events
    let eventsGroup = DispatchGroup()
    let locationNamesGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DownEventCell.self, forCellReuseIdentifier: "down")
        tableView.register(NotDownEventCell.self, forCellReuseIdentifier: "notDown")
        self.showSpinner(onView: self.view)
        self.view.isUserInteractionEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadModelData()
    }
    
    func reloadModelData(){
        getDownEvents()
        getNotDownEvents()
        eventsGroup.notify(queue: .main) {
            self.locationNamesGroup.enter()
            loadLocations(events: self.cellContents[0]) { locations in
                self.locationNames[0] = locations
                self.locationNamesGroup.leave()
            }
            self.locationNamesGroup.enter()
            loadLocations(events: self.cellContents[1]) { locations in
                self.locationNames[1] = locations
                self.locationNamesGroup.leave()
            }
            self.locationNamesGroup.notify(queue: .main) {
                self.tableView.reloadData()
            }
        }
    }
    
    func getDownEvents() {
        guard let user = Auth.auth().currentUser else {
            print("Invalid user in DecidedEventsTableVC")
            return
        }
        eventsGroup.enter()
        ApiEvent.getDownEvents(uid: user.uid) { events in
            self.removeSpinner()
            self.view.isUserInteractionEnabled = true
            self.cellContents[0] = events
            self.eventsGroup.leave()
        }
    }

    func getNotDownEvents() {
        guard let user = Auth.auth().currentUser else {
            print("Invalid user in DecidedEventsTableVC")
            return
        }
        eventsGroup.enter()
        ApiEvent.getNotDownEvents(uid: user.uid) { events in
            self.removeSpinner()
            self.view.isUserInteractionEnabled = true
            self.cellContents[1] = events
            self.eventsGroup.leave()
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
                eventCell.addressButton.setTitle(locationNames[indexPath.section][indexPath.row] ?? "No location", for: .normal)
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
                eventCell.addressButton.setTitle(locationNames[indexPath.section][indexPath.row] ?? "No location", for: .normal)
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
            ApiEvent.undoEventAction(eventID: eventID, uid: currentUser.uid, from: category) { }
        }
        removeEventCell(cell, withDirection: .left)
    }
    
    func swipeRight(cell: EventCell) {
        guard let event = cell.event, let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
        let category = indexPath.section == 0 ? "down" : "not_down"
        
        if let eventID = event.autoID {
            ApiEvent.undoEventAction(eventID: eventID, uid: currentUser.uid, from: category) { }
            if category == "down" {
                ApiEvent.addUserNotDown(eventID: eventID, uid: currentUser.uid, completion: {})
            }
            else {
                ApiEvent.addUserDown(eventID: eventID, uid: currentUser.uid, completion: {})
            }
        }
        removeEventCell(cell, withDirection: .right)
    }
    
    func tapped(event: Event) {
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        guard let eventDetailsPopup = storyboard.instantiateViewController(withIdentifier: "eventDetailsPopup") as? EventDetailsPopupViewController else {return}
        eventDetailsPopup.event = event
        self.present(eventDetailsPopup, animated: true) {
        }
    }
    
    func removeEventCell(_ cell: EventCell, withDirection direction: UITableView.RowAnimation){
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        cellContents[indexPath.section].remove(at: indexPath.row)
        locationNames[indexPath.section].remove(at: indexPath.row)
        
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: direction)
        let header = self.tableView.headerView(forSection: indexPath.section)
        let eventCount = self.cellContents[indexPath.section].count
        let sectionName = self.sections[indexPath.section]
        let headerTitle = "\(sectionName) (\(eventCount))"
        header?.textLabel?.text = headerTitle
        header?.layoutSubviews()
        self.tableView.endUpdates()
        reloadModelData()
    }
}
