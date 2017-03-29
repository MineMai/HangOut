//
//  HostListCell.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/22.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class HostListCell: UITableViewCell {
    
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hostImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = hostImage.layer
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
