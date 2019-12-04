//
//  FilterView.swift
//  Down?
//
//  Created by James Lu on 11/20/19.
//

import UIKit
import Firebase


var finalChecked = [0, 0, 0, 0, 0]
var finalDistanceCheck = [1, 0, 0, 0, 0]
var distanceCheck = [1, 0, 0, 0, 0]
var checked = [0, 0, 0, 0, 0]

var categories = ["Studying", "Sports", "Gaming", "Eating", "Other"]
var categoryFilters = [String]()

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
        anyDistanceButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        distanceCheck[0] = 1
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
        for n in 0...checked.count-1{
            if (checked[n] == 1){
                finalChecked[n] = 1
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
        //weak var vc = presentingViewController as? HomeViewController
        checked = finalChecked
        distanceCheck = finalDistanceCheck
//        if let latitude = vc?.locationManager.location?.coordinate.latitude, let longitude = vc?.locationManager.location?.coordinate.longitude {
//            let location = EventLocation(latitude: latitude, longitude: longitude)
//
//        }
//        else {
//            print("sumting wong")
//        }
      
      ApiEvent.getUnviewedEventFilter(uid: user.uid, categories: categoryFilters, distance: distanceFilter, currentLocation: currentLocation) { events in
//          vc?.events = events
//          vc?.Feed.reloadData()
        print("success")
          self.dismiss(animated: true, completion: nil)
      }
        
    }
    
    
    
}
