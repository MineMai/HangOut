//
//  ReviewCell.swift
//  AllTogeter
//
//  Created by YenShao on 2017/4/2.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    @IBOutlet weak var reviewCellImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reviewCellImage.layer.cornerRadius = 45
    }
    
}
