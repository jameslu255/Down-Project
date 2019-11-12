//
//  LoginView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit
class LoginView: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoginBottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailText.delegate = self
        PasswordText.delegate = self
        LoginButton.layer.cornerRadius = 20
        LoginBottomButton.layer.cornerRadius = 20
        EmailText.becomeFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // checks if user has started editing. If user has, enable top login button
        LoginButton.isHidden = false
        LoginBottomButton.isHidden = true
        return true
    }
    
    // Please create a forgot Password view controller
    @IBAction func ForgotPasswordPressed(_ sender: Any) {
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        EmailText.resignFirstResponder()
        PasswordText.resignFirstResponder()
        LoginButton.isHidden = true
        LoginBottomButton.isHidden = false
        //Add api call here!
    }
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
