//
//  AllowTBVCell.swift
//  AllTogeter
//
//  Created by YenShao on 2017/4/2.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class AllowTBVCell: UITableViewCell {
    
    @IBOutlet weak var allowImage: UIImageView!
    
    @IBOutlet weak var allowName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //圖片圓型
        let layer = allowImage?.layer
        layer?.cornerRadius = 30
        layer?.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
