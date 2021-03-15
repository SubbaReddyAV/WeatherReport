//
//  LocationTableViewCell.swift
//  Weather
//
//  Created by SubbaReddy on 11/3/2564 BE.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak private var locationLabel1: UILabel!
    @IBOutlet weak private var locationLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(location1: String, location2: String) {
        locationLabel1.text = location1
        locationLabel2.text = location2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        autoresizingMask = .flexibleWidth
        layoutIfNeeded()
    }
}
