//
//  SortView.swift
//  Down?
//
//  Created by James Lu on 11/21/19.
//

import UIKit
import Firebase

var sortedCheck = [1, 0, 0]

class SortView: UIViewController{
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var downsButton: UIButton!
    
    var user: User = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // reset the values
        for n in 0...sortedCheck.count-1{
            if (n == 0 && sortedCheck[n] == 1)
            {
                timeButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
            if (n == 1 && sortedCheck[n] == 1){
                distanceButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
            if (n == 2 && sortedCheck[n] == 1){
                downsButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
        }
    }
    // resets the buttons back to default
    func resetAllButtons(){
        timeButton.setImage(UIImage(systemName: "circle"), for: .normal)
        distanceButton.setImage(UIImage(systemName: "circle"), for: .normal)
        downsButton.setImage(UIImage(systemName: "circle"), for: .normal)
        for n in 0...sortedCheck.count - 1{
            sortedCheck[n] = 0
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismissAndClear()
    }
    // removes the dim subview then dismisses
    func dismissAndClear(){
        let vc = self.presentingViewController
        if let viewWithTag = vc?.view.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("Could not remove dim")
        }
        dismiss(animated: true, completion: nil)
    }

    //https://www.geodatasource.com/developers/swift
    ///  This function converts decimal degrees to radians
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
    
    @IBAction func timePressed(_ sender: Any) {
        resetAllButtons()
        timeButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        sortedCheck[0] = 1
        //sort events then reload data
        events.sort(by: {return $0.dates.startDate < $1.dates.startDate})
        DataManager.shared.firstVC.Feed.reloadData()
        dismissAndClear()
        
    }
    @IBAction func distancePressed(_ sender: Any) {
        resetAllButtons()
        distanceButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        sortedCheck[1] = 1
        // sorts by distance then reload data
        if let currentLocation = currentLocation {
            events.sort(by: {
                guard let lat = $0.location?.latitude, let lon = $0.location?.longitude, let lat2 = $1.location?.latitude, let lon2 = $1.location?.longitude else {return false}
                return distanceInMiles(lat1: currentLocation.latitude, lon1: currentLocation.longitude, lat2: lat, lon2: lon) < distanceInMiles(lat1: currentLocation.latitude, lon1: currentLocation.longitude, lat2: lat2, lon2: lon2)})
        }
        DataManager.shared.firstVC.Feed.reloadData()
        dismissAndClear()
    }
    @IBAction func downsPressed(_ sender: Any) {
        resetAllButtons()
        downsButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        sortedCheck[2] = 1
        // sort by number of downs then reload data
        events.sort(by: {return $0.numDown > $1.numDown})
        DataManager.shared.firstVC.Feed.reloadData()
        dismissAndClear()
    }
    
}

