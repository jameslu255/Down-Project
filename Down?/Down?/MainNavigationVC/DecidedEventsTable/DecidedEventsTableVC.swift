//
//  DecidedEventsTableVC.swift
//  Down?
//
//  Created by Caleb Bolton on 11/24/19.
//

import UIKit
import Firebase

class DecidedEventsTableVC: UITableViewController {

    var downEvents: [Event] = []
    var notDownEvents: [Event] = []
    
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
        downEvents = getDownEvents()
        notDownEvents = getNotDownEvents()
    }
    
    
    // ------ For testing only -------
    func getDownEvents() -> [Event] {
        let dateStart = Date()
        let dateEnd = dateStart.advanced(by: 3600)
        let location = EventLocation(latitude: 38.558451, longitude: -121.743431)
        let event = Event(displayName: "Caleb Bolton", uid: "lgefCO4Io2ffOzETaEaAw1GeKvb2", date: EventDate(startDate: dateStart, endDate: dateEnd), isPublic: false, description: "Having a hell of a time", title: "Building an Iron Man suit", location: location)
        return [event]
    }
    
    func getNotDownEvents() -> [Event] {
        let dateStart = Date()
        let dateEnd = dateStart.advanced(by: 7200)
        let location = EventLocation(latitude: 38.897810, longitude: -77.036909)
        let event = Event(displayName: "Donald Trump", uid: "lgefCO4Io2ffOzETaEaAw1GeKvb2", date: EventDate(startDate: dateStart, endDate: dateEnd), isPublic: false, description: "Gee how great am I", title: "Staring at self in mirror", location: location)
        return [event]
    }
    // ------------------------------
    
//    func getDownEvents() -> [Event]{
//        guard let user = Auth.auth().currentUser else {
//            print("Invalid user in DecidedEventsTableVC")
//            return []
//        }
//        var downEvents: [Event] = []
//        var downEventIDs: [String] = []
//        ApiEvent.getDownEventIDs(uid: user.uid) { eventIDs in
//            downEventIDs = eventIDs
//        }
//        downEventIDs.forEach { id in
//            ApiEvent.getEventDetails(autoID: id) { event in
//                if let event = event {
//                    downEvents.append(event)
//                }
//            }
//        }
//        return downEvents
//    }
//
//    func getNotDownEvents() -> [Event]{
//        guard let user = Auth.auth().currentUser else {
//            print("Invalid user in DecidedEventsTableVC")
//            return []
//        }
//
//        var notDownEvents: [Event] = []
//        var notDownEventIDs: [String] = []
//
//        ApiEvent.getNotDownEventIDs(uid: user.uid) { eventIDs in
//            notDownEventIDs = eventIDs
//        }
//
//        notDownEventIDs.forEach { id in
//            ApiEvent.getEventDetails(autoID: id) { event in
//                if let event = event {
//                    notDownEvents.append(event)
//                }
//            }
//        }
//
//        return notDownEvents
//    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // down events section
        if section == 0 {
            return downEvents.count
        }
        // notDown events section
        else {
            return notDownEvents.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "down", for: indexPath)
            if let eventCell = cell as? DownEventCell {
                let event = downEvents[indexPath.row]
                eventCell.eventTitleLabel.text = event.title ?? "No title"
                eventCell.usernameLabel.text = event.originalPoster
                eventCell.durationLabel.text = event.stringShortFormat
                eventCell.locationTextView.text = event.location?.place ?? "No location"
                return eventCell
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notDown", for: indexPath)
            if let eventCell = cell as? NotDownEventCell {
                let event = notDownEvents[indexPath.row]
                eventCell.eventTitleLabel.text = event.title ?? "No title"
                eventCell.usernameLabel.text = event.originalPoster
                eventCell.durationLabel.text = event.stringShortFormat
                eventCell.locationTextView.text = event.location?.place ?? "No location"
                return eventCell
            }
            return cell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
