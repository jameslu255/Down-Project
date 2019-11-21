//
//  FilterView.swift
//  Down?
//
//  Created by James Lu on 11/20/19.
//

import UIKit


var finalChecked = [0, 0, 0, 0, 0]
class FilterView: UIViewController {
    @IBOutlet weak var StudyingButton: UIButton!
    @IBOutlet weak var SportsButton: UIButton!
    @IBOutlet weak var GamingButton: UIButton!
    @IBOutlet weak var EatingButton: UIButton!
    @IBOutlet weak var OtherButton: UIButton!
    
    var checked = [0, 0, 0, 0, 0]
    override func viewDidLoad() {
        super.viewDidLoad()
        let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
        for n in 0...finalChecked.count-1{
            if (n == 0 && finalChecked[n] == 1){
                StudyingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 1 && finalChecked[n] == 1){
                SportsButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 2 && finalChecked[n] == 1){
                GamingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 3 && finalChecked[n] == 1){
                EatingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
            if (n == 4 && finalChecked[n] == 1){
                OtherButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            }
        }
    }
    @IBAction func ResetPressed(_ sender: Any) {
        let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        StudyingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        SportsButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        GamingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        EatingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        OtherButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
        for n in 0...checked.count-1{
            checked[n] = 0
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func StudyingPressed(_ sender: Any) {
        if (checked[0] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            StudyingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[0] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            StudyingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[0] = 0
        }
    }
    
    @IBAction func SportsPressed(_ sender: Any) {
        if (checked[1] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            SportsButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[1] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            SportsButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[1] = 0
        }
    }
    @IBAction func GamingPressed(_ sender: Any) {
        if (checked[2] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            GamingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[2] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            GamingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[2] = 0
        }
    }
    @IBAction func EatingPressed(_ sender: Any) {
        if (checked[3] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            EatingButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[3] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            EatingButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[3] = 0
        }
    }
    @IBAction func OtherPressed(_ sender: Any) {
        if (checked[4] == 0)
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 18.25, weight: .bold, scale: .large)
            OtherButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: checkSize), for: .normal)
            checked[4] = 1
        }
        else
        {
            let checkSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            OtherButton.setImage(UIImage(systemName: "stop", withConfiguration: checkSize), for: .normal)
            checked[4] = 0
        }
    }
    
    
    @IBAction func ApplyPressed(_ sender: Any) {
        for n in 0...checked.count-1{
            if (checked[n] == 1){
                finalChecked[n] = 1
            }
            else{
                finalChecked[n] = 0
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
