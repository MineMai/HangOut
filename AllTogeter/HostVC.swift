//
//  HostVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/28.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class HostVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var hostCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostCollectionView.delegate = self
        hostCollectionView.dataSource = self
        hostCollectionView.decelerationRate = UIScrollViewDecelerationRateFast

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        hostCollectionView.reloadData()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hostMsg.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostCell", for: indexPath) as! HostCell
        
        cell.imageView.image = nil
        cell.topicLabel.text = hostMsg[indexPath.row].topic
        cell.timeLabel.text = hostMsg[indexPath.row].time
        cell.placeLabel.text = hostMsg[indexPath.row].place
        
        let cacheURL = URL(string: hostMsg[indexPath.row].imageURL)
        
        //cell.imageView.sd_setImage(with: cacheURL)
        
        cell.imageView.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        
        return cell
        
    }
    
    
    

    

}
















