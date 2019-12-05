//
//  EmailView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit
import Firebase
class EmailView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBOutlet weak var SignupButton: UIButton!
    @IBOutlet weak var SignupBottomButton: UIButton!
    var user: User?
    var firstName: String?
    var lastName: String?
    
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
    
    func displayMessage(message: String, color: UIColor) {
        self.ErrorMessage.text = message
        self.ErrorMessage.textColor = color
        self.ErrorMessage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.ErrorMessage.isHidden = true
        }
    }
    
    func updatedName() -> Bool {
        guard let changeRequest = self.user?.createProfileChangeRequest() else {
            return false
        }
        var updateSuccess = false
        if let firstName = firstName, let lastName = lastName {
            changeRequest.displayName = firstName + " " + lastName
            changeRequest.commitChanges { (error) in
                if let error = error {
                    self.displayMessage(message: error.localizedDescription, color: .red)
                } else {
                    updateSuccess = true
                }
            }
        }
        return updateSuccess
    }
    
    func sendVerificationEmail() {
        guard let authUser = self.user else {
            //Could not get user
            self.displayMessage(message: "Could not get user information.", color: .red)
            return
        }
        // Send verification email
        if !authUser.isEmailVerified {
            authUser.sendEmailVerification { error in
                // Notify the user that the mail has sent or couldn't because of an error.
                if let error = error {
                    self.displayMessage(message: error.localizedDescription, color: .red)
                } else {
                    self.displayMessage(message: "Sent verification email.", color: .green)
                }
            }
        }
        else {
            // The user is already verified.
            self.displayMessage(message: "Email has already been verfied.", color: .red)
        }
    }
    func presentFirstView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "firstlogin")
        newController.modalPresentationStyle = .fullScreen
        self.present(newController, animated: true, completion: nil)
    }
    
    func signupUser() {
        if let email = Email.text, let password = Password.text {
            //Create the user then send the verfication email
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let error = error {
                    self.displayMessage(message: error.localizedDescription, color: .red)
                } else {
                    self.user = user?.user
                    guard let changeRequest = self.user?.createProfileChangeRequest() else {
                        return
                    }
                    if let firstName = self.firstName, let lastName = self.lastName {
                        changeRequest.displayName = firstName + " " + lastName
                        changeRequest.commitChanges { (error) in
                            if let error = error {
                                self.displayMessage(message: error.localizedDescription, color: .red)
                                return
                            }
                        }
                    }
                    self.sendVerificationEmail()
                    self.presentFirstView()
                }
            }
        }
    }
    
    @IBAction func SignupPressed(_ sender: Any) {
        Email.resignFirstResponder()
        Password.resignFirstResponder()
        ConfirmPassword.resignFirstResponder()
        SignupButton.isHidden = true
        SignupBottomButton.isHidden = false
        //do api call here!
        if Password.text != ConfirmPassword.text {
            displayMessage(message: "Passwords do not match.", color: .red)
            return
        }
        self.signupUser()
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
