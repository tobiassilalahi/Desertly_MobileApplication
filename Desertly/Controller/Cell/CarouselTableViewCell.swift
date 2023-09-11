//
//  CarouselTableViewCell.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 10/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import UIKit
import SDWebImage

class CarouselTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var carouselCard: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodImage.setRoundedImage()
        carouselCard.layer.shadowColor   = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        carouselCard.layer.shadowOffset  = CGSize(width: 0.75, height: 0.75)
        carouselCard.layer.shadowRadius  = 3
        carouselCard.layer.shadowOpacity = 0.15
        carouselCard.layer.cornerRadius  = 10
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCookCell(Cook : Cook) {
        self.foodImage.layer.borderColor = UIColor("#E0E0E0").cgColor
        self.foodImage.layer.borderWidth = 3
        self.foodImage.sd_setImage(with: URL(string: Cook.image!))
        self.foodName.text = Cook.recipeName
        self.sourceLabel.text = Cook.source
        self.ratingLabel.text = "\(Cook.cookTime!) minutes"
        self.cuisineLabel.text = "\(Cook.calories!) calories"
    }

}
