//
//  AllActTBCell.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/21.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class AllActTBCell: UITableViewCell {
    
    @IBOutlet weak var activityTopicLabel: UILabel!
    
    @IBOutlet weak var activityTimeLabel: UILabel!
    
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var activityKindLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
