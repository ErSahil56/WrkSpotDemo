//
//  ListTableViewCell.swift
//  WrkSpot
//
//  Created by Sahil Garg on 18/05/24.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalNameLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var cellModel: CountryModel? {
        didSet {
            if let model = cellModel {
                countryNameLabel.text = model.name
                capitalNameLabel.text = "Capital: " + (model.capital ?? "")
                currencyLabel.text = "Currency: " + (model.currency ?? "")
                populationLabel.text = "Population: " + "\(model.population ?? 0)"
                if let imageStr = model.media?.flag, !imageStr.isEmpty , let imageUrl = URL(string: imageStr) {
                    countryFlagImageView.sd_setImage(with: imageUrl)
                }
            }
        }
    }
    
}
