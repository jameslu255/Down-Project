//
//  EventDetailsPopupViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/18/19.
//

import UIKit

class EventDetailsPopupViewController: UIViewController {

    var event: Event? = nil
    
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var Duration: UITextView!
    @IBOutlet weak var Location: UITextView!
    @IBOutlet weak var Description: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Container.layer.cornerRadius = 10
        Container.clipsToBounds = true
        setupViews()
        loadEventToViews()
    }
    
    func setupViews(){
        ProfilePicture.contentMode = .scaleAspectFill
        ProfilePicture.clipsToBounds = true
        ProfilePicture.layer.cornerRadius = 5
        Duration.layer.cornerRadius = 5
        Location.layer.cornerRadius = 5
        Description.layer.cornerRadius = 5
    }
    
    func loadEventToViews(){
        self.ProfilePicture.image = event?.user.profilePicture
        self.Username.text = event?.user.name
        self.EventTitle.text = event?.title
        self.Duration.text = event?.duration.stringFormat
        self.Location.text = event?.location
        self.Description.text = event?.description
        if self.Description.text.isEmpty {
            self.Description.removeFromSuperview()
        }
    }
    
    @IBAction func Tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension EventDetailsPopupViewController {
    
    private func setupSubviewsConstraints(){
        
    }
    
}
