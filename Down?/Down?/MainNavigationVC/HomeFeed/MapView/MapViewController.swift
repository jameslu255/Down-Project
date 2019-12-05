//
//  MapViewController.swift
//  Down?
//
//  Created by Maxim Chiao on 12/3/19.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var eventsFilter: UISegmentedControl!
  
  let locationManager = CLLocationManager()
  let regionInMeters = 200.0
  
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
  
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
      // If the filter settings are changed, reload the annotations
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
  
  // Loads events based on the filter selected. Returns array of events that map will use to make annotations
    func loadEvents(filterIndex: Int, completion: @escaping ([Event])->()) {
        switch filterIndex {
        case 0:
            completion(events)
        case 1:
            if let uid = Auth.auth().currentUser?.uid {
                ApiEvent.getDownEvents(uid: uid) { newEvents in
                    completion(newEvents)
                }
            }
        case 2:
            if let uid = Auth.auth().currentUser?.uid {
                ApiEvent.getDownEvents(uid: uid) { newEvents in
                    let all = events + newEvents
                    completion(all)
                }
            }
        default:
            completion([])
        }
    }
    
    func setupAnnotations() {
      // Gets the events and then transforms them into event annotations
        loadEvents(filterIndex: eventsFilter.selectedSegmentIndex) { events in
            let annotations:[MKAnnotation] = events.compactMap({
              guard let location = $0.location else {
                return nil
              }
              let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
              let annotation = EventPin(event: $0, coordinate: coordinate)
              return annotation
            })
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotations(annotations)
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
      print("Something went wrong")
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
    
    // When annotations are added, add the event details popup into their view so the details are shown when the pin is pressed on
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "eventAnno")
    annotationView.canShowCallout = true
    let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
    if let eventDetails = storyboard.instantiateViewController(identifier: "eventDetailsPopup") as? EventDetailsPopupViewController, let anno = annotation as? EventPin {
      eventDetails.event = anno.event
      annotationView.detailCalloutAccessoryView = eventDetails.view
    }
    
    return annotationView
  }
}

// Custom annotation for pins on HomeFeed map
class EventPin: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  // This event gets passed to another view later
  var event: Event?
  
  init(event: Event, coordinate: CLLocationCoordinate2D) {
    self.event = event
    self.coordinate = coordinate
  }
}
