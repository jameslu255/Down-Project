//
//  BottomMenuBarViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/15/19.
//

import UIKit

class BottomMenuBarViewController: UIViewController {

    @IBOutlet weak var createButtonShadowCaster: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButtonShadowCaster.layer.masksToBounds = false
        createButtonShadowCaster.layer.shadowColor = UIColor.black.cgColor
        createButtonShadowCaster.layer.shadowOffset = .zero
        createButtonShadowCaster.layer.shadowRadius = 4
        createButtonShadowCaster.layer.shadowOpacity = 1.0
    }

    @IBAction func createEventPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateEvent", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "createEvent")
        self.present(newController, animated: true, completion: nil)
    }
}
