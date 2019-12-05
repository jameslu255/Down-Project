//
//  MainNavigationViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/24/19.
//

import UIKit
import Firebase

class MainNavigationViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var TitleNavItem: UINavigationItem!
    
    @IBOutlet weak var contentView: UIView!
    var homeVC: HomeViewController!
    var decidedEventsVC: UITableViewController!
    var profileVC: ProfileViewController!
    
    var viewControllers: [UIViewController]!
    var viewControllersNames: [String] = ["Down?", "Your Events", "Map", "Profile"]
    var currentVCIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVCs()
        buttons[currentVCIndex].isSelected = true
        TabButtonPressed(buttons[currentVCIndex])
    }
    
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
        print("Hello")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        self.dismiss(animated: true) {
            print("whadup")
        }
    }
    
    @IBAction func TabButtonPressed(_ sender: UIButton) {
        let prevIndex = currentVCIndex
        currentVCIndex = sender.tag
        buttons[prevIndex].isSelected = false
        let prevVC = viewControllers[prevIndex]
        prevVC.willMove(toParent: nil)
        prevVC.view.removeFromSuperview()
        prevVC.removeFromParent()
        
        TitleNavItem.title = viewControllersNames[currentVCIndex]
        let curVC = viewControllers[currentVCIndex]
//      if (currentVCIndex == 2) {
//        let mapViewCo = curVC as! MapViewController
//        mapViewCo.events = events
//        curVC = mapViewCo
//      }
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
