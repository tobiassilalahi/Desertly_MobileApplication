//
//  ExtensionClassFile.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 10/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import UIKit


extension UIImageView {
    func setRoundedImage() {
        self.layer.cornerRadius = self.frame.height/2
    }
}

extension UIView {
    func setHalloShadow() {
       self.layer.cornerRadius  = 10
       self.layer.shadowRadius  = 3
       self.layer.shadowOpacity = 0.3
       self.layer.shadowOffset  = CGSize(width: 1, height: 1)
       self.layer.shadowColor   = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
    }
}
