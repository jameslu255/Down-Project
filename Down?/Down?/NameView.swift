//
//  NameView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit
class NameView: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var NextBottomButton: UIButton!
    
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

    // Probably should add some condition to make sure user entered something for First name at least
    @IBAction func NextPressed(_ sender: Any) {
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
