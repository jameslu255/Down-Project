//
//  NameView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit
import Firebase

class NameView: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var NextBottomButton: UIButton!
    @IBOutlet weak var ErrorMessage: UILabel!
    let user: User? = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NextButton.layer.cornerRadius = 20
        NextBottomButton.layer.cornerRadius = 20
        FirstName.delegate = self
        LastName.delegate = self
        FirstName.becomeFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        NextButton.isHidden = false
        NextBottomButton.isHidden = true
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
    
    func updateName() {
        guard let changeRequest = user?.createProfileChangeRequest() else {
            return
        }
        if let firstName = FirstName.text, let lastName = LastName.text {
            changeRequest.displayName = firstName + " " + lastName
            changeRequest.commitChanges { (error) in
                // ...
            }
        }
    }
    
    // Probably should add some condition to make sure user entered something for First name at least
    @IBAction func NextPressed(_ sender: Any) {
        if let firstNameEmpty = FirstName.text?.isEmpty, let lastNameEmpty = LastName.text?.isEmpty, firstNameEmpty || lastNameEmpty {
            displayMessage(message: "Please enter a valid name.", color: .red)
            return
        }
        
        NextButton.isHidden = true
        NextBottomButton.isHidden = false
        // This is a cheeky way to change the animation of "present" or "dismiss" to look like push
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // Present like normal after changing transition type.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "EmailView")
        newController.modalPresentationStyle = .fullScreen
        present(newController, animated: false, completion: nil)
    }
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
