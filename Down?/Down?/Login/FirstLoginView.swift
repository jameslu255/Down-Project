//
//  FirstLoginView.swift
//  Down?
//
//  Created by James Lu on 11/11/19.
//

import UIKit

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        //animating design
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        //creates a dispatchQueue that implements the spinner overlay and waits for the dispatch to be released
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    //function that removes the dispatch queue so that the code can continue running
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

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
