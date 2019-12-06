//
//  MainNavigationViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/24/19.
//

import UIKit
import Firebase

class MainNavigationViewController: UIViewController {

    // All of the tab bar buttons
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var TitleNavItem: UINavigationItem!
    
    // The container of the switchable view controllers
    @IBOutlet weak var contentView: UIView!
    // The switchable view controllers
    var homeVC: HomeViewController!
    var decidedEventsVC: UITableViewController!
    var profileVC: ProfileViewController!
    
    // Array containing the switchable view controllers
    var viewControllers: [UIViewController]!
    var viewControllersNames: [String] = ["Down?", "Your Events", "Map", "Signout"]
    var currentVCIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVCs()
        buttons[currentVCIndex].isSelected = true
        TabButtonPressed(buttons[currentVCIndex])
    }
    
    // Instantiate the view controllers and place them in the view controller array
    func initializeVCs(){
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        homeVC = storyboard.instantiateViewController(identifier: "homeVC")
        decidedEventsVC = storyboard.instantiateViewController(identifier: "decidedEventsVC")
        let mapVC = UIStoryboard(name: "Mapview", bundle: nil).instantiateViewController(identifier:"mapVC") as! MapViewController
        profileVC = storyboard.instantiateViewController(identifier: "profileVC")
        profileVC.signOut = signOut
        viewControllers = [homeVC, decidedEventsVC, mapVC, profileVC]
    }

    func signOut(){
        // Signout from Firebase Authentication service
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        // Transition back to login flow
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "firstlogin")
        newController.modalPresentationStyle = .fullScreen
        self.present(newController, animated: false, completion: nil)
    }
    
    // When a tab button is pressed switch content view to the corresponding view controller and handle tab button icons
    @IBAction func TabButtonPressed(_ sender: UIButton) {
        // Remove current view controller from content view and deselect button
        let prevIndex = currentVCIndex
        currentVCIndex = sender.tag
        buttons[prevIndex].isSelected = false
        let prevVC = viewControllers[prevIndex]
        prevVC.willMove(toParent: nil)
        prevVC.view.removeFromSuperview()
        prevVC.removeFromParent()
        
        // Add new view controller to content view and select button
        TitleNavItem.title = viewControllersNames[currentVCIndex]
        let curVC = viewControllers[currentVCIndex]
        addChild(curVC)
        curVC.view.frame = contentView.bounds
        contentView.addSubview(curVC.view)
        curVC.didMove(toParent: self)
        sender.isSelected = true
    }
    
    @IBAction func CreateEventButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateEvent", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "createEvent")
        self.present(vc, animated: true, completion: nil)
    }
}
