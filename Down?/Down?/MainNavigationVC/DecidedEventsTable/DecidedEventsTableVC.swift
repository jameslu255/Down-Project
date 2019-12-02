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

    var downEvents: [Event] = []
    var notDownEvents: [Event] = []
    let geoCoder = CLGeocoder()
    //sync loading of down and not down events
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents()
        tableView.register(DownEventCell.self, forCellReuseIdentifier: "down")
        tableView.register(NotDownEventCell.self, forCellReuseIdentifier: "notDown")
        //all the events have loaded
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    
    func loadEvents(){
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
            self.downEvents = events
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
            self.notDownEvents = events
            self.group.leave()
        }
    }
    
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
                let event = notDownEvents[indexPath.row]
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
