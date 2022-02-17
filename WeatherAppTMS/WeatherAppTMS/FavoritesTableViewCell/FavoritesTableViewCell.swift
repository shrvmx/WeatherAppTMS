//
//  FavoritesTableViewCell.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 17.02.22.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    static let reuseID = "FavoritesTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
