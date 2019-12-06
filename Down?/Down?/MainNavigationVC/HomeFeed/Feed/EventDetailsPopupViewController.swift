//
//  EventDetailsPopupViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/18/19.
//

import UIKit
import MapKit

class EventDetailsPopupViewController: UIViewController {

    var event: Event?
    var locationName: String?
    
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Duration: UITextView!
    @IBOutlet weak var Location: UIButton!
    @IBOutlet weak var Description: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Container.layer.cornerRadius = 10
        Container.clipsToBounds = true
        setupViews()
        loadModelDataIntoViews()
    }
    
    func setupViews(){
        Duration.layer.cornerRadius = 5
        Location.layer.cornerRadius = 5
        Description.layer.cornerRadius = 5
    }
    
    func loadModelDataIntoViews() {
        guard let event = self.event, let locationName = locationName else {
            print("Set event to nil")
            return
        }
        
        Name.text = event.originalPoster
        EventTitle.text = event.title ?? "No title"
        Duration.text = event.stringShortFormat
        self.Description.text = event.description ?? ""
        if self.Description.text.isEmpty {
            self.Description.removeFromSuperview()
        }
        Location.setTitle(locationName, for: .normal)
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        if let location = event?.location {
            openMap(location: location)
        }
    }
    
    @IBAction func Tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
