//
//  CollectionViewCell.swift
//  NafiveTestTask
//
//  Created by Ivy on 11.09.2022.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourlLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
