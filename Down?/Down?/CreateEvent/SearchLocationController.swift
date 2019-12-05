//
//  SearchLocationController.swift
//  Down?
//
//  Created by Maxim Chiao on 11/20/19.
//

import UIKit
import MapKit

class SearchLocationController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet var tapGesture: UITapGestureRecognizer!
  
  let locationManager = CLLocationManager()
  //var userLocation: CLLocation?
  let regionInMeters = 200.0
  
  let geoCoder = CLGeocoder()
  
  var selectedLocation: CLPlacemark?
  
  var createEventScreen: CreateEventController?

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.isRotateEnabled = false
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    //locationManager.requestWhenInUseAuthorization()
    checkLocationAuthorization()
    setupMapView()
  }
  
  @IBAction func addPin(_ sender: UITapGestureRecognizer) {
    let tapLocation = sender.location(in: mapView)
    let mapCoords = mapView.convert(tapLocation, toCoordinateFrom: mapView)
    let location = CLLocation(latitude: mapCoords.latitude, longitude: mapCoords.longitude)
    
    geoCoder.reverseGeocodeLocation(location) { placemarks, error in
      guard let placemark = placemarks?[0] else { return }
      
      self.selectedLocation = placemark
      
      if let name = placemark.name, let coordinate = placemark.location?.coordinate {
        let pin = LocationPin(title: name, coordinate: coordinate)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(pin)
      }
    }
  }
  
  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func centerScreen(_ sender: Any) {
    setupMapView()
  }
  
  func setupMapView() {
    if let coordinate = locationManager.location?.coordinate {
      let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
      mapView.setRegion(region, animated: true)
    }
  }
  
  func checkLocationAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      // Do something
      setupMapView()
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
  
  @objc func action(_ sender: UIButton) {
    let screen = createEventScreen!
    screen.location = selectedLocation
    screen.setLocation()
    dismiss(animated: true, completion: nil)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if (annotation is MKUserLocation) {
      return nil
    }
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "anno")
    let button = UIButton(type: .contactAdd)
    button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
    
    annotationView.rightCalloutAccessoryView = button
    annotationView.canShowCallout = true
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    
    if let annotation = views.first(where: { $0.reuseIdentifier == "anno" })?.annotation {
      mapView.selectAnnotation(annotation, animated: true)
    }
  }
//  func search() {
//    let search = MKLocalSearch(request: request)
//    guard let query = request.naturalLanguageQuery else { return }
//    if (query.isEmpty) {
//      if (search.isSearching) {
//        search.cancel()
//      }
//    }
//
//    if (search.isSearching) {
//      print("cancel search")
//      search.cancel()
//    }
//    search.start { response, error in
//      guard let r = response else { print("no r")
//        return } // no r if type in gibberish
//      if (r.mapItems.isEmpty) {
//        print("no results")
//      }
//
//      for item in r.mapItems {
//        print("\(item.name!)")
//      }
//      if (error != nil) {
//        print("error")
//      }
//    }
//  }

}

extension SearchLocationController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
    mapView.setRegion(region, animated: true)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
}
