//
//  CollectionViewCell.swift
//  Down?
//
//  Created by James Lu on 11/20/19.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, UIViewControllerTransitioningDelegate{

    @IBOutlet weak var buttonLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class var reuseIdentifier: String {
        return "CollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "CollectionViewCell"
    }
    
    // sets the look of the cell
    func configureCell(buttonName: String) {
        self.buttonLabel.setTitle(buttonName, for: .normal)
        self.buttonLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: DataManager.shared.firstVC.collectionView.bounds.width/5.45, bottom: 5, right: DataManager.shared.firstVC.collectionView.bounds.width/5.45)
        self.buttonLabel.layer.cornerRadius = 10
        self.buttonLabel.layer.borderWidth = 1
        self.buttonLabel.layer.borderColor = UIColor.gray.cgColor
    }
    
    // this function allows us to present part of a view controller
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    //function is called whenever a button is pressed within the collection view.
    @IBAction func ButtonPressed(_ sender: Any) {
        if (buttonLabel.currentTitle == "Filter"){
            let storyboard = UIStoryboard(name: "FilterButton", bundle: nil)
            let newController = storyboard.instantiateViewController(withIdentifier: "FilterView")
            DataManager.shared.firstVC.present(newController, animated: true, completion: nil)
        }
        if (buttonLabel.currentTitle == "Sort"){
            let storyboard = UIStoryboard(name: "FilterButton", bundle: nil)
            let newController = storyboard.instantiateViewController(withIdentifier: "SortView")
            
            newController.modalPresentationStyle = UIModalPresentationStyle.custom
            newController.transitioningDelegate = self
            
            // adds a dim view to the back
            let dimView = UIView(frame: UIScreen.main.bounds)
            dimView.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
            dimView.tag = 100
            dimView.isUserInteractionEnabled = true
            // adds the subview to homeViewcontroller
            DataManager.shared.firstVC.view.addSubview(dimView)
            DataManager.shared.firstVC.view.bringSubviewToFront(dimView)
            DataManager.shared.firstVC.present(newController, animated: true, completion: nil)
        }
        
    }
    
}

// Function that changes the view of the presented view so that only some of it is shown.
class HalfSizePresentationController : UIPresentationController {
     override var frameOfPresentedViewInContainerView: CGRect {
           get {
               guard let theView = containerView else {
                   return CGRect.zero
               }
               return CGRect(x: 0, y: theView.bounds.height * 2/3, width: theView.bounds.width, height: theView.bounds.height/3)
           }
       }
}

