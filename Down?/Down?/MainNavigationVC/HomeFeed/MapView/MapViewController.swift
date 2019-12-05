//
//  MapViewController.swift
//  Down?
//
//  Created by Maxim Chiao on 12/3/19.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet weak var map: MKMapView!
  
  //var events:[Event] = []
  
  let locationManager = CLLocationManager()
  let regionInMeters = 500.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    checkLocationAuthorization()
    setupMapView()
    setupAnnotations()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    checkLocationAuthorization()
    setupMapView()
    setupAnnotations()
  }
  
  func setupMapView() {
    map.delegate = self
    map.showsUserLocation = true
    map.isRotateEnabled = false
    map.isZoomEnabled = true
    map.isScrollEnabled = true
    
    if let coordinate = locationManager.location?.coordinate {
      let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
      map.setRegion(region, animated: true)
    }
  }
  
  func setupAnnotations() {
    let annotations:[MKAnnotation] = events.compactMap({
      guard let location = $0.location else {
        return nil
      }
      let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      let annotation = EventPin(event: $0, coordinate: coordinate)
      return annotation
    })
    map.removeAnnotations(self.map.annotations)
    map.addAnnotations(annotations)
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
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if (annotation is MKUserLocation) {
      return nil
    }
    
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "eventAnno")
    annotationView.canShowCallout = true
    let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
    if let eventDetails = storyboard.instantiateViewController(identifier: "eventDetailsPopup") as? EventDetailsPopupViewController, let anno = annotation as? EventPin {
      eventDetails.event = anno.event
      annotationView.detailCalloutAccessoryView = eventDetails.view
    }
    //annotationView.detailCalloutAccessoryView
    
    return annotationView
  }
}
