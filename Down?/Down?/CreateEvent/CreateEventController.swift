//
//  CreateEventController.swift
//  Down?
//
//  Created by Maxim Chiao on 11/10/19.
//

import UIKit
import MapKit
import Contacts
import Firebase

struct category {
  var name: String
  var isSelected: Bool
  var color: UIColor
}

class CreateEventController: UITableViewController {
  
  @IBOutlet weak var eventNameField: UITextField!
  @IBOutlet weak var startTimeLabel: UILabel!
  @IBOutlet weak var startTimePicker: UIDatePicker!
  @IBOutlet weak var endTimePicker: UIDatePicker!
  @IBOutlet weak var endTimeLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var eventDescription: UITextView!
  @IBOutlet weak var locationField: UILabel!
  @IBOutlet weak var eventType: UISegmentedControl!
  @IBOutlet weak var categories: UICollectionView!
  @IBOutlet weak var createButton: UIButton!
  var handle: AuthStateDidChangeListenerHandle?
  var user: User?
    
  var categoriesData = [
    category(name: "Studying", isSelected: false, color: .systemPurple),
    category(name: "Sports", isSelected: false, color: .systemBlue),
    category(name: "Gaming", isSelected: false, color: .green),
    category(name: "Eating", isSelected: false, color: .orange),
    category(name: "Other", isSelected: false, color: .gray)
  ]
 
  let locationManager = CLLocationManager()
  let geoCoder = CLGeocoder()
  let formatter = DateFormatter()
  
  var startDate: Date?
  var endDate: Date?
  var location: CLPlacemark?
  var currentUser: User = Auth.auth().currentUser!
  
  let keywords:[String] = ["Hangout", "Meetup", "Get together", "Rendezvous", "Chilling", "Chillaxing", "Gathering"]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableView.automaticDimension
    
    eventDescription.delegate = self
    eventDescription.addPlaceHolder()
    
    //autoFillDefaults()
    checkLocationServices()
    setUpCategories()
    
    setTimeDefaults()
    
    locationField.textColor = .lightGray
    
    let tap = UITapGestureRecognizer()
    tap.delegate = self
    view.addGestureRecognizer(tap)
  }
  
  override func viewWillAppear(_ animated: Bool) {
      handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          self.user = user
      }
  }
    
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // [START remove_auth_listener]
    Auth.auth().removeStateDidChangeListener(handle!)
    // [END remove_auth_listener]
  }
    
  // MARK: IBActions
  
  @IBAction func startTimeChanged(_ sender: UIDatePicker) {
    if let end = endDate, let start = startDate {
      if sender.date > end.addingTimeInterval(60 * -5) {
        sender.date = start
        return
      }
    }
    changeTimeLabel(of: startTimeLabel, to: sender.date)
    startDate = sender.date
  }
  
  @IBAction func endTimeChanged(_ sender: UIDatePicker) {
    if let start = startDate, let end = endDate {
      if sender.date < start {
        sender.date = end
        return
      }
    }
    changeTimeLabel(of: endTimeLabel, to: sender.date)
    endDate = sender.date
  }
  
  @IBAction func createEvent() {
    // Api call to store the data
    guard let displayName = user?.displayName, let uid = user?.uid, let eventName = eventNameField.text, let startDate = startDate, let endDate = endDate, let lat = location?.location?.coordinate.latitude, let long = location?.location?.coordinate.longitude else { return }
    
    if (eventName.isEmpty) {
      // Alert user that they need to fill in event name
      let alert = UIAlertController(title: "Event name needed", message: "Please include a name for your event", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true)
      return
    }

    // Converts categories to backend-friendly format
    var selectedCategories:[String] = categoriesData.compactMap({
      if ($0.isSelected) {
        return $0.name
      }
      return nil
    })
    
    // Auto selecting Other if no categories are selected
    if (selectedCategories.count == 0) {
      selectedCategories.append("Other")
    }
    
    let eventSegment = eventType.titleForSegment(at: eventType.selectedSegmentIndex)
    let isPublic = eventSegment == "Everyone"
    let event = Event(displayName: displayName, uid: uid, startDate: startDate,endDate: endDate, isPublic: isPublic, description: eventDescription.text, title: eventName, latitude: lat, longitude: long, categories: selectedCategories)
    
    // Successfully added to firebase if returns an ID
    guard let _ = ApiEvent.addEvent(event: event) else { return }
    ApiEvent.getUnviewedEvent(uid: currentUser.uid) { newEvents in
        events = newEvents
        loadLocations() { geoLocations in
            locations = geoLocations
            DataManager.shared.firstVC.Feed.reloadData()
        }
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Helper Functions
  func checkLocationServices() {
    if (CLLocationManager.locationServicesEnabled()){
      setUpLocationManager()
      checkLocationAuthorization()
    }
    else {
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
  
  func setUpCategories() {
    categories.delegate = self
    categories.dataSource = self
    categories.register(CategoryCell.self, forCellWithReuseIdentifier: "cell")
    categories.isScrollEnabled = true
  }
  
  func setTimeDefaults() {
    let now = Date()
    startTimePicker.minimumDate = now
    startTimePicker.maximumDate = now.addingTimeInterval((60 * 60 * 24) - (60 * 5)) // 23 hours, 55 minutes after now
    
    endTimePicker.minimumDate = now.addingTimeInterval(60 * 5) // minimum duration is 5 minutes
    endTimePicker.maximumDate = now.addingTimeInterval(60 * 60 * 24) // maximum end time is 24 hours after now
    
    startDate = now
    endDate = now.addingTimeInterval(60 * 60)
    
    // Sets the time on the picker
    endTimePicker.date = now.addingTimeInterval(60 * 60)
    
    changeTimeLabel(of: startTimeLabel, to: now)
    changeTimeLabel(of: endTimeLabel, to: now.addingTimeInterval(60 * 60))
  }
  
  func changeTimeLabel(of label: UILabel?, to date: Date) {
    if let lab = label {
      formatter.dateStyle = .short
      formatter.timeStyle = .short
      lab.text = formatter.string(from: date)
    }
  }
  
  func tableUpdates() {
    // Tells table view that there are updates coming
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  func setLocation() {
    // Unwraps the the location and sets the name if it exists
    if let loc = location, let name = loc.name {
      autoFillEventName(with: name)
      locationField.text = name
      locationField.textColor = .label
    }
  }
  
  func autoFillEventName(with name: String) {
    // Randomly assigns as hangout-related keyword
    // Structure [keyword] at [location]
    let randInt = Int.random(in: 0 ..< keywords.count)
    let eventNameString = "\(keywords[randInt]) at \(name)"
    eventNameField.text = eventNameString
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
  
  // MARK: Protocol Methods
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if (indexPath.row == 5) {
      // Properly fits the description text view into the cell
      descriptionLabel.sizeToFit()
      return UITableView.automaticDimension
    }
    if (indexPath.row == 2 && startTimePicker.isHidden) {
      // Hides the cell if it is hidden
      return 0
    }
    if (indexPath.row == 4 && endTimePicker.isHidden) {
      // Hides the cell if it is hidden
      return 0
    }
    
    // Hiding segment control FOR NOW
    if (indexPath.row == 7) {
     return 0
    }
    
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    // The time pickers and anything after event type selector shouldn't be highlighted/selectable
    return !(indexPath.row == 2 || indexPath.row == 4 || indexPath.row > 7)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    switch indexPath.row {
    case 0:
      // Event Name
      eventNameField.becomeFirstResponder()
    case 1:
      // Toggle start time picker
      startTimePicker.isHidden = !startTimePicker.isHidden
      tableUpdates()
    case 3:
      // Toggle end time picker
      endTimePicker.isHidden = !endTimePicker.isHidden
      tableUpdates()
    case 5:
      // Event description
      eventDescription.becomeFirstResponder()
    case 6:
      // segue to search location
      let nextVC = storyboard?.instantiateViewController(identifier: "searchLocation") as! SearchLocationController
      nextVC.modalPresentationStyle = .fullScreen
      
      // sets a reference to this screen so it can update the location label
      nextVC.createEventScreen = self
      present(nextVC, animated: true, completion: nil)
    case 7:
      print("segment control")
    default:
      print("something is not right here")
    }
  }
}

// MARK: Extensions

extension CreateEventController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    let areFirstResponders = eventNameField.isFirstResponder || eventDescription.isFirstResponder
    let isTouchingTable = touch.view?.isDescendant(of: tableView) ?? true
    let isTouchingField = touch.view?.isDescendant(of: eventNameField) ?? true || touch.view?.isDescendant(of: eventDescription) ?? true
    
    // If tapping over the table and no first responders, regular touch
    if (isTouchingTable && !areFirstResponders){
      return false
    }
    
    // If touching a table, but not on a field, while the keyboard is up
    if (isTouchingTable && !isTouchingField && areFirstResponders) {
      view.endEditing(true)
    }
    
    return true
  }
}

extension CreateEventController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error:: \(error)")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Updates the location label text as user moves
    guard let location = locations.last else { return }
    geoCoder.reverseGeocodeLocation(location) { placemarks, error in
      guard let place = placemarks?[0], let name = place.name else { return }
      if (self.location == nil) {
        self.location = place
      }
      guard let locationText = self.locationField.text else { return }
      if (locationText == "Location not found") {
        // If it is the default placeholder text
        self.locationField.textColor = .label
        self.locationField.text = name
        self.autoFillEventName(with: name)
      }
 
      if (error != nil) {
        print("Error")
        return
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
}

extension CreateEventController: UITextViewDelegate {
  // Emulating uitextfield place holder behavior
  func textViewDidBeginEditing(_ textView: UITextView) {
    if (textView.textColor == UIColor.lightGray) {
      textView.text = nil
      textView.textColor = .label
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if (textView.text.isEmpty) {
      textView.addPlaceHolder()
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let indexPath = IndexPath(row: 5, section: 0)
    tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    tableUpdates()
  }
}

extension CreateEventController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // Some arbitrary, made up numbers for height and width, honestly I just kinda eye-balled these
    return CGSize(width: (collectionView.frame.width/4), height: collectionView.frame.height * 0.7)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categoriesData.count
  }
  
  // Configuring the cell
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CategoryCell ?? CategoryCell()
    
    // Background color set in categoriesData[]
    cell.backgroundColor = categoriesData[indexPath.row].color
    
    let cellIsSelected = categoriesData[indexPath.row].isSelected

    // Toggles border based on selection
    cell.toggleBorder(isSelected: cellIsSelected)
    
    // Sets label as category name
    cell.setLabel(width: cell.frame.width, height: cell.frame.height, text: categoriesData[indexPath.row].name)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // When a cell is pressed, toggle selection boolean and reload the view to update borders
    categoriesData[indexPath.row].isSelected = !categoriesData[indexPath.row].isSelected
    collectionView.reloadData()
  }
}
