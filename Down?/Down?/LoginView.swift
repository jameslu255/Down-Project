//
//  LoginView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit
import Firebase

class LoginView: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoginBottomButton: UIButton!
    let user: User? = Auth.auth().currentUser
    
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
    
    func displayMessage(message: String, color: UIColor) {
        self.ErrorMessage.text = message
        self.ErrorMessage.textColor = color
        self.ErrorMessage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.ErrorMessage.isHidden = true
        }
    }
    
    // Please create a forgot Password view controller
    @IBAction func ForgotPasswordPressed(_ sender: Any) {
    }
    
    func loginUser() {
        if let email = EmailText.text, let password = PasswordText.text, !email.isEmpty && !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                // Notify the user that the mail has sent or couldn't because of an error.
                if let error = error {
                    self.displayMessage(message: error.localizedDescription, color: .red)
                    return
                }
                //user data from server
                if let user = user?.user, !user.isEmailVerified {
                    self.displayMessage(message: "Verification email was sent but email unverified.", color: .red)
                    return
                }
                self.displayMessage(message: "Succesfully logged in", color: .green)

            }
        } else {
            displayMessage(message: "Please enter valid credentials", color: .red)
        }
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        EmailText.resignFirstResponder()
        PasswordText.resignFirstResponder()
        LoginButton.isHidden = true
        LoginBottomButton.isHidden = false
        //Add api call here!
        loginUser()
    }
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
