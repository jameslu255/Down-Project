//
//  EventDetailsPopupViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/18/19.
//

import UIKit
import MapKit

class EventDetailsPopupViewController: UIViewController {

    var event: Event? = nil
    let geoCoder = CLGeocoder()
    
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
        self.ProfilePicture.image = UIImage(named: "Default.ProfilePicture")
        self.Username.text = event?.originalPoster ?? "Error"
        if let title = event?.title {
            self.EventTitle.text = title.isEmpty ? "No title" : title
        }
        else {
            self.EventTitle.text = "Error"
        }
        self.Duration.text = event?.stringShortFormat ?? "Error"
        if let lat = event?.location?.latitude, let long = event?.location?.longitude {
            let location = CLLocation(latitude: lat, longitude: long)
            var locationString: String?
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                if error != nil {return}
                if let placemark = placemarks?[0] {
                    locationString = placemark.name
                }
            }
            self.Location.text = locationString ?? "No location"
        }
        self.Description.text = event?.description ?? "Error"
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
