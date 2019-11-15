//
//  BottomMenuBarViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/15/19.
//

import UIKit

class BottomMenuBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createEventPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateEvent", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "createEvent")
        self.present(newController, animated: true, completion: nil)
    }
    
    
}
