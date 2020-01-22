//
//  MyCollectionViewCell.swift
//  BackpackConfigurator
//
//  Created by Vojtěch Srb on 19/02/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    var oldColor = UIColor.brown
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                oldColor = (self.backgroundColor)!
            }
            else {
                self.backgroundColor = oldColor
                self.transform = CGAffineTransform.identity
            }
        }
    }
}
