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

    // Model data arrays
    var cellContents: [[Event]] = [[], []]
    var locationNames: [[String?]] = [[], []]
    var sections: [String] = ["Down", "Not Down"]
    var sectionsCellReuseIdentifiers: [String] = ["down", "notDown"]
    
    //let geoCoder = CLGeocoder()
    //sync loading of down and not down events
    let eventsGroup = DispatchGroup()
    let locationNamesGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DownEventCell.self, forCellReuseIdentifier: sectionsCellReuseIdentifiers[0])
        tableView.register(NotDownEventCell.self, forCellReuseIdentifier: sectionsCellReuseIdentifiers[1])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadModelData()
    }
    
    // Reloads model data from database
    // Fetches both down and not down events, creates locations names, then calls tableView.reloadData() in that order using GroupDispatches
    func reloadModelData(){
        self.showSpinner(onView: self.view)
        self.view.isUserInteractionEnabled = false
        
        getDownEvents()
        getNotDownEvents()
        // Once we have all the events, create location names from events' locations
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
            // Once we have loaded all location names, reload table
            self.locationNamesGroup.notify(queue: .main) {
                self.tableView.reloadData()
            }
        }
    }
    
    /// Gets down events and adds them to the cellContents array
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

    /// Gets notDown events and adds them to the cellContents array
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: sectionsCellReuseIdentifiers[indexPath.section], for: indexPath)
        if let cell = cell as? SwipeableEventCell {
            let event = cellContents[indexPath.section][indexPath.row]
            let locationName = locationNames[indexPath.section][indexPath.row]
            cell.event = event
            cell.delegate = self
            cell.addressButton.setTitle(locationName ?? "No location", for: .normal)
            return cell
        }
        
        print("Dequeued UITableViewCell's data was not updated")
        return cell
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
