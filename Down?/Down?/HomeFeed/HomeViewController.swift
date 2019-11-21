//
//  HomeViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/13/19.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var Feed: UITableView!
    @IBOutlet weak var BottomMenuBar: UIView!
    @IBOutlet weak var FeedBottomCover: UIView!
    
    let cellSpacing: CGFloat = 5.0
    let numTestCells: Int = 50
    
    var backgroundGradient: CAGradientLayer = CAGradientLayer()
    var feedBottomCoverGradient: CAGradientLayer = CAGradientLayer()
    
    var events: [Event] = {
        var events: [Event] = []
        let userPic = UIImage(named: "Matloff")
        let user = DownUser(name: "Prof. Matloff", profilePicture: userPic)
        let duration = Duration(startTime: Date(), endTime: Date())
        
        let event = Event(user: user, title: "Free styling about mailing tubes", duration: duration, description: "Come thruuuuuu", numDown: 43, location: "545 Bainer Hall Dr, Davis, CA 95616", coordinates: nil, isPublic: false)
        
        let user2Pic = UIImage(named: "Sam")
        let user2 = DownUser(name: "Sam King", profilePicture: user2Pic)
        let duration2 = Duration(startTime: Date(timeIntervalSince1970: 0), endTime: Date(timeIntervalSince1970: 60))
        let event2 = Event(user: user2, title: "Dropping some sick beats about cyber security", duration: duration2, description: "", numDown: 500, location: "The MF White House. Through the front doors and on the first right.", coordinates: nil, isPublic: false)
        
        let testPic = UIImage()
        let testUser = DownUser(name: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.")
        let testDuration = Duration(startTime: Date(timeIntervalSince1970: 0), endTime: Date(timeIntervalSince1970: 3600))
        let testEvent = Event(user: testUser, title: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", duration: testDuration, description: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", numDown: 50, location: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", coordinates: nil, isPublic: false)
        
        
        for n in 1...50{
            events.insert(event, at: 0)
            events.insert(event2, at: 0)
            events.insert(testEvent, at: 0)
        }
        
        
        return events
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.updateGradient(gradient: backgroundGradient)
        FeedBottomCover.updateGradient(gradient: feedBottomCoverGradient)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Feed.dataSource = self
        self.Feed.rowHeight = UITableView.automaticDimension
        self.Feed.estimatedRowHeight = UITableView.automaticDimension
        self.setUpFeed()
        Feed.backgroundColor = .clear
        self.view.setGradientBackground(gradient: backgroundGradient, colorOne: .clear, colorTwo: .label, firstColorStart: 0.5, secondColorStart: 1.0)
        self.FeedBottomCover.setGradientBackground(gradient: feedBottomCoverGradient, colorOne: .clear, colorTwo: .label, firstColorStart: -1.0, secondColorStart: 1)
        Feed.clipsToBounds = false
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Feed.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        guard let eventCell = cell as? EventCell else {
            print("ISSUE")
            return cell
        }
                
        let event = events[indexPath.section]
        
        eventCell.delegate = self
        eventCell.event = event
        
        eventCell.userProfileImageView.image = event.user.profilePicture
        eventCell.userNameLabel.text = event.user.name
        eventCell.eventTitleLabel.text = event.title
        eventCell.durationLabel.text = event.duration.stringFormat
        eventCell.locationText.text = event.location
        
        return eventCell
    }
    
    

    private func setUpFeed(){
        Feed.register(EventCell.self, forCellReuseIdentifier: "cellId")
        Feed.delegate = self
        Feed.separatorStyle = .none
    }
    
    func removeEventFromFeed(event: Event){
        let index = (events as NSArray).indexOfObjectIdentical(to: event)
        if index == NSNotFound {return}

        events.remove(at: index)
        
        Feed.beginUpdates()
        Feed.deleteSections([index], with: .fade)
        Feed.endUpdates()
    }
}

extension HomeViewController: EventCellDelegate {
    func down(event: Event) {
        removeEventFromFeed(event: event)
        
        // API call to add this event to Down list
    }
    
    func notDown(event: Event) {
        removeEventFromFeed(event: event)
        
        // API call to add this event to notDown list
    }
    
    func tapped(event: Event) {
        
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        guard let eventDetailsPopup = storyboard.instantiateViewController(withIdentifier: "eventDetailsPopup") as? EventDetailsPopupViewController else {return}
        eventDetailsPopup.event = event
        self.present(eventDetailsPopup, animated: true) {
            
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
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
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
