//
//  ProfileVCViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 12/1/19.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var signOut: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        if let signOut = self.signOut {
            signOut()
        }
    }
    
}
