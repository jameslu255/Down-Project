//
//  ResetView.swift
//  Down?
//
//  Created by James Lu on 11/13/19.
//

import UIKit
import Firebase
class ResetView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var SubmitBottomButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        SubmitButton.layer.cornerRadius = 20
        SubmitBottomButton.layer.cornerRadius = 20
        Email.delegate = self
        Email.becomeFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        SubmitButton.isHidden = false
        SubmitBottomButton.isHidden = true
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
    
    func resetPassword(){
        if let email = Email.text, !email.isEmpty {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.displayMessage(message: error.localizedDescription, color: .red)
                } else {
                    self.displayMessage(message: "Email sent!", color: .green)
                }
            }
        }
    }
    
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        Email.resignFirstResponder()
        SubmitButton.isHidden = true
        SubmitBottomButton.isHidden = false
        // do something
        resetPassword()
    }
    
    @IBAction func BackButtonPressed(_ sender: Any) {
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
