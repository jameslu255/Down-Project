//
//  SortView.swift
//  Down?
//
//  Created by James Lu on 11/21/19.
//

import UIKit

var sortedCheck = [1, 0, 0]

class SortView: UIViewController{
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var downsButton: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
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
        
        func dismissAndClear(){
            let vc = self.presentingViewController
            if let viewWithTag = vc?.view.viewWithTag(100){
                viewWithTag.removeFromSuperview()
            }else{
                print("Could not remove dim")
            }
            dismiss(animated: true, completion: nil)
        }
        
        @IBAction func timePressed(_ sender: Any) {
            resetAllButtons()
            timeButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            sortedCheck[0] = 1
            dismissAndClear()
            
        }
        @IBAction func distancePressed(_ sender: Any) {
            resetAllButtons()
            distanceButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            sortedCheck[1] = 1
            dismissAndClear()
        }
        @IBAction func downsPressed(_ sender: Any) {
            resetAllButtons()
            downsButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            sortedCheck[2] = 1
            dismissAndClear()
        }
        
    }

