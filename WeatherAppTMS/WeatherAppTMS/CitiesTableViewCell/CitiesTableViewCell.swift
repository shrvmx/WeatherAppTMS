//
//  CitiesTableViewCell.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 23.01.22.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override var reuseIdentifier: String? {
        return "CitiesTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
