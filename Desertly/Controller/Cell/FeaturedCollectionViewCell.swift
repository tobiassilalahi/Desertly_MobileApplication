//
//  FeaturedCollectionViewCell.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 10/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import UIKit
import SDWebImage

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var foodLabelName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
    }
    
    func setFeatureCell(Cook : Cook) {
        self.foodImage.sd_setImage(with:URL(string: Cook.image!)) { (UIImage, error, cacheType, url) in
            if error != nil {
                print(error!.localizedDescription as String)
            }
        }
        
        self.foodLabelName.text = Cook.recipeName
    }
}

