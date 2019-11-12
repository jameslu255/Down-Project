//
//  EmailView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit
class EmailView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBOutlet weak var SignupButton: UIButton!
    @IBOutlet weak var SignupBottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignupButton.layer.cornerRadius = 20
        SignupBottomButton.layer.cornerRadius = 20
        Email.delegate = self
        Password.delegate = self
        ConfirmPassword.delegate = self
        Email.becomeFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        SignupButton.isHidden = false
        SignupBottomButton.isHidden = true
        return true
    }

    @IBAction func SignupPressed(_ sender: Any) {
        Email.resignFirstResponder()
        Password.resignFirstResponder()
        ConfirmPassword.resignFirstResponder()
        SignupButton.isHidden = true
        SignupBottomButton.isHidden = false
        //do api call here!
    }
    
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        // Changes transition to look like pop off for "dismiss"
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // Dismiss view like normal
        dismiss(animated: false, completion: nil)
    }
}
