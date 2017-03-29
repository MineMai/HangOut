//
//  HostCell.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/28.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class HostCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageCoverView: UIView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = ZoomingLayoutConstants.Cell.featuredHeight
        let standardHeight = ZoomingLayoutConstants.Cell.standardHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        let minAlpha: CGFloat = 0.15
        let maxAlpha: CGFloat = 0.75
        
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        topicLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        timeLabel.alpha = delta
        placeLabel.alpha = delta
    }
    
    
    
    
    
    
    
    
}
















