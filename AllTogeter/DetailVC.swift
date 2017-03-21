//
//  DetailVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var detailTimeLable: UILabel!
    
    @IBOutlet weak var detailPeopleLabel: UILabel!
    
    @IBOutlet weak var detailKindLabel: UILabel!
    
    @IBOutlet weak var detailPlaceLabel: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    
    var detailindex:Int?
    var indexImage:UIImage?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = detailindex
        {
            let showTimeLabel = actMsg[index].time
            let showPlaceLabel = actMsg[index].place
            let showPeopleLabe = actMsg[index].people
            let showKindLabel = actMsg[index].kind
            
            detailTimeLable.text = String(showTimeLabel)
            detailPeopleLabel.text = String(showPeopleLabe)
            detailKindLabel.text = String(showKindLabel)
            detailPlaceLabel.text = String(showPlaceLabel)
            navigationItem.title = actMsg[index].topic
            
            detailImage.image = forAllActVCtoShowImg[index]
            
        }

        
    }

    
    
    @IBAction func goMapBtn(_ sender: UIButton)
    {
        
    }
    
    //MARK: preparForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goMapSegue"
        {
            let mapvc = segue.destination as? MapVC
            mapvc?.targetLocation = detailPlaceLabel.text
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func applyBtn(_ sender: UIButton)
    {
        
        
    }
    

    

}















