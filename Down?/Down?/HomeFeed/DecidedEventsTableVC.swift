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
        tableView.reloadData() // See if work without
    }
    
    func loadEvents(){
        guard let user = Auth.auth().currentUser else {
            print("Invalid user in DecidedEventsTableVC")
            return
        }
        var downEventIDs: [String] = []
        var notDownEventIDs: [String] = []
        ApiEvent.getDownEventIDs(uid: user.uid) { eventIDs in
            downEventIDs = eventIDs
        }
        ApiEvent.getNotDownEventIDs(uid: user.uid) { eventIDs in
            notDownEventIDs = eventIDs
        }
        downEventIDs.forEach { id in
            ApiEvent.getEventDetails(autoID: id) { event in
                if let event = event {
                    self.downEvents.append(event)
                }
            }
        }
        notDownEventIDs.forEach { id in
            ApiEvent.getEventDetails(autoID: id) { event in
                if let event = event {
                    self.notDownEvents.append(event)
                }
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if indexPath.section == 0 {
            
        }
        else {
            
        }

        return cell
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
