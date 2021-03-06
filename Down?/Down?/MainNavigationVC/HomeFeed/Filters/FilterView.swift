//
//  FilterView.swift
//  Down?
//
//  Created by James Lu on 11/20/19.
//

import UIKit
import Firebase

// vars to keep track of what filters were pressed
var finalChecked = [0, 0, 0, 0, 0]
var finalDistanceCheck = [1, 0, 0, 0, 0]
var distanceCheck = [1, 0, 0, 0, 0]
var checked = [0, 0, 0, 0, 0]

// categories to keep track of which values were pressed
var categories = ["Studying", "Sports", "Gaming", "Eating", "Other"]
var categoryFilters = [String]()

// distance to keep track of which distance filter was set
var distance = [nil, 0.3, 1.0, 5.0, 20.0]
var distanceFilter: Double?

class FilterView: UIViewController {
    @IBOutlet weak var studyingButton: UIButton!
    @IBOutlet weak var sportsButton: UIButton!
    @IBOutlet weak var gamingButton: UIButton!
    @IBOutlet weak var eatingButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    @IBOutlet weak var anyDistanceButton: UIButton!
    @IBOutlet weak var thirdMilesButton: UIButton!
    @IBOutlet weak var oneMileButton: UIButton!
    @IBOutlet weak var fiveMilesButton: UIButton!
    @IBOutlet weak var twentyMilesButton: UIButton!
    
    var user: User = Auth.auth().currentUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
        // use a forloop to reload the images and buttons based on what the last values were.
        for n in 0...finalDistanceCheck.count-1{
            if (n == 0 && finalDistanceCheck[n] == 1)
            {
                anyDistanceButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
            if (n == 1 && finalDistanceCheck[n] == 1){
                thirdMilesButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
            if (n == 2 && finalDistanceCheck[n] == 1){
                oneMileButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
            if (n == 3 && finalDistanceCheck[n] == 1){
                fiveMilesButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
            if (n == 4 && finalDistanceCheck[n] == 1){
                twentyMilesButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
        }
        for n in 0...finalChecked.count-1{
            if (n == 0 && finalChecked[n] == 1){
                studyingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 1 && finalChecked[n] == 1){
                sportsButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 2 && finalChecked[n] == 1){
                gamingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 3 && finalChecked[n] == 1){
                eatingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 4 && finalChecked[n] == 1){
                otherButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
        }
    }
    @IBAction func ResetPressed(_ sender: Any) {
        // sets all images back to empty check boxes
        let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        studyingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        sportsButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        gamingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        eatingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        otherButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        for n in 0...checked.count-1{
            checked[n] = 0
        }
        resetAllButtons()
        // default select any distance
        anyDistanceButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        distanceCheck[0] = 1
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // The following buttons check or uncheck values for every category
    @IBAction func StudyingPressed(_ sender: Any) {
        if (checked[0] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            studyingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[0] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            studyingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[0] = 0
        }
    }
    
    @IBAction func SportsPressed(_ sender: Any) {
        if (checked[1] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            sportsButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[1] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            sportsButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[1] = 0
        }
    }
    @IBAction func GamingPressed(_ sender: Any) {
        if (checked[2] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            gamingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[2] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            gamingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[2] = 0
        }
    }
    @IBAction func EatingPressed(_ sender: Any) {
        if (checked[3] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            eatingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[3] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            eatingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[3] = 0
        }
    }
    @IBAction func OtherPressed(_ sender: Any) {
        if (checked[4] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            otherButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[4] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            otherButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[4] = 0
        }
    }
    // this function sets all values back to default and changes the numbers associated with it
    func resetAllButtons(){
        anyDistanceButton.setImage(UIImage(systemName: "circle"), for: .normal)
        thirdMilesButton.setImage(UIImage(systemName: "circle"), for: .normal)
        oneMileButton.setImage(UIImage(systemName: "circle"), for: .normal)
        fiveMilesButton.setImage(UIImage(systemName: "circle"), for: .normal)
        twentyMilesButton.setImage(UIImage(systemName: "circle"), for: .normal)
        for n in 0...distanceCheck.count - 1{
            distanceCheck[n] = 0
        }
    }
    // buttons that identify when these buttons were selected
    @IBAction func AnyDistancePressed(_ sender: Any) {
        resetAllButtons()
        anyDistanceButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        distanceCheck[0] = 1
    }
    @IBAction func thirdMilesPressed(_ sender: Any) {
        resetAllButtons()
        thirdMilesButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        distanceCheck[1] = 1
    }
    @IBAction func oneMilePressed(_ sender: Any) {
        resetAllButtons()
        oneMileButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        distanceCheck[2] = 1
    }
    @IBAction func fiveMilesPressed(_ sender: Any) {
        resetAllButtons()
        fiveMilesButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        distanceCheck[3] = 1
    }
    @IBAction func twentyMilesPressed(_ sender: Any) {
        resetAllButtons()
        twentyMilesButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        distanceCheck[4] = 1
    }
    
    @IBAction func ApplyPressed(_ sender: Any) {
        self.showSpinner(onView: self.view)
        self.view.isUserInteractionEnabled = false
        // erase previous category filters back to empty
        categoryFilters = []
        for n in 0...checked.count-1{
            if (checked[n] == 1){
                finalChecked[n] = 1
                // add new categories that we want filtered out into categoryFilters
                categoryFilters.append(categories[n])
            }
            else{
                finalChecked[n] = 0
            }
        }
        for n in 0...distanceCheck.count-1{
            if (distanceCheck[n] == 1){
                finalDistanceCheck[n] = 1
                distanceFilter = distance[n]
            }
            else{
                finalDistanceCheck[n] = 0
            }
        }
        //change the checked and distanceCheck arrays to match their final counterparts
        checked = finalChecked
        distanceCheck = finalDistanceCheck

        // filters out the events from the home view.
        ApiEvent.getUnviewedEventFilter(uid: user.uid, categories: categoryFilters) { newEvents in
            self.removeSpinner()
            self.view.isUserInteractionEnabled = true
            events = newEvents
            if let distance = distanceFilter, let currentLocation = currentLocation {
                //filters all events that are too far from current location based on selection.
                events = filterByDistance(events: events, currentLocation: currentLocation, distance: distance)
            }
            // properly sorts the event table
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
                //re-enable user interaction
                self.removeSpinner()
                self.view.isUserInteractionEnabled = true
                //reload table before dismissing
                locations = geoLocations
                DataManager.shared.firstVC.Feed.reloadData()
                self.dismiss(animated: true, completion: nil)

            }
            
        }
        
    }
    
    
    
}
