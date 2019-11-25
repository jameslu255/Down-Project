//
//  HomeViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/13/19.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var Feed: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // USING BANG HERE, NEED TO FIGURE OUT WAY TO DEAL WITH THIS
    var user: User = Auth.auth().currentUser!
    var buttons = ["Filter", "Sort", "Search", "Location", "Some", "Other", "Buttons", "That", "I", "Put", "In", "Here", "To", "Test", "Functionality"]
    
    let cellSpacing: CGFloat = 5.0
    let numTestCells: Int = 50
        
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        Feed.dataSource = self
        self.setUpFeed()
        
        ApiEvent.getUnviewedEvent(uid: user.uid) { apiEvents in
            self.events = apiEvents
            self.Feed.reloadData()
        }
    }
    
    func registerNib() {
        let nib = UINib(nibName: CollectionViewCell.nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
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
