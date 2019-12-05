//
//  HomeViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/13/19.
//

import UIKit
import Firebase
import MapKit

var currentLocation: EventLocation?
var events: [Event] = [] {
    //calls this whenever events array is changed.
    didSet{
        if events.count == 0{
            DataManager.shared.firstVC.noEventsLabel.isHidden = false
        }
        else{
            DataManager.shared.firstVC.noEventsLabel.isHidden = true
        }
    }
}

var locations: [String?] = []

// class that provides a shared instance of the HomeViewController so that values can be called from different views.
class DataManager {
    static let shared = DataManager()
    var firstVC = HomeViewController()
}

class HomeViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var Feed: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noEventsLabel: UILabel!
    
    var buttons = ["Filter", "Sort"]
    
    let cellSpacing: CGFloat = 5.0
    let numTestCells: Int = 50

    var refreshControl = UIRefreshControl()
    var user: User = Auth.auth().currentUser!
    
    func showFirstTimeInstructions() {
        //Create the alert controller.
        let alert = UIAlertController(title: "Directions",
                                      message: "Swipe right for down and swipe left for not down.",
                                      preferredStyle: .alert)
        
        //Present the alert.
        self.present(alert, animated: true, completion: {
        })

    }
    
    
    // This refresh function is called when the table is being pulled down
    @objc func refresh(_ sender:Any)
    {
        // Updating your data here...
        ApiEvent.getUnviewedEventFilter(uid: user.uid, categories: categoryFilters) { apiEvents in
            events = apiEvents
            if let distance = distanceFilter, let currentLocation = currentLocation {
                events = filterByDistance(events: events, currentLocation: currentLocation, distance: distance)
            }
            if sortedCheck[0] == 1{
                events.sort(by: {return $0.dates.startDate < $1.dates.startDate})
            }
            if sortedCheck[1] == 1{
                if let currentLocation = currentLocation {
                    events.sort(by: {
                        guard let lat = $0.location?.latitude, let lon = $0.location?.longitude, let lat2 = $1.location?.latitude, let lon2 = $1.location?.longitude else {return false}
                        return distanceInMiles(lat1: currentLocation.latitude, lon1: currentLocation.longitude, lat2: lat, lon2: lon) < distanceInMiles(lat1: currentLocation.latitude, lon1: currentLocation.longitude, lat2: lat2, lon2: lon2)})
                }
            }
            if sortedCheck[2] == 1{
                events.sort(by: {return $0.numDown > $1.numDown})
            }
            loadLocations() { geoLocations in
                //reload table before dismissing
                locations = geoLocations
                self.refreshControl.endRefreshing()
                self.Feed.reloadData()
            }

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadModelData()
        // adds the refresh target on the table and calls refresh function
        refreshControl.addTarget(self, action:  #selector(refresh(_:)), for: .valueChanged)
        // sets the DataManager as a delegate so that shared instance will work
        DataManager.shared.firstVC = self
        registerFilterNib()
        checkLocationServices()
        self.setUpFeed()
        if firstLaunchFlag {
            self.showFirstTimeInstructions()
        }
    }
}


extension HomeViewController: CLLocationManagerDelegate {
  func checkLocationServices() {
    if (CLLocationManager.locationServicesEnabled()){
      setUpLocationManager()
      checkLocationAuthorization()
    }
    else {
      // tell to turn it on.
      locationAlert()
    }
  }
  
  func setUpLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  func checkLocationAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      // Do something
      locationManager.startUpdatingLocation()
      break
    case .denied:
      // Tell user to enable
      locationAlert()
      break
    case .notDetermined:
      // Prompt a request
      locationManager.requestWhenInUseAuthorization()
      break
    case .restricted:
      // Show alert letting them know what's up
      restrictedAlert()
      break
    case .authorizedAlways:
      // I guess we do stuff here too
      locationManager.startUpdatingLocation()
      break
    default:
      print("shit")
      break
    }
  }
  
  func locationAlert() {
    // https://stackoverflow.com/questions/28152526/how-do-i-open-phone-settings-when-a-button-is-clicked
    let alert = UIAlertController(title: "Please enable location services for this app", message: "Setting > Privacy > Location Services", preferredStyle: .alert)
    let openSettings = UIAlertAction(title: "Open Settings", style: .default) { (_) -> Void in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
      }

      if UIApplication.shared.canOpenURL(settingsUrl) {
          UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
              print("Settings opened: \(success)") // Prints true
          })
      }
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(openSettings)
    alert.addAction(cancel)
    self.present(alert, animated: true)
  }
  
  func restrictedAlert() {
    let alert = UIAlertController(title:"Authorization restricted", message: "You will not be able fully utilize the features of the app", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude {
      currentLocation = EventLocation(latitude: latitude, longitude: longitude)
    }
  }
}

// Found in "Let's Build That App" YouTube channel.
extension UIView {
    func addConstraintWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    // Found in "Mark Moeykens" YouTube channel
    func setGradientBackground(gradient: CAGradientLayer, colorOne: UIColor, colorTwo: UIColor){
        setGradientBackground(gradient: gradient, colorOne: colorOne, colorTwo: colorTwo, firstColorStart: 0.0, secondColorStart: 1.0)
    }
    
    func setGradientBackground(gradient: CAGradientLayer, colorOne: UIColor, colorTwo: UIColor, firstColorStart: NSNumber, secondColorStart: NSNumber) {
        let gradientLayer = gradient
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [firstColorStart, secondColorStart]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateGradient(gradient: CAGradientLayer){
        gradient.frame = self.bounds
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
