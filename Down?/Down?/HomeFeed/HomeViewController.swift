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
    
    let cellSpacing: CGFloat = 5.0
    let numTestCells: Int = 50
    
    var events: [Event] = {
        var events: [Event] = []
        let userPic = UIImage(named: "Matloff")
        let user = DownUser(name: "Prof. Matloff", profilePicture: userPic)
        let duration = Duration(startTime: Date(), endTime: Date())
        
        let event = Event(user: user, title: "Free styling about mailing tubes", duration: duration, description: "Come thruuuuuu", numDown: 43, location: "1234 Statistics Rd.", coordinates: nil, isPublic: false)
        
        let user2Pic = UIImage(named: "Sam")
        let user2 = DownUser(name: "Sam King", profilePicture: user2Pic)
        let duration2 = Duration(startTime: Date(timeIntervalSince1970: 0), endTime: Date(timeIntervalSince1970: 60))
        let event2 = Event(user: user2, title: "Dropping some sick beats about cyber security", duration: duration2, description: "", numDown: 500, location: "The MF White House. Through the front doors and on the first right.", coordinates: nil, isPublic: false)
        
        for n in 1...50{
            events.insert(event, at: 0)
            events.insert(event2, at: 0)
        }
        
        
        return events
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Feed.dataSource = self
        self.Feed.rowHeight = UITableView.automaticDimension
        self.Feed.estimatedRowHeight = UITableView.automaticDimension
        self.setUpFeed()
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
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
