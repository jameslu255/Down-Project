//
//  CreateEventController.swift
//  Down?
//
//  Created by Maxim Chiao on 11/10/19.
//

import UIKit
import MapKit
import Contacts
import DateTimePicker

class CreateEventController: UIViewController, CLLocationManagerDelegate, DateTimePickerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var eventNameField: UITextField!
  
  @IBOutlet weak var eventStartField: UITextField!
  
  @IBOutlet weak var eventEndField: UITextField!
  
  @IBOutlet weak var eventLocation: UITextField!
  @IBOutlet weak var eventDescription: DescriptionBox!
  
  let locationManager = CLLocationManager()
  let geoCoder = CLGeocoder()
  
  var startDate: Date?
  var endDate: Date?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    eventStartField.delegate = self
    eventEndField.delegate = self
    eventStartField.tag = 0
    eventEndField.tag = 1
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.requestWhenInUseAuthorization()
    
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error:: \(error)")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      geoCoder.reverseGeocodeLocation(location) { placemarks, error in
        if let address = placemarks?[0].postalAddress {
          let location = "\(address.street), \(address.city), \(address.state)"
          self.eventLocation.text = location
        }
        if (error != nil) {
          print("Error")
        }
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // If location services are allowed
    if (status != CLAuthorizationStatus.notDetermined && status != CLAuthorizationStatus.restricted && status != CLAuthorizationStatus.denied) {
      manager.requestLocation()
    }
  }
  
  func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
    title = picker.selectedDateString
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let min = Date()
    let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
    
    let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
    picker.todayButtonTitle = "Reset"
    picker.is12HourFormat = true
    picker.dateFormat = " MM/dd/YYYY, hh:mm aa"
    picker.completionHandler = { date in
      if (textField.tag == 0) {
        // Start date entered
        self.startDate = date
      }
      else if (textField.tag == 1) {
        // End date entered
        self.endDate = date
      }
      let formatter = DateFormatter()
      formatter.dateFormat = "MM/dd/YYYY, hh:mm aa"
      self.title = formatter.string(from: date)
      textField.text = formatter.string(from: date)
      textField.resignFirstResponder()
      // Start/End time validation
    }
    picker.dismissHandler = {
      textField.resignFirstResponder()
    }
    picker.delegate = self
    textField.inputView = picker
  }

}
