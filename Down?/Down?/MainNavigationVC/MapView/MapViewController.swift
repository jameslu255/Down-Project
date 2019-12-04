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
  
  var events:[Event] = []
  
  let locationManager = CLLocationManager()
  let regionInMeters = 500.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    setupMapView()
    setupAnnotations()
  }
  
  func setupMapView() {
    map.delegate = self
    map.showsUserLocation = true
    map.isRotateEnabled = false
    map.isZoomEnabled = false
    map.isScrollEnabled = false
    
    if let coordinate = locationManager.location?.coordinate {
      let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
      map.setRegion(region, animated: true)
    }
  }
  
  func setupAnnotations() {
    let annotations:[MKAnnotation] = self.events.compactMap({
      guard let location = $0.location else {
        return nil
      }
      let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      let annotation = EventPin(event: $0, coordinate: coordinate)
      return annotation
    })
    map.removeAnnotations(map.annotations)
    map.addAnnotations(annotations)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if (annotation is MKUserLocation) {
      return nil
    }
    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "eventAnno")
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    // Display event info
  }
}
