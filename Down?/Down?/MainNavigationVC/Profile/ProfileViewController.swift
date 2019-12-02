//
//  ProfileVCViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 12/1/19.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
   
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var userNameWarningLabel: UILabel!
    @IBOutlet weak var userNameWarningStackView: UIStackView!
    @IBOutlet weak var userNameEditingButton: UIButton!
    
    var isEditingUserName: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        profilePictureButton.layer.cornerRadius = 5
        userNameLabel.layer.cornerRadius = 5
    }
    
    func userNameEnabled(){
        
        userNameLabel.isEnabled = true //test
        userNameLabel.backgroundColor = .secondarySystemBackground
        userNameLabel.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.userNameEditingButton.alpha = 0
        }
    }
    
    func userNameDisabled(){
        userNameLabel.isEnabled = false
        userNameLabel.backgroundColor = .systemBackground
        userNameLabel.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.userNameEditingButton.alpha = 1
        }
    }
    
    @IBAction func changeProfilePicturePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func editUserNameButtonPressed(_ sender: Any) {
        if !isEditingUserName {
            isEditingUserName = true
            userNameEnabled()
        }
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        if isEditingUserName {
            let userNameInput = userNameLabel.text ?? ""
            if userNameInput.isEmpty {
                userNameWarningStackView.alpha = 1
                userNameWarningLabel.text = "Must be at least one character long"
                UIView.animate(withDuration: 2, delay: 3, options: .curveEaseIn, animations: {
                    self.userNameWarningStackView.alpha = 0
                }, completion: nil)
            }
            else {
                userNameDisabled()
                if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                    changeRequest.displayName = userNameInput
                    changeRequest.commitChanges(completion: nil)
                }
                isEditingUserName = false
            }
        }
    }
    
}
