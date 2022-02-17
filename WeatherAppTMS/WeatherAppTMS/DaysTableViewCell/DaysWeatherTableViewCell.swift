//
//  DaysWeatherTableViewCell.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 12.01.22.
//

import UIKit

class DaysWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var daysWeatherTableViewCell: UIView!
    @IBOutlet weak var daysWeatherLabel: UILabel!
    @IBOutlet weak var daysWeatherImageView: UIImageView!
    
    override var reuseIdentifier: String? {
        return "DaysWeatherTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        daysWeatherTableViewCell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
