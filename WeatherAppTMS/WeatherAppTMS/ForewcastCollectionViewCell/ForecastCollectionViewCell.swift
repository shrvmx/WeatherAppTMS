//
//  ForecastCollectionViewCell.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 3.12.21.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var forecastView: UIView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var forecastTemperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override var reuseIdentifier: String? {
        return "ForecastCollectionViewCell"
    }
    override var isSelected: Bool {
        didSet {
            forecastView.backgroundColor = isSelected ? UIColor.white : UIColor(red: 0.43, green: 0.78, blue: 0.83, alpha: 1.00)
        }
      }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        forecastView.layer.cornerRadius = 20
        forecastView.layer.borderWidth = 0.5
        forecastView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
}
