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
        
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
