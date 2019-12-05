//
//  FirstLoginView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit

class FirstLoginView: UIViewController {
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //changes button to be curved
        LoginButton.layer.cornerRadius = 20
        SignupButton.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    @IBAction func LoginPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "LoginView")
        newController.modalPresentationStyle = .fullScreen
        self.present(newController, animated: true, completion: nil)
    }
    
    @IBAction func SignupPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "NameView")
        newController.modalPresentationStyle = .fullScreen
        self.present(newController, animated: true, completion: nil)
    }
}
