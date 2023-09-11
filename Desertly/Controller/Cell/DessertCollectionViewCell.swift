//
//  DessertCollectionViewCell.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 11/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import UIKit
import SDWebImage

protocol dessertTapped {
    func responseTapped(Cell: DessertCollectionViewCell)
}

class DessertCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionCard: UIView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dessertImage: UIImageView!
    @IBOutlet weak var dessertName: UITextView!
    
    var delegate : dessertTapped?
    
    override func awakeFromNib() {
         super.awakeFromNib()
         self.layer.shadowRadius = 3
         self.layer.cornerRadius = 5
         self.layer.shadowOffset = CGSize(width: 1, height: 1)
         self.layer.shadowOpacity = 0.2
         self.layer.shadowColor   = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
         self.collectionCard.layer.cornerRadius = 10
                 
         dessertImage.layer.cornerRadius  = 5
         dessertImage.layer.masksToBounds = true
         dessertImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         dessertImage.backgroundColor = UIColor.black
     }
    
    @IBAction func collectionTapped(_ sender: Any) {
        delegate?.responseTapped(Cell: self)
    }
    
    func configureDessert(Cook : Cook) {
        self.dessertName.text = Cook.recipeName
        self.dessertImage.sd_setImage(with: URL(string: Cook.image!))
        self.sourceLabel.text = Cook.source
        if (dessertName.text == "") {
            self.isUserInteractionEnabled = false
        }else {
            self.isUserInteractionEnabled = true
        }
    }
}
