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
var events: [Event] = []

class DataManager {
    static let shared = DataManager()
    var firstVC = HomeViewController()
}

class HomeViewController: UIViewController {

    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var Feed: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var buttons = ["Filter", "Sort"]
    
    let cellSpacing: CGFloat = 5.0
    let numTestCells: Int = 50
      
    var refreshControl = UIRefreshControl()
    var user: User = Auth.auth().currentUser!
    
    
    private func deg2rad(_ deg:Double) -> Double {
        return deg * Double.pi / 180
    }

    ///  This function converts radians to decimal degrees
    private func rad2deg(_ rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }

    ///  This function calculates the distance between two corrdinates in miles
    private func distanceInMiles(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta))
        dist = acos(dist)
        dist = rad2deg(dist)
        dist = dist * 60 * 1.1515

        return dist
    }
    
    /// Filters events by a given distance and returns the filtered events
    private func filterByDistance(events: [Event], currentLocation: EventLocation, distance: Double) -> [Event] {
        var filtered = [Event]()
        for event in events {
            if let lat = event.location?.latitude, let lon = event.location?.longitude {
                let distFromCurrLocation = distanceInMiles(lat1: currentLocation.latitude,
                                                           lon1: currentLocation.longitude, lat2: lat, lon2: lon)
                if distFromCurrLocation <= distance {
                    print("curr: \(distFromCurrLocation) dist:\(distance)")
                    filtered.append(event)
                }
            }
        }
        return filtered
    }
    @objc func refresh(_ sender:Any)
    {
        // Updating your data here...
        ApiEvent.getUnviewedEventFilter(uid: user.uid, categories: categoryFilters) { apiEvents in
            events = apiEvents
            if let distance = distanceFilter, let currentLocation = currentLocation {
                events = self.filterByDistance(events: events, currentLocation: currentLocation, distance: distance)
            }
            if sortedCheck[0] == 1{
                events.sort(by: {return $0.dates.startDate < $1.dates.startDate})
            }
            if sortedCheck[1] == 1{
                if let currentLocation = currentLocation {
                    events.sort(by: {
                        guard let lat = $0.location?.latitude, let lon = $0.location?.longitude, let lat2 = $1.location?.latitude, let lon2 = $1.location?.longitude else {return false}
                        return self.distanceInMiles(lat1: currentLocation.latitude, lon1: currentLocation.longitude, lat2: lat, lon2: lon) < self.distanceInMiles(lat1: currentLocation.latitude, lon1: currentLocation.longitude, lat2: lat2, lon2: lon2)})
                }
            }
            if sortedCheck[2] == 1{
                events.sort(by: {return $0.numDown > $1.numDown})
            }
            self.refreshControl.endRefreshing()
            self.Feed.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action:  #selector(refresh(_:)), for: .valueChanged)
        DataManager.shared.firstVC = self
        registerFilterNib()
        checkLocationServices()
        self.setUpFeed()
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
      break
    case .notDetermined:
      // Prompt a request
      locationManager.requestWhenInUseAuthorization()
      break
    case .restricted:
      // Show alert letting them know what's up
      break
    case .authorizedAlways:
      // I guess we do stuff here too
      break
    default:
      print("shit")
      break
    }
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
