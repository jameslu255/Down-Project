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
    
    func configureCell(buttonName: String) {
        self.buttonLabel.setTitle(buttonName, for: .normal)
        //let spacing: CGFloat = 76.5
        self.buttonLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: DataManager.shared.firstVC.collectionView.bounds.width/5.45, bottom: 5, right: DataManager.shared.firstVC.collectionView.bounds.width/5.45)
        self.buttonLabel.layer.cornerRadius = 10
        self.buttonLabel.layer.borderWidth = 1
        self.buttonLabel.layer.borderColor = UIColor.gray.cgColor
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    @IBAction func ButtonPressed(_ sender: Any) {
        if (buttonLabel.currentTitle == "Filter"){
            let storyboard = UIStoryboard(name: "FilterButton", bundle: nil)
            let newController = storyboard.instantiateViewController(withIdentifier: "FilterView")
            if let topController = window?.visibleViewController() {
                topController.present(newController, animated: true, completion: nil)
            }
        }
        if (buttonLabel.currentTitle == "Sort"){
            let storyboard = UIStoryboard(name: "FilterButton", bundle: nil)
            let newController = storyboard.instantiateViewController(withIdentifier: "SortView")
            
            newController.modalPresentationStyle = UIModalPresentationStyle.custom
            newController.transitioningDelegate = self
            if let topController = window?.visibleViewController() {
                /*topController.view.mask = UIView(frame: self.frame)
                topController.view.mask?.backgroundColor  = UIColor.black.withAlphaComponent(0.7)*/
                let dimView = UIView(frame: UIScreen.main.bounds)
                dimView.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
                dimView.tag = 100
                dimView.isUserInteractionEnabled = true
                topController.view.addSubview(dimView)
                topController.view.bringSubviewToFront(dimView)
                topController.present(newController, animated: true, completion: nil)
            }
        }
        
        
    }
    
}

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

extension UIWindow {

    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIWindow.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}
