//
//  SearchTBVCell.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/30.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class SearchTBVCell: UITableViewCell {
    
    @IBOutlet weak var searchImage: UIImageView!
    
    @IBOutlet weak var searchTopicLabel: UILabel!
    
    @IBOutlet weak var searchTimeLabel: UILabel!
    
    @IBOutlet weak var searchKindLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
