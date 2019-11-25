//
//  EventCellCollectionViewCell.swift
//  Down?
//
//  Created by Caleb Bolton on 11/15/19.
//

import UIKit



class EventCell: UITableViewCell {

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var durationLabelBackgroundView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var CellSpacer: UIView!
    
    var view: UIView?
    
    var event: Event?

    let nibName = "EventCell"
        
    func commonInit() {
        guard let view = loadFromNib() else {print("PROBLEMO"); return}
        self.view = view
        self.contentView.addSubview(view)
        self.selectionStyle = .none
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.view?.frame = self.contentView.bounds
    }
    
    func loadFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setupSubviews(){
        profilePictureImageView.layer.cornerRadius = 5
        durationLabelBackgroundView.layer.cornerRadius = 5
        locationTextView.layer.cornerRadius = 5
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
