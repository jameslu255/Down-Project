//
//  EventCellCollectionViewCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/15/19.
//

import UIKit


// Generic UITableViewCell that displays event information
class EventCell: UITableViewCell {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var durationLabelBackgroundView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var CellSpacer: UIView!
    @IBOutlet weak var nonSpacerArea: UIView!
    @IBOutlet weak var numDownLabel: UILabel!
    @IBOutlet weak var NumDownView: UIView!
    
    var view: UIView?
    
    // When the event object of the cell is set, load all the UIViews with their corresponding data in the event object
    var event: Event? {
        didSet {
            usernameLabel.text = self.event?.originalPoster
            eventTitleLabel.text = self.event?.title == "" ? "No title" : self.event?.title ?? "No title"
            numDownLabel.text = String(self.event?.numDown ?? 0)
            durationLabel.text = self.event?.stringShortFormat
        }
    }

    let nibName = "EventCell"
        
    func commonInit() {
        setupCellView()
        setupSubviews()
    }
    
    func setupCellView() {
        guard let view = loadFromNib() else {print("PROBLEMO"); return}
        self.view = view
        self.contentView.addSubview(view)
        self.selectionStyle = .none
        self.view?.frame = self.contentView.bounds
    }
    
    func setupSubviews(){
        durationLabelBackgroundView.layer.cornerRadius = 5
        addressButton.layer.cornerRadius = 5
        NumDownView.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.view?.frame = self.contentView.bounds
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        if let eventLocation = event?.location {
            openMap(location: eventLocation)
        }
    }
    
    func loadFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
}
