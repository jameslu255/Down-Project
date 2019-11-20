//
//  HomeViewController.swift
//  Down?
//
//  Created by Caleb Bolton on 11/13/19.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var Feed: UICollectionView!
    @IBOutlet weak var BottomMenuBar: UIView!
    @IBOutlet weak var GradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Feed.dataSource = self
        self.setUpFeed()
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = Feed.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)

        return cell
    }

    private func setUpFeed(){
        Feed.register(EventCell.self, forCellWithReuseIdentifier: "cellId")
        Feed.delegate = self
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Feed.frame.width, height: 200)
    }
}


class EventCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemBackground
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.cornerRadius = 10
        setupViews()
    }
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Matloff_Thanos")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Prof. Matloff"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let downButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.titleLabel?.text = "Down?"
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    
    func setupViews(){
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        //addSubview(downButton)
        
        addConstraintWithFormat(format: "H:|-16-[v0(40)]-8-[v1]", views: userProfileImageView, userNameLabel)
        addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .centerY, relatedBy: .equal, toItem: userProfileImageView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintWithFormat(format: "V:|-16-[v0(40)]", views: userProfileImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
